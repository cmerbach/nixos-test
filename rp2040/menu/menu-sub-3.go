package menu

import (
	"rp2040/display"
	"time"
)

// SubMenu3 repräsentiert Untermenü 3
type SubMenu3 struct {
	mainMenu      *MainMenu
	counter       int
	backButton    Button
	counterButton Button
}

// NewSubMenu3 erstellt Untermenü 3
func NewSubMenu3(mainMenu *MainMenu) *SubMenu3 {
	centerY := int16(120)
	buttonSize := int16(80)
	gap := int16(10)
	startX := int16(120 - buttonSize - gap/2)
	buttonY := centerY - buttonSize/2

	return &SubMenu3{
		mainMenu: mainMenu,
		counter:  0,
		backButton: Button{
			X:      startX,
			Y:      buttonY,
			Width:  buttonSize,
			Height: buttonSize,
			Color:  ColorBack,
			ID:     0,
			Shape:  ShapeCircle,
		},
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

// Draw zeichnet Untermenü 3
func (s *SubMenu3) Draw(disp *display.Device) {
	disp.FillScreen(ColorBackground)
	s.backButton.DrawButton(disp)
	s.counterButton.DrawButton(disp)
	s.drawCounter(disp)
}

// HandleTouch verarbeitet Touch-Events
func (s *SubMenu3) HandleTouch(disp *display.Device, touch *display.CST816, x, y int16) Screen {
	// Swipe von links nach rechts erkannt?
	if x == -1 && y == -1 {
		println("SubMenu3: Swipe detected - returning to main menu")
		return s.mainMenu
	}

	if s.backButton.Contains(x, y) {
		println("SubMenu3: Back button pressed")
		s.backButton.Flash(disp, ColorFlash)
		time.Sleep(100 * time.Millisecond)
		return s.mainMenu
	}

	if s.counterButton.Contains(x, y) {
		s.counter++
		print("SubMenu3: Counter = ")
		println(s.counter)
		s.counterButton.Flash(disp, ColorFlash)
		time.Sleep(100 * time.Millisecond)
		s.counterButton.DrawButton(disp)
		s.drawCounter(disp)
	}

	return s
}

// drawCounter zeichnet den Counter
func (s *SubMenu3) drawCounter(disp *display.Device) {
	counterX := s.counterButton.X
	counterY := s.counterButton.Y - 40
	counterW := s.counterButton.Width
	counterH := int16(30)
	disp.FillRectangle(counterX, counterY, counterW, counterH, ColorBackground)
	DrawNumber(disp, s.counter, counterX+10, counterY+5)
}
