package main

import (
	"flag"
	"fmt"
	"os"
	"github.com/ivahaev/amigo"
)

// DeviceStateChangeHandler .
func DeviceStateChangeHandler(m map[string]string) {
	fmt.Printf("DeviceStateChange event received: %v\n", m)
}

// DefaultHandler .
func DefaultHandler(m map[string]string) {
	fmt.Printf("Event received: %v\n", m)
}

func main() {
	flag.Parse()
	fmt.Println("Init Amigo")

	settings := &amigo.Settings{Username: "admin", Password: "password", Host: "127.0.0.1", Port: "5038"}
	if e := os.Getenv("AMI_HOST"); len(e) > 0 {
		settings.Host = e
	}
	if e := os.Getenv("AMI_PORT"); len(e) > 0 {
		settings.Port = e
	}
	if e := os.Getenv("AMI_USERNAME"); len(e) > 0 {
		settings.Username = e
	}
	if e := os.Getenv("AMI_PASSWORD"); len(e) > 0 {
		settings.Password = e
	}

	a := amigo.New(settings)

	a.Connect()

	a.On("connect", func(message string) {
		fmt.Println("Connected", message)
	})
	a.On("error", func(message string) {
		fmt.Println("Connection error:", message)
	})

	a.RegisterHandler("DeviceStateChange", DeviceStateChangeHandler)
	a.RegisterDefaultHandler(DefaultHandler)
	c := make(chan map[string]string, 100)
	a.SetEventChannel(c)

	if a.Connected() {
		result, err := a.Action(map[string]string{"Action": "QueueSummary", "ActionID": "Init"})
		fmt.Println(result, err)
	}

	ch := make(chan bool)
	<-ch
}
