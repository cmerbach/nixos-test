package menu

import (
	"image/color"
	"rp2040/display"
)

// Screen definiert die Interface für verschiedene Bildschirme
type Screen interface {
	Draw(disp *display.Device)
	HandleTouch(disp *display.Device, touch *display.CST816, x, y int16) Screen
}

// Button repräsentiert einen rechteckigen Button
type Button struct {
	X      int16
	Y      int16
	Width  int16
	Height int16
	Color  color.RGBA
	ID     int
}

// Contains prüft ob ein Punkt innerhalb des Buttons liegt
func (b *Button) Contains(x, y int16) bool {
	return x >= b.X && x < (b.X+b.Width) &&
		y >= b.Y && y < (b.Y+b.Height)
}

// DrawButton zeichnet einen Button
func (b *Button) DrawButton(disp *display.Device) {
	disp.FillRectangle(b.X, b.Y, b.Width, b.Height, b.Color)
}

// Farben
var (
	ColorBackground = color.RGBA{R: 0, G: 0, B: 0, A: 255}
	ColorButton1    = color.RGBA{R: 255, G: 0, B: 0, A: 255}     // Rot
	ColorButton2    = color.RGBA{R: 0, G: 255, B: 0, A: 255}     // Grün
	ColorButton3    = color.RGBA{R: 0, G: 0, B: 255, A: 255}     // Blau
	ColorButton4    = color.RGBA{R: 255, G: 255, B: 0, A: 255}   // Gelb
	ColorBack       = color.RGBA{R: 100, G: 100, B: 100, A: 255} // Grau
	ColorCounter    = color.RGBA{R: 0, G: 255, B: 255, A: 255}   // Cyan
	ColorFlash      = color.RGBA{R: 255, G: 255, B: 255, A: 255} // Weiß
)

// DrawNumber zeichnet eine Zahl (Hilfsfunktion für alle Menüs)
func DrawNumber(disp *display.Device, num int, x, y int16) {
	if num == 0 {
		DrawDigit(disp, 0, x, y)
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
		DrawDigit(disp, digit, offsetX, y)
		offsetX += 25
	}
}

// DrawDigit zeichnet eine einzelne Ziffer (7-Segment Style)
func DrawDigit(disp *display.Device, digit int, x, y int16) {
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
