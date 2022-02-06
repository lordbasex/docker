package main

import (
	"fmt"
	"os"

	"github.com/CyCoreSystems/agi"
)

/**
* Get env variables
**/
func goDotEnvVariable(key string) string {
	return os.Getenv(key)
}

var portFastAGI string

func main() {

	portFastAGI = goDotEnvVariable("FASTAGI_PORT")
	if portFastAGI == "" {
		portFastAGI = "8000"
	}

	fmt.Println("Port: ", portFastAGI)
	agi.Listen(":"+portFastAGI, handler)
}

func handler(a *agi.AGI) {
	defer a.Close()

	a.Answer()

	action := a.Variables["agi_arg_1"]

	switch action {

	case "prueba1":

		a.Verbose("PRUEBA 1 - VERBOSE", 1)

	case "prueba2":

		a.Verbose("PRUEBA 2 - VERBOSE", 1)
		a.Set("__VAR_GLOBAL", "es")

	case "prueba3":

		a.Verbose("PRUEBA 3 - AGI VARIABLE", 1)
		a.Verbose("RETURN ->"+a.Variables["agi_arg_1"]+"<-", 1)

	case "prueba4":

		a.Set("CHANNEL(language)", "es")
		a.Verbose("PRUEBA 4 - PLAYBACK AUDIO", 1)
		a.StreamFile("tt-monkeys", "#", 1)

	default:

		a.Verbose("DEFAULT - VERBOSE", 1)

	}

	a.Hangup()
	//os.Exit(0)
}
