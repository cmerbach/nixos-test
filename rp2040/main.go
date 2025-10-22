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

	for {
		// Touch Status lesen
		touched, touchData := touch.ReadTouch()

		// Touch Event nur bei steigender Flanke
		if touched && !lastTouched {
			x := int16(touchData.X)
			y := int16(touchData.Y)

			print("Touch at X:")
			print(x)
			print(" Y:")
			println(y)

			// Sende Touch-Event an aktuellen Screen
			// Screen gibt zurück, welcher Screen als nächstes angezeigt werden soll
			nextScreen := currentScreen.HandleTouch(&disp, touch, x, y)

			// Wenn sich der Screen geändert hat, zeichne den neuen Screen
			if nextScreen != currentScreen {
				currentScreen = nextScreen
				currentScreen.Draw(&disp)
			}
		}

		lastTouched = touched
		time.Sleep(50 * time.Millisecond)
	}
}
