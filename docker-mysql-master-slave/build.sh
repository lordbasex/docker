#!/bin/bash

docker-compose down
rm -rf ./user-data/
docker-compose up -d

mysql_user="mydb_slave_user"
mysql_password="mydb_slave_pwd"
root_password="111"

master_container=master
slave_containers=(slave01 slave02 slave03 slave04 slave05)
all_containers=("$master_container" "${slave_containers[@]}")
retry_duration=10

docker-ip() {
    docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$@"
}

#################### Server initialization operation ####################

for container in "${all_containers[@]}";do
  until docker exec $container sh -c 'export MYSQL_PWD='$root_password'; mysql -u root -e ";"'
  do
      echo "Waiting for $container to connect, please wait, try to connect every ${retry_duration}s, it may retry multiple times until the container is started..."
      sleep $retry_duration
  done
done

#################### Master server operation ####################

priv_stmt='GRANT REPLICATION SLAVE ON *.* TO "'$mysql_user'"@"%" IDENTIFIED BY "'$mysql_password'"; FLUSH PRIVILEGES;'

docker exec $master_container sh -c "export MYSQL_PWD='$root_password'; mysql -u root -e '$priv_stmt'"


MS_STATUS=`docker exec $master_container sh -c 'export MYSQL_PWD='$root_password'; mysql -u root -e "SHOW MASTER STATUS"'`

CURRENT_LOG=`echo $MS_STATUS | awk '{print $6}'`
CURRENT_POS=`echo $MS_STATUS | awk '{print $7}'`

#################### Operate from the server ####################

start_slave_stmt="CHANGE MASTER TO
        MASTER_HOST='$(docker-ip $master_container)',
        MASTER_USER='$mysql_user',
        MASTER_PASSWORD='$mysql_password',
        MASTER_LOG_FILE='$CURRENT_LOG',
        MASTER_LOG_POS=$CURRENT_POS;"
start_slave_cmd='export MYSQL_PWD='$root_password'; mysql -u root -e "'
start_slave_cmd+="$start_slave_stmt"
start_slave_cmd+='START SLAVE;"'


for slave in "${slave_containers[@]}";do
  docker exec $slave sh -c "$start_slave_cmd"
  docker exec $slave sh -c "export MYSQL_PWD='$root_password'; mysql -u root -e 'SHOW SLAVE STATUS \G'"
done

echo -e "\033[42;34m finish success !!! \033[0m"