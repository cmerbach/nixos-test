package main

import (
	"machine"
	"time"

	"rp2040/display"
	"rp2040/menu"
)

var (
	// Display Pins
	sck  = machine.GPIO10
	mosi = machine.GPIO11
	dc   = machine.GPIO8
	cs   = machine.GPIO9
	rst  = machine.GPIO13
	bl   = machine.GPIO25
	led  = machine.LED

	// Touch Controller Pins (CST816S)
	i2cSDA = machine.GPIO6
	i2cSCL = machine.GPIO7
)

func main() {
	// LED Setup - immer an lassen!
	led.Configure(machine.PinConfig{Mode: machine.PinOutput})
	led.High()

	// Display initialisieren (Software SPI)
	disp := display.New(sck, mosi, dc, cs, rst, bl)
	disp.Configure(display.Config{
		Orientation: display.VERTICAL,
		Width:       240,
		Height:      240,
	})

	// I2C für Touch Controller
	machine.I2C1.Configure(machine.I2CConfig{
		SDA:       i2cSDA,
		SCL:       i2cSCL,
		Frequency: 400000,
	})

	// Touch Controller initialisieren
	touch := display.NewCST816(machine.I2C1)
	touch.Configure()

	// Starte mit Hauptmenü
	currentScreen := menu.Screen(menu.NewMainMenu())
	currentScreen.Draw(&disp)

	println("Menu system ready!")

	lastTouched := false
	var touchStartX, touchStartY int16
	var touchEndX, touchEndY int16
	touchHappened := false

	for {
		// Touch Status lesen
		touched, touchData := touch.ReadTouch()

		if touched {
			// Während Touch aktiv ist, speichere die Position
			touchEndX = int16(touchData.X)
			touchEndY = int16(touchData.Y)

			if !lastTouched {
				// Touch gerade gestartet
				touchStartX = touchEndX
				touchStartY = touchEndY
				touchHappened = false

				print("Touch START: X=")
				print(touchStartX)
				print(" Y=")
				println(touchStartY)
			}
		}

		// Touch beendet - jetzt auswerten
		if !touched && lastTouched && !touchHappened {
			touchHappened = true

			print("Touch END: X=")
			print(touchEndX)
			print(" Y=")
			println(touchEndY)

			// Berechne Delta
			deltaX := touchEndX - touchStartX
			deltaY := touchEndY - touchStartY

			print("Delta: X=")
			print(deltaX)
			print(" Y=")
			println(deltaY)

			// Prüfe auf Swipe (mindestens 60 Pixel horizontal)
			if deltaX > 60 {
				println(">>> SWIPE LEFT-TO-RIGHT DETECTED! <<<")
				// Swipe erkannt - sende Signal an Screen
				nextScreen := currentScreen.HandleTouch(&disp, touch, -1, -1)
				if nextScreen != currentScreen {
					currentScreen = nextScreen
					currentScreen.Draw(&disp)
				}
			} else if deltaX < -60 {
				println(">>> SWIPE RIGHT-TO-LEFT DETECTED! <<<")
				// Ignorieren oder andere Aktion
			} else {
				// Normaler Touch/Tap
				println("Normal tap detected")
				nextScreen := currentScreen.HandleTouch(&disp, touch, touchStartX, touchStartY)
				if nextScreen != currentScreen {
					currentScreen = nextScreen
					currentScreen.Draw(&disp)
				}
			}
		}

		lastTouched = touched
		time.Sleep(50 * time.Millisecond)
	}
}
