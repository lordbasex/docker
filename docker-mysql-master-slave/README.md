Docker MySQL master-slave replication 
========================

## What is ProxySql?

![Blank Diagram](./demo.png)


MySQL master-slave replication with using Docker. 

## Run

```
docker-compose up -d
```
 
## Troubleshooting

#### Check Logs

```
docker-compose logs
```

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
docker-compose exec mysql-master mysql -uroot -ppassword mydb -e "SHOW MASTER STATUS \G"
```

#### Run command inside "mysql-slave1" to "mysql-slave5"

```
docker-compose exec mysql-slave1 mysql -uroot -ppassword mydb -e "SHOW SLAVE STATUS \G"
```

### Check slave
```
mysql -uroot -ppassword -h127.0.0.1 -P3306 mydb
```

```
show slave hosts;
+-----------+------+------+-----------+--------------------------------------+
| Server_id | Host | Port | Master_id | Slave_UUID                           |
+-----------+------+------+-----------+--------------------------------------+
|        22 |      | 3306 |         1 | ed3fca51-8069-11ec-a78e-0242c0a84005 |
|        40 |      | 3306 |         1 | ed642236-8069-11ec-8164-0242c0a84006 |
|        11 |      | 3306 |         1 | ed5fb584-8069-11ec-a236-0242c0a84003 |
|        50 |      | 3306 |         1 | ecd284fe-8069-11ec-a3f3-0242c0a84007 |
|        30 |      | 3306 |         1 | eb6f6be2-8069-11ec-9dc3-0242c0a84004 |
+-----------+------+------+-----------+--------------------------------------+
5 rows in set (0.002 sec)
```



#### Enter into "master"

```
docker-compose exec mysql-master bash
```

#### Enter into "mysql-slave1" to "mysql-slave5"

```
docker-compose exec mysql-slave1 bash
```


#### ProxySQL ####

```
mysql -h127.0.0.1 -P6032 -uadmin2 -ppass2 --prompt "ProxySQL Admin>"
```

```
SELECT hostgroup_id, hostname, status, comment FROM runtime_mysql_servers;
```

### QUERY ###

```
SELECT hostgroup_id, hostname, status, comment FROM runtime_mysql_servers;
+--------------+--------------+--------+----------------+
| hostgroup_id | hostname     | status | comment        |
+--------------+--------------+--------+----------------+
| 10           | mysql-master | ONLINE | write and read |
| 20           | mysql-master | ONLINE | write and read |
| 20           | mysql-slave5 | ONLINE | read           |
| 20           | mysql-slave4 | ONLINE | read           |
| 20           | mysql-slave3 | ONLINE | read           |
| 20           | mysql-slave2 | ONLINE | read           |
| 20           | mysql-slave1 | ONLINE | read           |
+--------------+--------------+--------+----------------+
7 rows in set (0.002 sec)
```

```
SELECT hostgroup, srv_host, status, ConnUsed, MaxConnUsed, Queries FROM stats.stats_mysql_connection_pool ORDER BY srv_host;
+-----------+--------------+--------+----------+-------------+---------+
| hostgroup | srv_host     | status | ConnUsed | MaxConnUsed | Queries |
+-----------+--------------+--------+----------+-------------+---------+
| 10        | mysql-master | ONLINE | 0        | 0           | 0       |
| 20        | mysql-master | ONLINE | 0        | 0           | 0       |
| 20        | mysql-slave1 | ONLINE | 0        | 0           | 0       |
| 20        | mysql-slave2 | ONLINE | 0        | 0           | 0       |
| 20        | mysql-slave3 | ONLINE | 0        | 0           | 0       |
| 20        | mysql-slave4 | ONLINE | 0        | 0           | 0       |
| 20        | mysql-slave5 | ONLINE | 0        | 0           | 0       |
+-----------+--------------+--------+----------+-------------+---------+
7 rows in set (0.004 sec)
```

```
SELECT rule_id, active, match_pattern, match_digest, destination_hostgroup, cache_ttl, apply, multiplex FROM mysql_query_rules;
+---------+--------+-----------------------+-----------------------+-----------+-------+
| rule_id | active | match_pattern         | destination_hostgroup | cache_ttl | apply |
+---------+--------+-----------------------+-----------------------+-----------+-------+
| 100     | 1      | ^SELECT .* FOR UPDATE | 10                    | NULL      | 1     |
| 200     | 1      | ^SELECT .*            | 20                    | NULL      | 1     |
| 300     | 1      | .*                    | 10                    | NULL      | 1     |
+---------+--------+-----------------------+-----------------------+-----------+-------+
3 rows in set (0.003 sec)
```

### CHECK QUERY BY HOSTGROUP

```
SELECT hostgroup hg, username, sum_time, count_star, digest_text FROM stats_mysql_query_digest  WHERE  digest_text LIKE '% FROM calls%' ORDER BY sum_time DESC LIMIT 200;
+----+----------+----------+------------+--------------------------+
| hg | username | sum_time | count_star | digest_text              |
+----+----------+----------+------------+--------------------------+
| 2  | sysadmin | 653159   | 1          | SELECT callid FROM calls |
+----+----------+----------+------------+--------------------------+
```

```
SELECT hostgroup hg, username, sum_time, count_star, digest_text FROM stats_mysql_query_digest  WHERE  digest_text LIKE 'UPDATE calls%' ORDER BY sum_time DESC LIMIT 200;
+----+----------+-----------+------------+--------------------------------------------+
| hg | username | sum_time  | count_star | digest_text                                |
+----+----------+-----------+------------+--------------------------------------------+
| 1  | sysadmin | 483655930 | 1114881    | UPDATE calls SET recalled=? WHERE callid=? |
+----+----------+-----------+------------+--------------------------------------------+
```

```
SELECT hostgroup, count(*) AS C FROM stats_mysql_query_digest GROUP BY hostgroup;
+-----------+-----+
| hostgroup | C   |
+-----------+-----+
| 1         | 18  |
| 2         | 391 |
+-----------+-----+
2 rows in set (0.00 sec)
```


#### ProxySQL UI ####

We have also enabled the web stats UI with admin-web_enabled=true.To access the web UI, simply go to the Docker host in port **6080**, for example: **http://ip_server_docker:6080** and you will be prompted with username/password pop up. Enter the credentials as defined under admin-stats_credentials and you should see the following page:


#### TEST GO ####

```
wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz -O /usr/src/go1.17.6.linux-amd64.tar.gz
cd /usr/src
tar xvf go1.17.6.linux-amd64.tar.gz
chown -R root:root ./go
mv go /usr/local
echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> /root/.profile
```

```
go mod init testDB
go get -v
go build -o testDB
./testDB
#go run testDB
```
