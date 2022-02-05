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
SELECT hostgroup hg, username, sum_time, count_star, digest_text FROM stats_mysql_query_digest  ORDER BY sum_time DESC LIMIT 200;
+----+----------+-------------+------------+------------------------------------------------------------+
| hg | username | sum_time    | count_star | digest_text                                                |
+----+----------+-------------+------------+------------------------------------------------------------+
| 10 | root     | 33400739205 | 916637     | UPDATE proxysql_test SET status=? WHERE id=?               |
| 10 | root     | 8569841676  | 1064261    | INSERT INTO proxysql_test (app,datetime) VALUES (?,NOW() ) |
| 20 | root     | 3050691     | 2          | SELECT * FROM proxysql_test                                |
| 20 | root     | 2222916     | 24         | select * from proxysql_test                                |
| 20 | root     | 718427      | 2          | SELECT id FROM proxysql_test                               |
| 10 | root     | 441601      | 7          | show databases                                             |
| 20 | root     | 171313      | 1          | select count(*) from proxysql_test                         |
| 20 | root     | 61949       | 7          | SELECT * FROM `users` WHERE ?=?                            |
| 20 | root     | 22277       | 7          | SELECT * FROM `proxysql_test` WHERE ?=?                    |
| 10 | root     | 16166       | 8          | show tables                                                |
| 10 | root     | 0           | 2          | KILL QUERY ?                                               |
| 10 | root     | 0           | 6          | select @@version_comment limit ?                           |
+----+----------+-------------+------------+------------------------------------------------------------+
12 rows in set (0.212 sec)
```


```
SELECT hostgroup hg, username, sum_time, count_star, digest_text FROM stats_mysql_query_digest  WHERE  digest_text LIKE '% FROM proxysql_test%' ORDER BY sum_time DESC LIMIT 200;
+----+----------+----------+------------+------------------------------------+
| hg | username | sum_time | count_star | digest_text                        |
+----+----------+----------+------------+------------------------------------+
| 20 | root     | 3050691  | 2          | SELECT * FROM proxysql_test        |
| 20 | root     | 2222916  | 24         | select * from proxysql_test        |
| 20 | root     | 718427   | 2          | SELECT id FROM proxysql_test       |
| 20 | root     | 171313   | 1          | select count(*) from proxysql_test |
+----+----------+----------+------------+------------------------------------+
4 rows in set (0.261 sec)
```

```
SELECT hostgroup hg, username, sum_time, count_star, digest_text FROM stats_mysql_query_digest  WHERE  digest_text LIKE 'UPDATE proxysql_test%' ORDER BY sum_time DESC LIMIT 200;
+----+----------+-------------+------------+----------------------------------------------+
| hg | username | sum_time    | count_star | digest_text                                  |
+----+----------+-------------+------------+----------------------------------------------+
| 10 | root     | 33400739205 | 916637     | UPDATE proxysql_test SET status=? WHERE id=? |
+----+----------+-------------+------------+----------------------------------------------+
1 row in set (0.005 sec)
+----+----------+-----------+------------+--------------------------------------------+
```

```
SELECT hostgroup, count(*) AS C FROM stats_mysql_query_digest GROUP BY hostgroup;
+-----------+---+
| hostgroup | C |
+-----------+---+
| 10        | 6 |
| 20        | 6 |
+-----------+---+
2 rows in set (0.004 sec)
```

```
SELECT * FROM stats_mysql_processlist;
+----------+-----------+------+------+------------+----------+-----------+------------+------------+--------------+----------+---------+----------+----------------------------------------------------+--------------+---------------+
| ThreadID | SessionID | user | db   | cli_host   | cli_port | hostgroup | l_srv_host | l_srv_port | srv_host     | srv_port | command | time_ms  | info                                               | status_flags | extended_info |
+----------+-----------+------+------+------------+----------+-----------+------------+------------+--------------+----------+---------+----------+----------------------------------------------------+--------------+---------------+
| 1        | 10        | root | mydb | 172.19.0.1 | 47246    | 10        | 172.19.0.8 | 33588      | mysql-master | 3306     | Query   | 19190475 | UPDATE proxysql_test SET status=1  WHERE id=916638 | 0            | NULL          |
+----------+-----------+------+------+------------+----------+-----------+------------+------------+--------------+----------+---------+----------+----------------------------------------------------+--------------+---------------+
1 row in set (0.005 sec)
```

```
SELECT * FROM stats_mysql_connection_pool;
+-----------+--------------+----------+--------+----------+----------+--------+---------+-------------+---------+-------------------+-----------------+-----------------+------------+
| hostgroup | srv_host     | srv_port | status | ConnUsed | ConnFree | ConnOK | ConnERR | MaxConnUsed | Queries | Queries_GTID_sync | Bytes_data_sent | Bytes_data_recv | Latency_us |
+-----------+--------------+----------+--------+----------+----------+--------+---------+-------------+---------+-------------------+-----------------+-----------------+------------+
| 10        | mysql-master | 3306     | ONLINE | 1        | 2        | 6      | 0       | 4           | 1980916 | 0                 | 114898076       | 735             | 232        |
| 20        | mysql-slave1 | 3306     | ONLINE | 0        | 1        | 1      | 0       | 1           | 4       | 0                 | 108             | 1340616         | 226        |
| 20        | mysql-slave2 | 3306     | ONLINE | 0        | 1        | 1      | 0       | 1           | 9       | 0                 | 287             | 42793201        | 245        |
| 20        | mysql-slave3 | 3306     | ONLINE | 0        | 1        | 1      | 0       | 1           | 5       | 0                 | 136             | 41439001        | 223        |
| 20        | mysql-slave4 | 3306     | ONLINE | 0        | 1        | 1      | 0       | 1           | 7       | 0                 | 205             | 4954858         | 217        |
| 20        | mysql-slave5 | 3306     | ONLINE | 0        | 1        | 1      | 0       | 1           | 6       | 0                 | 173             | 1362280         | 193        |
| 20        | mysql-master | 3306     | ONLINE | 0        | 2        | 2      | 0       | 1           | 12      | 0                 | 374             | 11685319        | 232        |
+-----------+--------------+----------+--------+----------+----------+--------+---------+-------------+---------+-------------------+-----------------+-----------------+------------+
7 rows in set (0.005 sec)
```

```
SELECT * FROM stats_mysql_commands_counters WHERE Total_cnt;
+---------+---------------+-----------+-----------+-----------+---------+---------+----------+----------+-----------+-----------+--------+--------+---------+----------+
| Command | Total_Time_us | Total_cnt | cnt_100us | cnt_500us | cnt_1ms | cnt_5ms | cnt_10ms | cnt_50ms | cnt_100ms | cnt_500ms | cnt_1s | cnt_5s | cnt_10s | cnt_INFs |
+---------+---------------+-----------+-----------+-----------+---------+---------+----------+----------+-----------+-----------+--------+--------+---------+----------+
| INSERT  | 8569841676    | 1064261   | 55        | 0         | 6       | 192391  | 657736   | 212913   | 743       | 409       | 8      | 0      | 0       | 0        |
| KILL    | 0             | 2         | 2         | 0         | 0       | 0       | 0        | 0        | 0         | 0         | 0      | 0      | 0       | 0        |
| SELECT  | 6247573       | 49        | 19        | 1         | 10      | 7       | 0        | 2        | 2         | 3         | 2      | 3      | 0       | 0        |
| UPDATE  | 33400739205   | 916637    | 14        | 0         | 19      | 267810  | 579766   | 68546    | 159       | 299       | 13     | 10     | 0       | 1        |
| SHOW    | 457767        | 15        | 5         | 3         | 1       | 3       | 0        | 1        | 0         | 2         | 0      | 0      | 0       | 0        |
+---------+---------------+-----------+-----------+-----------+---------+---------+----------+----------+-----------+-----------+--------+--------+---------+----------+
5 rows in set (0.005 sec)
```


#### ProxySQL UI ####

We have also enabled the web stats UI with (admin-web_enabled=true or web_enabled=true).To access the web UI, simply go to the Docker host in port **6080**, for example: **https://ip_server_docker:6080** and you will be prompted with username/password pop up. Enter the credentials as defined under admin-stats_credentials and you should see the following page:


#### TEST GO ####

```
wget https://go.dev/dl/go1.17.6.linux-amd64.tar.gz -O /usr/src/go1.17.6.linux-amd64.tar.gz
cd /usr/src
tar xvf go1.17.6.linux-amd64.tar.gz
chown -R root:root ./go
mv go /usr/local
mkdir /root/work

echo "export GOPATH=$HOME/work">> /root/.bashrc
echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> /root/.bashrc
echo "export GOROOT=/usr/local/go" >> /root/.bashrc

source /root/.bashrc
```

```
go mod init testDB
go get -v
go build -o testDB
./testDB
#go run testDB.go
```
