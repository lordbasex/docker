package main

import (
	"log"
	"os"

	"github.com/CyCoreSystems/agi"
	"github.com/lordbasex/servermedia"
)

/**
* Get env variables
**/
func goDotEnvVariable(key string) string {
	return os.Getenv(key)
}

var portFastAGI string
var serverMediaURL string

func main() {

	portFastAGI = goDotEnvVariable("FASTAGI_PORT")
	if portFastAGI == "" {
		portFastAGI = "8000"
	}

	serverMediaURL = goDotEnvVariable("SERVER_MEDIA")
	if serverMediaURL == "" {
		serverMediaURL = "http://fastagi:8011/"
	}

	go servermedia.Start()

	log.Println("FastAGI Server agi://0.0.0.0:" + portFastAGI + " running...")
	agi.Listen(":"+portFastAGI, handler)

}

func handler(a *agi.AGI) {
	defer a.Close()

	a.Verbose(". .: IPERFEX FASTAGI - Copyright © 2012 - 2022 iPERFEX All Rights Reserved :.", 1)
	action := a.Variables["agi_arg_1"]

	switch action {

	case "prueba1":

		a.Answer()
		a.Verbose("PRUEBA 1 - VERBOSE", 1)

	case "prueba2":

		a.Answer()
		a.Verbose("PRUEBA 2 - VERBOSE", 1)
		a.Set("__VAR_GLOBAL", "es")

	case "prueba3":

		a.Answer()
		a.Verbose("PRUEBA 3 - AGI VARIABLE", 1)
		a.Verbose("RETURN: ->"+a.Variables["agi_arg_1"]+"<-", 1)

	case "prueba4":

		a.Answer()
		a.Set("CHANNEL(language)", "es")
		a.Verbose("PRUEBA 4 - PLAYBACK AUDIO", 1)
		a.StreamFile("tt-monkeys", "#", 1)
		a.Set("__VAR_GLOBAL", a.Variables["agi_arg_1"])
		varGlobal, err := a.Get("VAR_GLOBAL")
		if err != nil {
			return
		}
		a.Verbose("RETURN: ->"+varGlobal+"<-", 1)
		a.Exec("DumpChan", "")

	case "ivrdemo1":

		IVRDemo1(a)

	default:

		a.Verbose("DEFAULT - VERBOSE", 1)

	}

	a.Hangup()
	//os.Exit(0)
}

func IVRDemo1(a *agi.AGI) {

	getLanguageChannel := a.Variables["agi_arg_2"]
	getUniqueID := a.Variables["agi_uniqueid"]

	if getLanguageChannel == "" {

		a.Set("CHANNEL(language)", "en")

	} else {

		a.Set("CHANNEL(language)", getLanguageChannel)

	}

	a.Answer()
	languageChannel, _ := a.Get("CHANNEL(language)")

	// audio1: IVR demo
	// audio1: Demo de IVR
	a.StreamFile(serverMediaURL+"audio1_"+languageChannel+".wav", "#", 1)
	log.Println("UniqueID: " + getUniqueID + " | StremFile: " + serverMediaURL + "audio1_" + languageChannel + ".wav")

	loop := true
	bye := 0
	for loop {

		if bye == 3 {
			log.Println("UniqueID: "+getUniqueID+" | Loop Final: ", bye)
			a.Verbose("Loop: Final: ", bye)
			loop = false
			break
		}

		//audio2: Please enter a number between 1 and 111
		//audio2: Por favor, ingrese un número entre el 1 y el 111
		a.StreamFile(serverMediaURL+"audio2_"+languageChannel+".wav", "#", 1)
		log.Println("UniqueID: " + getUniqueID + " | StremFile: " + serverMediaURL + "audio2_" + languageChannel + ".wav")

		result, _ := a.GetData("beep", 10000, 3)
		log.Println("UniqueID: "+getUniqueID+" | GetData DTMF: ", result)
		a.Verbose("DTMF RETURN: ->"+result+"<-", 1)

		switch result {

		case "":
			log.Println(a.Variables["agi_network_script"])

			//not_dtmf: We have not registered your entry.
			//not_dtmf: No hemos registrado su ingreso.
			a.StreamFile(serverMediaURL+"not_dtmf_"+languageChannel+".wav", "#", 1)
			bye++

		case "-1":

			log.Println("UniqueID: " + getUniqueID + " | HangUp: aborted")
			loop = false
			break

		case "111":

			//aduio4: Thank you very much for making this demo. Until next time.
			//aduio4: Muchas gracias por hacer esta demo. Hasta la próxima.
			a.StreamFile(serverMediaURL+"audio4_"+languageChannel+".wav", "#", 1)
			log.Println("UniqueID: " + getUniqueID + " | HangUp: completed")
			loop = false
			break

		default:

			//audio3: The number you entered is
			//audio3: El número que usted a ingresado es
			a.StreamFile(serverMediaURL+"audio3_"+languageChannel+".wav", "#", 1)
			a.SayDigits(result, "#")

		}

	}

}
