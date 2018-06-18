#include "TrinketHidCombo.h"
// Get the TrinketHidCombo from here: https://github.com/adafruit/Adafruit-Trinket-USB/tree/master/TrinketHidCombo

#define ENCODER_PIN_A         2
#define ENCODER_PIN_B         1
#define LED_PIN               0
#define BUTTON_PIN            5

#define SPIN_LED_IMPULSE      16
#define STEADY_LED_LEVEL      36
#define PLAYPAUSE_LED_LEVEL   220
#define INIT_LED_LEVEL        220
#define LED_REVERT_TIMEOUT    24
#define DISCONN_LIMIT         200

int out_d = INIT_LED_LEVEL;
int ps1 = 0;
int ps2 = 0;
int pm = 0;
unsigned long bookmark_time;
// initialise the buffer to keep track of track skipping
int track_skip = 0;
int disconn_counter = 0;

// the setup routine runs once when you press reset:
void setup() {
  TrinketHidCombo.begin(); // start the USB device engine and enumerate     
  // initialize the digital pin as an output.
  pinMode(LED_PIN, OUTPUT); // LED Output
  pinMode(ENCODER_PIN_A, INPUT); // Encoder Pin 1
  pinMode(ENCODER_PIN_B, INPUT); // Encoder Pin 2
  pinMode(BUTTON_PIN, INPUT); // Pause Button
  // initialise the first time at which we start to revert the LED
  bookmark_time = millis() + LED_REVERT_TIMEOUT;
  // delay a little to allow to usb enumeration
  delay(10);
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
      out_d += SPIN_LED_IMPULSE;
      if (m == 1) {
        // if the button is pressed then skip forward
        TrinketHidCombo.pressMultimediaKey(MMKEY_SCAN_NEXT_TRACK);
        track_skip++;
      } else {
        // if the button is not pressed then vol up
        TrinketHidCombo.pressMultimediaKey(MMKEY_VOL_UP);
      }
    } else if ((s == 1) && (ps1 == 3) && (ps2 == 2)) {
      out_d -= SPIN_LED_IMPULSE;
      if (m == 1) {
        // if the button is pressed then skip forward
        TrinketHidCombo.pressMultimediaKey(MMKEY_SCAN_PREV_TRACK);
        track_skip--;
      } else {
        // if the button is not pressed then vol up
        TrinketHidCombo.pressMultimediaKey(MMKEY_VOL_DOWN);
      }
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
      // it is so boost the led and reset track skip
      out_d = PLAYPAUSE_LED_LEVEL;
      // reset the track buffer
      track_skip = 0;
    } else if (track_skip == 0) {
      // if it's not a leading edge (i.e. it's a lagging edge) and there have been no track skips then play/pause
      TrinketHidCombo.pressMultimediaKey(MMKEY_PLAYPAUSE);
    }
    // store old state
    pm = m;
    // delay a little to debounce
    delay(5);
  } else if (millis() > bookmark_time) {
    // no state change occured, revert back towards standard intensity if enough time has elapsed
    if (out_d < STEADY_LED_LEVEL) {
      out_d += 1;
    } else if (out_d > STEADY_LED_LEVEL) {
      out_d -= 1;
    }
    // reset timer
    bookmark_time = millis() + LED_REVERT_TIMEOUT;
    // write the value
    analogWrite(LED_PIN, out_d);
    // check if we're connected. If not then reconnect
    if (TrinketHidCombo.isConnected() == 0){
      // Increment the disconnect counter
      disconn_counter += 1;

      // Mess with the output to approximate flashing
      if (out_d < 32){
        out_d = 254;
      }

      // Check if we've been disconnected long enough to warrant a reconnect
      if (disconn_counter > DISCONN_LIMIT) {
        // Force re-enumeration
        TrinketHidCombo.begin();
        delay(20);
        TrinketHidCombo.poll();
        // Reset counter so that we don't try too often
        disconn_counter = 0;
      }
   } else {
      // We're connected so reset the counter and poll
      disconn_counter = 0;
      // Send a polling stroke to remind the machine we're here (given we're already connected)
      TrinketHidCombo.poll(); // do nothing, check if USB needs anything done
   } 
  }
}

















