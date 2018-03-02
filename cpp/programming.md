# Arduino Files

The design uses the [digistump](http://digistump.com/wiki/digispark), although the micro usb version of the standard digistump as [available on aliexpress](https://www.aliexpress.com/item/Mini-ATTINY85-Micro-USB-Development-Board-for-Digispark-Kickstarter/32658933669.html). For this to work in the Arduino environment you need:

- The local Arduino IDE - from [arduino.cc](https://www.arduino.cc/en/Main/Software)
- The relevant digispark drivers for the arduino IDE - instructions [here](http://digistump.com/wiki/digispark/tutorials/connecting).

The USB driver uses (or at least will use) an altered version of the Digispark Keyboard addon, which is part of the [DigistumpArduino library](https://github.com/digistump/DigistumpArduino). The details of how to emulate multimedia keys are inspired by the work done by Adafruit on their [Trinket library](https://github.com/adafruit/Adafruit-Trinket-USB) (most notable the HIDCombo library).

## Loading the firmware

The digistump is programmed directly through the Arduino interface via usb. No additional functionality required. Press *Upload* in the arduino IDE with the right kind of board selected and it should just work. After loading the firmare you may need to unlplug and then reconnect the volume control before it acts as a control properly.
