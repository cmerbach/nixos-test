package display

import (
	"machine"
	"time"
)

// CST816S Touch Controller I2C Adresse
const CST816_ADDR = 0x15

// Register (laut Datenblatt und Python-Code)
const (
	CST816_REG_GESTURE = 0x01
	CST816_REG_POINTS  = 0x02
	CST816_REG_X_HIGH  = 0x03
	CST816_REG_X_LOW   = 0x04
	CST816_REG_Y_HIGH  = 0x05
	CST816_REG_Y_LOW   = 0x06
	CST816_REG_CHIP_ID = 0xA7
)

type CST816 struct {
	bus  *machine.I2C
	addr uint16
}

type TouchData struct {
	X       uint16
	Y       uint16
	Gesture uint8
}

func NewCST816(bus *machine.I2C) *CST816 {
	return &CST816{
		bus:  bus,
		addr: CST816_ADDR,
	}
}

func (t *CST816) Configure() {
	time.Sleep(50 * time.Millisecond)

	println("Initializing CST816S touch controller...")

	// Teste Verbindung
	chipID := make([]byte, 1)
	err := t.bus.Tx(t.addr, []byte{CST816_REG_CHIP_ID}, chipID)

	if err != nil {
		println("ERROR: Cannot communicate with CST816S!")
		println("Error:", err.Error())
		return
	}

	print("CST816S Chip ID: 0x")
	println(chipID[0])
	println("Touch controller initialized successfully")
}

// ReadByte liest ein einzelnes Byte von einem Register
func (t *CST816) ReadByte(reg uint8) (uint8, error) {
	data := make([]byte, 1)
	err := t.bus.Tx(t.addr, []byte{reg}, data)
	if err != nil {
		return 0, err
	}
	return data[0], nil
}

// ReadTouch liest Touch-Daten
func (t *CST816) ReadTouch() (bool, TouchData) {
	// Lese 5 Bytes ab Register 0x02: [Points][X_H][X_L][Y_H][Y_L]
	data := make([]byte, 5)

	err := t.bus.Tx(t.addr, []byte{CST816_REG_POINTS}, data)
	if err != nil {
		return false, TouchData{}
	}

	// Anzahl Touch Points (untere 4 Bits)
	points := data[0] & 0x0F
	if points == 0 {
		return false, TouchData{}
	}

	// X und Y Koordinaten extrahieren
	// Format: High-Byte (obere 4 Bits maskiert) + Low-Byte
	x := uint16(data[1]&0x0F)<<8 | uint16(data[2])
	y := uint16(data[3]&0x0F)<<8 | uint16(data[4])

	return true, TouchData{
		X: x,
		Y: y,
	}
}

// ReadGesture liest Gesten-Events
func (t *CST816) ReadGesture() (uint8, error) {
	return t.ReadByte(CST816_REG_GESTURE)
}
