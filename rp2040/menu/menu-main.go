package menu

import (
	"rp2040/display"
	"time"
)

// MainMenu repräsentiert das Hauptmenü mit 4 Buttons
type MainMenu struct {
	buttons [4]Button
}

// NewMainMenu erstellt ein neues Hauptmenü
func NewMainMenu() *MainMenu {
	// 4 Buttons in einer 2x2 Anordnung
	// Jeder Button: 80x80 Pixel, mit Abständen
	// Button-Layout:
	//   [1] [2]
	//   [3] [4]

	centerX := int16(120) // Mitte des 240px Displays
	centerY := int16(120)
	buttonSize := int16(80)
	gap := int16(10)

	// Berechne Start-Positionen damit alles zentriert ist
	startX := centerX - buttonSize - gap/2
	startY := centerY - buttonSize - gap/2

	return &MainMenu{
		buttons: [4]Button{
			// Button 1 (oben links)
			{
				X:      startX,
				Y:      startY,
				Width:  buttonSize,
				Height: buttonSize,
				Color:  ColorButton1,
				ID:     1,
				Shape:  ShapeRectangle,
			},
			// Button 2 (oben rechts)
			{
				X:      startX + buttonSize + gap,
				Y:      startY,
				Width:  buttonSize,
				Height: buttonSize,
				Color:  ColorButton2,
				ID:     2,
				Shape:  ShapeRectangle,
			},
			// Button 3 (unten links)
			{
				X:      startX,
				Y:      startY + buttonSize + gap,
				Width:  buttonSize,
				Height: buttonSize,
				Color:  ColorButton3,
				ID:     3,
				Shape:  ShapeRectangle,
			},
			// Button 4 (unten rechts)
			{
				X:      startX + buttonSize + gap,
				Y:      startY + buttonSize + gap,
				Width:  buttonSize,
				Height: buttonSize,
				Color:  ColorButton4,
				ID:     4,
				Shape:  ShapeRectangle,
			},
		},
	}
}

// Draw zeichnet das Hauptmenü
func (m *MainMenu) Draw(disp *display.Device) {
	// Schwarzer Hintergrund
	disp.FillScreen(ColorBackground)

	// Zeichne alle 4 Buttons
	for i := 0; i < 4; i++ {
		m.buttons[i].DrawButton(disp)
	}
}

// HandleTouch verarbeitet Touch-Events
func (m *MainMenu) HandleTouch(disp *display.Device, touch *display.CST816, x, y int16) Screen {
	// Prüfe welcher Button gedrückt wurde
	for i := 0; i < 4; i++ {
		if m.buttons[i].Contains(x, y) {
			print("Main Menu: Button ")
			print(m.buttons[i].ID)
			println(" pressed")

			// Flash-Effekt mit neuer Flash-Methode
			m.buttons[i].Flash(disp, ColorFlash)
			time.Sleep(100 * time.Millisecond)
			m.buttons[i].DrawButton(disp)
			time.Sleep(50 * time.Millisecond)

			// Gehe zum entsprechenden Untermenü
			switch m.buttons[i].ID {
			case 1:
				return NewSubMenu1(m)
			case 2:
				return NewSubMenu2(m)
			case 3:
				return NewSubMenu3(m)
			case 4:
				return NewSubMenu4(m)
			}
		}
	}

	// Kein Button getroffen - bleibe im Hauptmenü
	return m
}
