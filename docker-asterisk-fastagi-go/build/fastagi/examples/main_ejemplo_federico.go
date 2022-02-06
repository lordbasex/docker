package main

import (
	"errors"
	"log"
	"strconv"

	"github.com/CyCoreSystems/agi"
)

func main() {
	log.Println("Iniciando el servicio...")
	agi.Listen(":8080", handler)
}

func handler(a *agi.AGI) {
	defer a.Close()
	log.Println("Procesando solicitud...")
	a.Answer()
	log.Println("### Llamada contestada ####")
	err := a.Set("MiVariable", "Tungsten")
	if err != nil {
		panic("fallo al establecer valor a la variable MiVariable")
	}
	a.Verbose("Mensaje de prueba desde go", 1)
	a.Set("CHANNEL(language)", "es")

	a.StreamFile("custom/MENUPRINCIPAL", "#", 0)
	// ##### ciclo for usando tipo int para la variable bye #####
	bye := 0
	for bye != 111 {

		_, err = a.StreamFile("to-enter-a-number", "#", 0)
		if err != nil {
			ver := err.Error()
			log.Println("Enter some digits - Sucedio un error:", ver)
			if err.Error() == "hangup" {
				log.Println("OJO Hubo un hangup... esto debería disparar algún proceso")
			}
			return
		}

		result, err := a.GetData("beep", 10000, 3)
		if err != nil {
			ver := err.Error()
			log.Println("Sucedio un error despues del beep:", ver)
			break
		}
		log.Println("Digitos capturados:", result)
		_, err = a.StreamFile("you-entered", "#", 0)
		if err != nil {
			log.Println("captured digits - Sucedio un error:", err)
			var ErrHangup = errors.New("hangup")
			if errors.Is(err, ErrHangup) {
				log.Println("Hubo un hangup, esto debería disparar algún proceso")
			}
			return
		}

		a.SayDigits(result, "")
		bye, _ = strconv.Atoi(result)

	}

	a.StreamFile("goodbye", "#", 0)
	a.Hangup()
	log.Println("### Llamada finalizada ####")

}
