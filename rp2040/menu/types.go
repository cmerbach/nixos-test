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

// SwipeDetector erkennt Swipe-Gesten
type SwipeDetector struct {
	startX      int16
	startY      int16
	hasStart    bool
	minDistance int16 // Mindestdistanz für einen Swipe
}

// NewSwipeDetector erstellt einen neuen SwipeDetector
func NewSwipeDetector() *SwipeDetector {
	return &SwipeDetector{
		minDistance: 60, // Mindestens 60 Pixel Swipe
		hasStart:    false,
	}
}

// OnTouchStart wird aufgerufen wenn Touch beginnt
func (s *SwipeDetector) OnTouchStart(x, y int16) {
	s.startX = x
	s.startY = y
	s.hasStart = true
}

// OnTouchEnd wird aufgerufen wenn Touch endet und gibt zurück ob ein Swipe erkannt wurde
// Returns: (isLeftToRight, isRightToLeft, isSwipe)
func (s *SwipeDetector) OnTouchEnd(endX, endY int16) (bool, bool, bool) {
	if !s.hasStart {
		return false, false, false
	}

	deltaX := endX - s.startX
	deltaY := endY - s.startY

	// Prüfe ob Bewegung horizontal genug ist (deltaX größer als deltaY)
	if deltaX < 0 {
		deltaX = -deltaX
	}
	if deltaY < 0 {
		deltaY = -deltaY
	}

	// Horizontale Bewegung muss dominieren
	if deltaX < deltaY {
		s.hasStart = false
		return false, false, false
	}

	// Prüfe Swipe-Richtung
	actualDeltaX := endX - s.startX

	s.hasStart = false

	if actualDeltaX > s.minDistance {
		// Links nach Rechts
		return true, false, true
	} else if actualDeltaX < -s.minDistance {
		// Rechts nach Links
		return false, true, true
	}

	return false, false, false
}

// Reset setzt den Detector zurück
func (s *SwipeDetector) Reset() {
	s.hasStart = false
}

// ButtonShape definiert die Form des Buttons
type ButtonShape uint8

const (
	ShapeRectangle ButtonShape = 0
	ShapeCircle    ButtonShape = 1
)

// Button repräsentiert einen Button (Kreis oder Rechteck)
type Button struct {
	X      int16
	Y      int16
	Width  int16
	Height int16
	Color  color.RGBA
	ID     int
	Shape  ButtonShape // ShapeRectangle oder ShapeCircle
}

// Contains prüft ob ein Punkt innerhalb des Buttons liegt
func (b *Button) Contains(x, y int16) bool {
	return x >= b.X && x < (b.X+b.Width) &&
		y >= b.Y && y < (b.Y+b.Height)
}

// DrawButton zeichnet einen Button (als Kreis oder Rechteck je nach Shape)
func (b *Button) DrawButton(disp *display.Device) {
	if b.Shape == ShapeCircle {
		// Zeichne als Kreis
		centerX := b.X + b.Width/2
		centerY := b.Y + b.Height/2
		radius := b.Width / 2 // Nimm die kleinere Dimension als Radius
		DrawFilledCircle(disp, centerX, centerY, radius, b.Color)
	} else {
		// Zeichne als Rechteck (Standard)
		disp.FillRectangle(b.X, b.Y, b.Width, b.Height, b.Color)
	}
}

// Flash zeichnet den Button kurz in einer anderen Farbe (für Feedback)
func (b *Button) Flash(disp *display.Device, flashColor color.RGBA) {
	if b.Shape == ShapeCircle {
		centerX := b.X + b.Width/2
		centerY := b.Y + b.Height/2
		radius := b.Width / 2
		DrawFilledCircle(disp, centerX, centerY, radius, flashColor)
	} else {
		disp.FillRectangle(b.X, b.Y, b.Width, b.Height, flashColor)
	}
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

// DrawFilledCircle zeichnet einen gefüllten Kreis
func DrawFilledCircle(disp *display.Device, centerX, centerY, radius int16, c color.RGBA) {
	// Midpoint Circle Algorithm - zeichne gefüllten Kreis
	for y := -radius; y <= radius; y++ {
		for x := -radius; x <= radius; x++ {
			// Prüfe ob Punkt im Kreis liegt
			if x*x+y*y <= radius*radius {
				disp.SetPixel(centerX+x, centerY+y, c)
			}
		}
	}
}

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
