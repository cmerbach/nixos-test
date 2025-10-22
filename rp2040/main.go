package main

import (
	"image/color"
	"machine"
	"time"

	"rp2040/display"
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

	// Counter Variable
	counter := 0
	lastTouched := false

	// Initial Screen - Schwarz
	disp.FillScreen(color.RGBA{R: 0, G: 0, B: 0, A: 255})

	// Zeichne Button (Mitte vom Display, 100x60 Pixel)
	buttonX := int16(70)
	buttonY := int16(100)
	buttonW := int16(100)
	buttonH := int16(60)
	disp.FillRectangle(buttonX, buttonY, buttonW, buttonH, color.RGBA{R: 0, G: 255, B: 255, A: 255})

	// Zeige initialen Counter (0) über dem Button
	drawCounter(&disp, counter)

	println("Touch counter ready. Touch the cyan button!")

	for {
		// Touch Status lesen
		touched, touchData := touch.ReadTouch()

		// Touch Event nur bei steigender Flanke
		if touched && !lastTouched {
			x := int16(touchData.X)
			y := int16(touchData.Y)

			print("Touch detected at X: ")
			print(x)
			print(" Y: ")
			println(y)

			// Prüfe ob Touch im Button-Bereich
			if x >= buttonX && x < (buttonX+buttonW) &&
				y >= buttonY && y < (buttonY+buttonH) {

				counter++
				print("Button pressed! Counter: ")
				println(counter)

				// Counter neu zeichnen
				drawCounter(&disp, counter)

				// Button Feedback (heller)
				disp.FillRectangle(buttonX, buttonY, buttonW, buttonH, color.RGBA{R: 255, G: 255, B: 255, A: 255})
				time.Sleep(100 * time.Millisecond)
				disp.FillRectangle(buttonX, buttonY, buttonW, buttonH, color.RGBA{R: 0, G: 255, B: 255, A: 255})
			}
		}

		lastTouched = touched
		time.Sleep(50 * time.Millisecond)
	}
}

// drawCounter zeichnet den Counter über dem Button
func drawCounter(disp *display.Device, count int) {
	// Lösche Counter-Bereich (über dem Button)
	disp.FillRectangle(80, 60, 80, 30, color.RGBA{R: 0, G: 0, B: 0, A: 255})

	// Zeichne Zahl (sehr einfach - jede Ziffer als Block)
	drawNumber(disp, count, 100, 70)
}

// drawNumber zeichnet eine Zahl (sehr simpel)
func drawNumber(disp *display.Device, num int, x, y int16) {
	if num == 0 {
		drawDigit(disp, 0, x, y)
		return
	}

	digits := []int{}
	temp := num
	for temp > 0 {
		digits = append([]int{temp % 10}, digits...)
		temp /= 10
	}

	offsetX := x
	for _, digit := range digits {
		drawDigit(disp, digit, offsetX, y)
		offsetX += 25
	}
}

// drawDigit zeichnet eine einzelne Ziffer als einfaches Muster (7-Segment Style)
func drawDigit(disp *display.Device, digit int, x, y int16) {
	c := color.RGBA{R: 255, G: 255, B: 0, A: 255}

	switch digit {
	case 0:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x, y+3, 3, 7, c)
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x, y+10, 3, 7, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
		disp.FillRectangle(x+5, y+17, 10, 3, c)
	case 1:
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
	case 2:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x+5, y+10, 10, 3, c)
		disp.FillRectangle(x, y+10, 3, 7, c)
		disp.FillRectangle(x+5, y+17, 10, 3, c)
	case 3:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x+5, y+10, 10, 3, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
		disp.FillRectangle(x+5, y+17, 10, 3, c)
	case 4:
		disp.FillRectangle(x, y+3, 3, 7, c)
		disp.FillRectangle(x+5, y+10, 10, 3, c)
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
	case 5:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x, y+3, 3, 7, c)
		disp.FillRectangle(x+5, y+10, 10, 3, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
		disp.FillRectangle(x+5, y+17, 10, 3, c)
	case 6:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x, y+3, 3, 7, c)
		disp.FillRectangle(x+5, y+10, 10, 3, c)
		disp.FillRectangle(x, y+10, 3, 7, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
		disp.FillRectangle(x+5, y+17, 10, 3, c)
	case 7:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
	case 8:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x, y+3, 3, 7, c)
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x+5, y+10, 10, 3, c)
		disp.FillRectangle(x, y+10, 3, 7, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
		disp.FillRectangle(x+5, y+17, 10, 3, c)
	case 9:
		disp.FillRectangle(x+5, y, 10, 3, c)
		disp.FillRectangle(x, y+3, 3, 7, c)
		disp.FillRectangle(x+17, y+3, 3, 7, c)
		disp.FillRectangle(x+5, y+10, 10, 3, c)
		disp.FillRectangle(x+17, y+10, 3, 7, c)
		disp.FillRectangle(x+5, y+17, 10, 3, c)
	}
}
