package display

import (
	"image/color"
	"time"
)

// TestColors führt einen Farbwechsel-Test durch mit gc9a01.Device
func TestColors(disp *Device) {
	colors := []struct {
		name  string
		color color.RGBA
	}{
		{"RED", color.RGBA{R: 255, G: 0, B: 0, A: 255}},
		{"GREEN", color.RGBA{R: 0, G: 255, B: 0, A: 255}},
		{"BLUE", color.RGBA{R: 0, G: 0, B: 255, A: 255}},
		{"WHITE", color.RGBA{R: 255, G: 255, B: 255, A: 255}},
		{"BLACK", color.RGBA{R: 0, G: 0, B: 0, A: 255}},
		{"YELLOW", color.RGBA{R: 255, G: 255, B: 0, A: 255}},
		{"CYAN", color.RGBA{R: 0, G: 255, B: 255, A: 255}},
		{"MAGENTA", color.RGBA{R: 255, G: 0, B: 255, A: 255}},
	}

	for {
		for _, c := range colors {
			disp.FillScreen(c.color)
			time.Sleep(2 * time.Second)
		}
	}
}
