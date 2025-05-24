#include <Keyboard.h>  // HID-Keyboard-Library

void setup() {
  pinMode(2, INPUT);
  pinMode(5, INPUT);
  pinMode(9, INPUT);

  pinMode(17, OUTPUT);
  digitalWrite(17, LOW);

  Keyboard.begin();
}

void loop() {
  bool sensor2 = digitalRead(2) == LOW;
  bool sensor5 = digitalRead(5) == LOW;
  bool sensor9 = digitalRead(9) == LOW;

  // delay(1000);

  if (sensor2 && sensor5 && sensor9) {
    digitalWrite(17, HIGH);
  } else if (!sensor2 && !sensor5 && !sensor9) { 
    // digitalWrite(17, HIGH);
  } else if (!sensor2 && !sensor5 && sensor9) { 
    // digitalWrite(17, HIGH);
  } else if (!sensor2 && sensor5 && !sensor9) { 
    // digitalWrite(17, HIGH);
  } else if (sensor2 && !sensor5 && !sensor9) { 
    // digitalWrite(17, HIGH);
  } else if (!sensor2 && sensor5 && sensor9) {
    Keyboard.print("Hello World!");
    delay(2000);
  } else if (sensor2 && !sensor5 && sensor9) {
    digitalWrite(17, HIGH);
    delay(50);
    digitalWrite(17, LOW);
    delay(50);
  } else if (sensor2 && sensor5 && !sensor9) {
    digitalWrite(17, HIGH);
    delay(500);
    digitalWrite(17, LOW);
    delay(500);
  } else {
    //
  }

  delay(1000);
}
