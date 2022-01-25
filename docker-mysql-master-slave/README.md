Docker MySQL master-slave replication 
========================

MySQL master-slave replication with using Docker. 

## Run

Run command to configure **MySQL master-slave replication**  build.sh

```
chmod 777 build.sh
./build.sh. 
```

#### Make changes to master

```
docker exec master sh -c "export MYSQL_PWD=111; mysql -u root mydb -e 'create table code(code int); insert into code values (100), (200)'"
```

#### Read changes from slave to "slave04"

```
docker exec slave01 sh -c "export MYSQL_PWD=111; mysql -u root mydb -e 'select * from code \G'"
```

```
docker exec slave02 sh -c "export MYSQL_PWD=111; mysql -u root mydb -e 'select * from code \G'"

```

## Troubleshooting

#### Check Logs

```
docker-compose logs
```

#### Start containers in "normal" mode

> Go through "build.sh" and run command step-by-step.

#### Check running containers

```
docker-compose ps
```

#### Clean data dir

```
rm -rf ./user-data/*
```

#### Run command inside "master"

```
docker exec master sh -c 'mysql -u root -p111 -e "SHOW MASTER STATUS \G"'
```

#### Run command inside "slave01" to "slave04"

```
docker exec slave01 sh -c 'mysql -u root -p111 -e "SHOW SLAVE STATUS \G"'
```

#### Enter into "master"

```
docker-compose exec master bash
```

#### Enter into "slave01" to "slave04"

```
docker-compose exec slave01 bash
```


#### ProxySQL ####

```
mysql -h127.0.0.1 -P6032 -uradmin -pradmin --prompt "ProxySQL Admin>"
```

```
select hostgroup_id,hostname,status from runtime_mysql_servers;
```

OUT
```
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.0 (ProxySQL Admin Module)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

ProxySQL Admin>select hostgroup_id,hostname,status from runtime_mysql_servers;
+--------------+----------+--------+
| hostgroup_id | hostname | status |
+--------------+----------+--------+
| 0            | master   | ONLINE |
| 5            | slave05  | ONLINE |
| 4            | slave04  | ONLINE |
| 3            | slave03  | ONLINE |
| 2            | slave02  | ONLINE |
| 1            | slave01  | ONLINE |
+--------------+----------+--------+
6 rows in set (0.01 sec)

ProxySQL Admin>
```

#### ProxySQL UI ####

We have also enabled the web stats UI with admin-web_enabled=true.To access the web UI, simply go to the Docker host in port **6080**, for example: **http://ip_server_docker:6080** and you will be prompted with username/password pop up. Enter the credentials as defined under admin-stats_credentials and you should see the following page:
