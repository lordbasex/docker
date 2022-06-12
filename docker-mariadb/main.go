package main

import (
	"database/sql"
	"log"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

//decodigo.com

type Usuario struct {
	ID       int    `json:"id"`
	Username string `json:"username"`
	Password string `json:"password"`
	Email    string `json:"email"`
}

func main() {
	db, err := sql.Open("mysql", "user:userpassword@tcp(127.0.0.1:3306)/test")

	if err != nil {
		log.Print(err.Error())
	}
	defer db.Close()

	_, errCreate := db.Exec(`CREATE TABLE IF NOT EXISTS usuarios (
      id bigint(20) NOT NULL AUTO_INCREMENT,
      username varchar(100) NOT NULL,
      password varchar(100) NOT NULL,
      email varchar(100) NOT NULL,
      PRIMARY KEY (id)
    )`)
	if errCreate != nil {
		panic(err.Error())
	}

	for i := 1; i <= 1000; i++ {
		_, errInsert := db.Exec(`INSERT INTO usuarios(username, password, email) VALUES (?, ?, ?)`,
			"user"+strconv.Itoa(i),
			strconv.Itoa(i),
			"myemail"+strconv.Itoa(i)+"@test.com")
		if errInsert != nil {
			panic(err.Error())
		}
	}

	_, errDelete := db.Exec(`DELETE FROM usuarios WHERE id=?`, 4)
	if errDelete != nil {
		panic(err.Error())
	}

	_, errUPDATE := db.Exec(`UPDATE usuarios SET username=? WHERE id=?`, "useraname", 1)
	if errUPDATE != nil {
		panic(err.Error())
	}

	results, errSelect := db.Query(`SELECT id, username, password, email FROM usuarios`)
	if errSelect != nil {
		panic(err.Error())
	}

	for results.Next() {
		var usuario Usuario
		err = results.Scan(&usuario.ID, &usuario.Username, &usuario.Password, &usuario.Email)
		if err != nil {
			panic(err.Error())
		}
		log.Printf(usuario.Username + " " + usuario.Password + " " + usuario.Email)
	}
}
