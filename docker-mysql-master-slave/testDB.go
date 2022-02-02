package main

import (
	"database/sql"
	"fmt"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

/**

DROP TABLE IF EXISTS proxysql_test;

CREATE TABLE `proxysql_test` (
  `id` bigint(63) NOT NULL AUTO_INCREMENT,
  `app` varchar(50) CHARACTER SET utf8 DEFAULT '',
  `status` int(2) NOT NULL DEFAULT '0',
  `datetime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `app` (`app`) USING BTREE
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC;

**/

/**
* Get env variables
**/
func goDotEnvVariable(key string) string {
	return os.Getenv(key)
}

var host string
var port string
var username string
var password string
var database string

func main() {
	// Database testing

	host = goDotEnvVariable("MYSQL_HOST")
	if host == "" {
		host = "127.0.0.1"
	}

	port = goDotEnvVariable("MYSQL_HOST_PORT")
	if port == "" {
		port = "6033"
	}

	username = goDotEnvVariable("MYSQL_USER")
	if username == "" {
		username = "root"
	}

	password = goDotEnvVariable("MYSQL_USER_PASSWORD")
	if password == "" {
		password = "password"
	}

	database = goDotEnvVariable("MYSQL_DATABASE")
	if database == "" {
		database = "mydb"
	}

	url := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", username, password, host, port, database)
	dbAws, err := sql.Open("mysql", url)
	
	fmt.Printf(url)

	if err != nil {
		fmt.Printf(err.Error())
		panic(err.Error())
	}
	defer dbAws.Close()
	
	// Calling Sleep method
	time.Sleep(8 * time.Second)

	// query insert
	for i := 1; i < 1000001; i++ {
		sqlInsert := fmt.Sprintf("INSERT INTO proxysql_test (app, datetime) VALUES ('test', NOW() )")
		dbAws.Exec(sqlInsert)
		fmt.Printf("%d - %s\n", i, sqlInsert)
	}

	// query select
	id := 0
	result, err := dbAws.Query(fmt.Sprintf("SELECT id FROM proxysql_test "))
	if err != nil {
		panic(err.Error())
	}

	i := 1
	for result.Next() {
		result.Scan(&id)
		if err != nil {
			panic("Scan " + err.Error())
		}
		sql := fmt.Sprintf("UPDATE proxysql_test SET status=1  WHERE id=%d", id)
		dbAws.Exec(sql)
		fmt.Printf("%d - %s\n", i, sql)
		i++
	}
}
