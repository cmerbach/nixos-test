package menu

import (
	"rp2040/display"
	"time"
)

// SubMenu1 repräsentiert Untermenü 1
type SubMenu1 struct {
	mainMenu      *MainMenu
	counter       int
	backButton    Button
	counterButton Button
}

// NewSubMenu1 erstellt Untermenü 1
func NewSubMenu1(mainMenu *MainMenu) *SubMenu1 {
	// 2 Buttons nebeneinander in der Mitte
	centerY := int16(120)
	buttonSize := int16(80)
	gap := int16(10)

	// Berechne Start-Position für 2 Buttons zentriert
	startX := int16(120 - buttonSize - gap/2)
	buttonY := centerY - buttonSize/2

	return &SubMenu1{
		mainMenu: mainMenu,
		counter:  0,
		// Linker Button: Zurück
		backButton: Button{
			X:      startX,
			Y:      buttonY,
			Width:  buttonSize,
			Height: buttonSize,
			Color:  ColorBack,
			ID:     0,
			Shape:  ShapeRectangle,
		},
		// Rechter Button: Counter
		counterButton: Button{
			X:      startX + buttonSize + gap,
			Y:      buttonY,
			Width:  buttonSize,
			Height: buttonSize,
			Color:  ColorCounter,
			ID:     1,
			Shape:  ShapeCircle,
		},
	}
}

// Draw zeichnet Untermenü 1
func (s *SubMenu1) Draw(disp *display.Device) {
	// Schwarzer Hintergrund
	disp.FillScreen(ColorBackground)

	// Zeichne beide Buttons
	s.backButton.DrawButton(disp)
	s.counterButton.DrawButton(disp)

	// Zeichne Counter über dem Counter-Button
	s.drawCounter(disp)
}

// HandleTouch verarbeitet Touch-Events
func (s *SubMenu1) HandleTouch(disp *display.Device, touch *display.CST816, x, y int16) Screen {
	// Zurück-Button gedrückt?
	if s.backButton.Contains(x, y) {
		println("SubMenu1: Back button pressed")

		// Flash-Effekt
		s.backButton.Flash(disp, ColorFlash)
		time.Sleep(100 * time.Millisecond)

		// Zurück zum Hauptmenü
		return s.mainMenu
	}

	// Counter-Button gedrückt?
	if s.counterButton.Contains(x, y) {
		s.counter++
		print("SubMenu1: Counter = ")
		println(s.counter)

		// Flash-Effekt
		s.counterButton.Flash(disp, ColorFlash)
		time.Sleep(100 * time.Millisecond)
		s.counterButton.DrawButton(disp)

		// Counter neu zeichnen
		s.drawCounter(disp)
	}

	// Bleibe in SubMenu1
	return s
}

// drawCounter zeichnet den Counter über dem Counter-Button
func (s *SubMenu1) drawCounter(disp *display.Device) {
	// Berechne Position über dem Counter-Button
	counterX := s.counterButton.X
	counterY := s.counterButton.Y - 40
	counterW := s.counterButton.Width
	counterH := int16(30)

	// Lösche Counter-Bereich
	disp.FillRectangle(counterX, counterY, counterW, counterH, ColorBackground)

	// Zeichne Zahl
	DrawNumber(disp, s.counter, counterX+10, counterY+5)
}
