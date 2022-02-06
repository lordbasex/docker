package main

import (
	"log"
	"os"

	"github.com/CyCoreSystems/agi"
)

func main() {
	log.Println("Run AGI - 0.0.0.0:8080")
	agi.Listen(":8080", handler)
}

func handler(a *agi.AGI) {
	defer a.Close()

	verboseAsterisk := os.Getenv("VERBOSE")
	log.Println("Activation of VERBOSE:", verboseAsterisk)

	var bye int = 0

	a.Answer()
	a.Set("CHANNEL(language)", "es")

	/*
		SOUND ASTERISK: https://www.voip-info.org/asterisk-sound-files-additional/
	*/
	a.StreamFile("demo-congrats", "#", 0)

	loop := true

	for loop {

		if bye == 3 {
			a.Verbose("Loop: Final", 1)
			loop = false
			break
		}

		a.StreamFile("to-enter-a-number", "#", 0)

		result, _ := a.GetData("beep", 10000, 3)

		log.Println("Digitos capturados:", result)
		if verboseAsterisk == "true" {
			//true
			a.Verbose("Digitos capturados: -->"+result+"<--", 1)
		}

		if result == "-1" {
			a.Verbose("HANGUP CODE: 16: -->"+result+"<--", 1)
			if verboseAsterisk == "true" {
				//true
				a.Verbose("HANGUP CODE: 16", 1)
			}
			loop = false
			break
		}

		if result == "111" {
			log.Println("Es igual que 111. Nos despedimos y hacemos un break para salir del for")
			a.StreamFile("goodbye", "#", 0)
			loop = false
		}

		if result != "" {
			a.StreamFile("you-entered", "#", 0)
			a.SayNumber(result, "")
		}

		bye = bye + 1
		log.Println("Loop: Número:", bye)

	}

	a.Hangup()

}
