package menu

import (
	"image/color"
	"rp2040/display"
)

// SubMenu4 repräsentiert Untermenü 4 - nur Swipe, keine Buttons
type SubMenu4 struct {
	mainMenu *MainMenu
}

// NewSubMenu4 erstellt Untermenü 4
func NewSubMenu4(mainMenu *MainMenu) *SubMenu4 {
	return &SubMenu4{
		mainMenu: mainMenu,
	}
}

// Draw zeichnet Untermenü 4 - leerer Screen mit Text-Hinweis
func (s *SubMenu4) Draw(disp *display.Device) {
	disp.FillScreen(ColorBackground)

	// Zeichne einen gelben Streifen in der Mitte
	yellowColor := color.RGBA{R: 255, G: 255, B: 0, A: 255}
	disp.FillRectangle(20, 110, 200, 20, yellowColor)
}

// HandleTouch verarbeitet Touch-Events
func (s *SubMenu4) HandleTouch(disp *display.Device, touch *display.CST816, x, y int16) Screen {
	// Swipe von links nach rechts erkannt?
	if x == -1 && y == -1 {
		println("SubMenu4: SWIPE DETECTED - returning to main menu!")
		return s.mainMenu
	}

	// Alle anderen Touches ignorieren
	print("SubMenu4: Touch at X:")
	print(x)
	print(" Y:")
	print(y)
	println(" (ignored - swipe to go back)")

	return s
}
