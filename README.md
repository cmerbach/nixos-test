# NixOS


## Quick and dirty setup guide for testing


### Download and run a vm

```sh
# create a tmp folder
mkdir -p tmp

# download the current version of nixos
test ! -f tmp/nixos.iso && wget https://channels.nixos.org/nixos-24.11/latest-nixos-minimal-x86_64-linux.iso -O tmp/nixos.iso || echo "Nothing todo!"

# create the device for install the os
test ! -f tmp/nixos.img && qemu-img create -f raw tmp/nixos.img 70G || echo "Nothing todo!"
```

### Run the vm

```sh
# ---( Option A)--- #
# run the boot command with gui
qemu-system-x86_64 -enable-kvm -hda tmp/nixos.img -smp 8 -m 16G -nic user,hostfwd=tcp::8888-:22 -cdrom tmp/nixos.iso -boot d

#---( set a password to root in the vm )--- #
#~$ passwd
```

```sh
# ---( Option B)--- #
# run the boot command just in plain terminal
qemu-system-x86_64 -enable-kvm -hda tmp/nixos.img -smp 8 -m 16G -nic user,hostfwd=tcp::8888-:22 -cdrom tmp/nixos.iso -boot d -nographic -serial mon:stdio

#---( set a password to root in the vm )--- #
#~$ passwd
```

### Login to vm
```sh
ssh-keygen -f "/home/user/.ssh/known_hosts" -R "[127.0.0.1]:8888" && \
sshpass -p '12345' \
ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=password nixos@127.0.0.1 -p 8888
```


## Arduino

<a href="arduino/pic/arduino.png"><img src="arduino/pic/arduino.png" height="250" alt="Arduino Pro Micro (ATmega32U4)"></a>

<br>

> [!TIP]
> [Arduino Pro Micro (ATmega32U4)](https://www.amazon.de/EntwicklungBoards-Binghe-Mikrocontroller-Entwicklungsboard-Selbst-USB-Updater/dp/B0D69JLJ97) <br>
> [USB C Adapter](https://www.amazon.de/dp/B0BYK917NM)


---
### Circuit diagram

<a href="arduino/pic/circuit-diagram-basis.png"><img src="arduino/pic/circuit-diagram-basis.png" height="200" alt="circuit-diagram-basis"></a>
<a href="arduino/pic/circuit-diagram-touch-modul.png"><img src="arduino/pic/circuit-diagram-touch-modul.png" height="200" alt="circuit-diagram-touch-modul"></a>

---
### PCB Design

<a href="arduino/pic/pcb-diagram.png"><img src="arduino/pic/pcb-diagram.png" height="250" alt="pcb-diagram"></a>
<a href="arduino/pic/pcb-front.png"><img src="arduino/pic/pcb-front.png" height="250" alt="pcb-front"></a>
<a href="arduino/pic/pcb-back.png"><img src="arduino/pic/pcb-back.png" height="250" alt="pcb-front"></a>

> [!NOTE]  
> You can go to [JLCPCB](https://jlcpcb.com) and upload the [files](arduino/pcb/touch-shield/production/) and be production ready

---
### Case

<a href="arduino/3mf/arduino_case.scad"><img src="arduino/pic/case-view.png" height="200" alt="3D View of OpenSacd"></a>
<a href="arduino/pic/case-print.png"><img src="arduino/pic/case-print.png" height="200" alt="Print Model for BambuLab A1"></a>
<a href="arduino/pic/case-print-top.png"><img src="arduino/pic/case-print-top.png" height="200" alt="Print Model GeSliced with Supports Top View"></a>
<a href="arduino/pic/case-print-bottom.png"><img src="arduino/pic/case-print-bottom.png" height="200" alt="Print Model GeSliced with Supports Bottom View"></a>

---
### Final Product

<a href="arduino/pic/final.png"><img src="arduino/pic/final.png" height="200" alt="Final Product"></a>
<a href="arduino/pic/final-parts.png"><img src="arduino/pic/final-parts.png" height="200" alt="Parts"></a>
<a href="arduino/pic/pcb-final.png"><img src="arduino/pic/pcb-final.png" height="200" alt="Touch Sensor"></a>

---
### Code

```sh
# open the arduino ide
arduino-ide
```

> [!IMPORTANT]  
> - Board Manager -> Arduino AVR Boards -> Install <br>
> - Libary Manager -> Keybaord -> Install <br>
> - Tools -> Board -> Arduino AVR Boards -> Arduino Leonardo <br>
> - Tools -> Port -> /dev/ttyACM0

<br>

A simple script for the USB HID (Human Interface Device) functionality of the Arduino Pro Micro. This code sends a text message whenever the board is connected to a computer.


---
#### Simple example

```cpp
#include <Keyboard.h>

void setup() {
  Keyboard.begin(); // init keyboard
  delay(1000); // wait 2 secounds for the system to be ready
  Keyboard.print(""); // send Text without linebreak
  Keyboard.write(KEY_RETURN); // simulate the Enter key
  Keyboard.end(); // end keyboard
}

void loop() {
  // nothing in the loop, since we only want to send once at startup
}
```

<br>

---
#### Code for Production

> [!CAUTION]
> Think about the keyboard layout! It only works with **us** layout <br>
> Also think about that you are using the us layout when typing! <br>

> [!TIP]
> workaround in my case for GNOME/KDE: <br>
> ```gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]"``` <br>
> ```gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'de')]"``` <br>

Upload the [Code](arduino/ino/touch.ino) to the Arduino Pro Micro. Don't forget to update the token for your GitHub account accordingly.

> [!NOTE]  
> ```const char* TOKEN = "...";```<br>
> create a GitHub Token, go to: <br>
> Settings -> Developer Settings -> Personal access tokens -> Fine-grained tokens -> REPO -> Repository permissions -> Contents -> read-only -> Generate Token



<!-- ## Additional - -->

<!-- Hier könnte Ihre Werbung stehen -->
