#include <Keyboard.h>  // HID-Keyboard-Library

void setup() {
  pinMode(2, INPUT);
  pinMode(5, INPUT);
  pinMode(9, INPUT);

  // define LEDs as output
  pinMode(30, OUTPUT);
  
  // init LEDs
  digitalWrite(17, LOW);
  digitalWrite(30, LOW);

  Keyboard.begin();
}

void loop() {
  const char* TOKEN = "TOKEN";

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
  } else if (!sensor2 && sensor5 && sensor9) { // Touch 3
    //
  } else if (sensor2 && !sensor5 && sensor9) { // Touch 2
    Keyboard.begin();
    Keyboard.print("sudo loadkezs us 2>/dev/null || sudo loadkeys us 2>/dev/null");
    Keyboard.write(KEY_RETURN);
    delay(2000);
    Keyboard.print("read -p 'Account: ' ACCOUNT && read -p 'Branch: ' BRANCH && ACCOUNT=\"$ACCOUNT\" PASSWORD=\"" + String(TOKEN) + "\" BRANCH=\"$BRANCH\" nix --experimental-features \"nix-command flakes\" run --no-write-lock-file git+https://${ACCOUNT}:" + String(TOKEN) + "@github.com/$ACCOUNT/nixos?ref=\"$BRANCH\"#install");
    Keyboard.write(KEY_RETURN);
    Keyboard.end();
    delay(2000);
  } else if (sensor2 && sensor5 && !sensor9) { // Touch 1
    //
  }
  // else if (!sensor2 && !sensor5 && sensor9) {
  //   digitalWrite(17, LOW);
  // } else if (!sensor2 && sensor5 && !sensor9) {
  //   digitalWrite(17, LOW); 
  // } else if (sensor2 && !sensor5 && !sensor9) {
  //   digitalWrite(17, LOW); 
  else {
    digitalWrite(17, HIGH);
    digitalWrite(30, LOW);
    delay(200);
    digitalWrite(17, LOW);
    digitalWrite(30, HIGH);
    delay(200);
  }

  delay(1000);
}
