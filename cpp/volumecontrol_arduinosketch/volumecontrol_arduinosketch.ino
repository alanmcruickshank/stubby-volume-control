#include <DigiKeyboard.h>

#define KEY_VOL_UP       24  // 0x80
#define KEY_VOL_DOWN     7 // 0x81
#define KEY_PLAYPAUSE      39  // 0x48
// could be 0xcd or 0x78

int out_d = 128;
int targ_out_d = 24;
int ps1 = 0;
int ps2 = 0;
int pm = 0;
unsigned long bookmark_time;
int ms_update_delay = 20;

int ENCODER_PIN_A = 2;
int ENCODER_PIN_B = 1;
int LED_PIN = 0;
int BUTTON_PIN = 5;

// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(LED_PIN, OUTPUT); // LED Output
  pinMode(ENCODER_PIN_A, INPUT); // Encoder Pin 1
  pinMode(ENCODER_PIN_B, INPUT); // Encoder Pin 2
  pinMode(BUTTON_PIN, INPUT); // Pause Button
  bookmark_time = millis() + ms_update_delay;
}

// the loop routine runs over and over again forever:
void loop() {
  
  // Read the pins
  int a = digitalRead(ENCODER_PIN_A);
  int b = digitalRead(ENCODER_PIN_B);
  // pin 5 is the reset button so we can't pull it low, but we can pull it higher!
  // also pin 5 is analogue read 0 (wierd eh??)
  int m_analogue = analogRead(0);
  int m = 0;
  if (m_analogue > 950) {
    m = 1;
  }

  

  // state is a number between 0 and 3, upper bit is pin 2, lower is pin 1
  int s = a + (b * 2);

  // has a state change occured with encoder?
  if (s != ps1) {
    if ((s == 2) && (ps1 == 3) && (ps2 == 1)) {
      out_d += 8;
      DigiKeyboard.sendKeyStroke(KEY_VOL_UP);
    } else if ((s == 1) && (ps1 == 3) && (ps2 == 2)) {
      out_d -= 8;
      DigiKeyboard.sendKeyStroke(KEY_VOL_DOWN);
    }

    // make sure it doesn't overflow
    if (out_d < 0) {
      out_d = 0;
    } else if (out_d > 255) {
      out_d = 255;
    }
    
    // store previous states
    ps2 = ps1;
    ps1 = s;

    // in any case update the pwm
    analogWrite(LED_PIN, out_d);
  } else if (m != pm) {
    // has there been a state change on the mute button?

    // is it a leading edge?
    if ((m == 1) && (pm == 0)) {
      // it is so press the key and boost the led
      DigiKeyboard.sendKeyStroke(KEY_PLAYPAUSE);
      out_d = 192;
    }
    // store old state
    pm = m;
    // delay a little to debounce
    DigiKeyboard.delay(5);
  } else if (millis() > bookmark_time) {
    // no state change occured, revert back towards standard intensity if enough time has elapsed
    if (out_d < targ_out_d) {
      out_d += 1;
    } else if (out_d > targ_out_d) {
      out_d -= 1;
    }
    // reset timer
    bookmark_time = millis() + ms_update_delay;
    // write the value
    analogWrite(LED_PIN, out_d);
    // Send a polling stroke to remind the machine we're here
    DigiKeyboard.sendKeyStroke(0);
  }
}

















