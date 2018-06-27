#include "TrinketHidCombo.h"
// Get the TrinketHidCombo from here: https://github.com/adafruit/Adafruit-Trinket-USB/tree/master/TrinketHidCombo

#define ENCODER_PIN_A         2
#define ENCODER_PIN_B         1
#define LED_PIN               0
#define BUTTON_PIN            5

#define SPIN_LED_IMPULSE      24
#define STEADY_LED_LEVEL      52
#define PLAYPAUSE_LED_LEVEL   220
// Initial LED level
#define INIT_LED_LEVEL        0
// This is the timeout to move the LED level by 1
#define LED_REVERT_TIMEOUT    28
// This is the timeout to move the LED level by 1 (when in bump mode)
#define BUMP_LED_REVERT_TIMEOUT    2
#define DISCONN_LIMIT         200
// The point at which pin five should be considered to be pulled low
#define PIN_5_ANALOGUE_LIMIT  950

// define some signal values
// values below are read from right to left
// CLOCKWISE = 231 = 0AABB0 = 011110 = 30
// ANTI = 132 = B0AB0A = 101101 = 45
#define EVENT_CLOCKWISE_TURN  0b011110 //30
#define EVENT_ANTICLOCK_TURN  0b101101 //45

byte led_set_point = 0;
byte out_d = INIT_LED_LEVEL;
// initialise the first time at which we start to revert the LED to zero so we force an update as soon as we're running
unsigned long bookmark_time = 0;
// initialise the buffer to keep track of track skipping (needs to be negative safe) (char is a signed 8 bit integer)
char track_skip = 0;
byte disconn_counter = 0;
byte bump_target = 0;
bool bump_active = false;

// Using bit shifting for the buffer.
// Encoder buffer is two bits at a time
// Button buffer is one bit at a time
// Initialise the state buffers to zero
byte encoder_state_buffer = 0b0;
byte button_state_buffer = 0b0; 

// the setup routine runs once when you press reset:
void setup() {
    // initialize the digital pin as an output.
    pinMode(LED_PIN, OUTPUT); // LED Output
    pinMode(ENCODER_PIN_A, INPUT); // Encoder Pin 1
    pinMode(ENCODER_PIN_B, INPUT); // Encoder Pin 2
    pinMode(BUTTON_PIN, INPUT); // Pause Button
}

/* Read the current encoder state from the relevant pins */
byte read_encoder_state(){
    // Read the pins
    byte a = digitalRead(ENCODER_PIN_A);
    byte b = digitalRead(ENCODER_PIN_B);
    // state is a number between 0 and 3, upper bit is pin 2, lower is pin 1
    // 0 = 00
    // 1 = 0A
    // 2 = B0
    // 3 = AB
    return a + (b << 1);
}

/* Read the button state from the relevant pins */
byte read_button_state(){
    // pin 5 is the reset button so we can't pull it low, but we can pull it higher!
    // also pin 5 is analogue read 0 (wierd eh??)
    // check threshold of m_analogue and set to 1 if over 950 else 0
    byte m = analogRead(0) > PIN_5_ANALOGUE_LIMIT;
    // analogue read returns a number between 0 and 1023, it's not 8 bit but the result of the comparison is.
    return m;
}

/* change the current val by up to the increment without going past the bounds */
byte capped_move(byte current_val, char increment){
    // Use an int here because then we can go past the bounds
    int val_buffer = current_val;
    return constrain(val_buffer + increment, 0, 255);
}

/* reset the led timer */
void reset_led_timer(){
    if (bump_active) {
        bookmark_time = millis() + BUMP_LED_REVERT_TIMEOUT;
    } else {
        bookmark_time = millis() + LED_REVERT_TIMEOUT;
    }
}

/* use the led bump functionality to bump the brightness more nicely */
void bump_output_to(byte target){
    // bump the LED output to a given level
    bump_target = target;
    bump_active = true;
    reset_led_timer();
}

// the loop routine runs over and over again forever:
void loop() {
    // Get input states
    byte encoder_state = read_encoder_state();
    byte button_state = read_button_state();
    bool state_change = false;

    // ################## Case 1
    // Filter encoder buffer to see if it's changed (3 = 00000011 so masks to just the first two bits)
    // brackets are important because == evaluates before &
    if ((encoder_state_buffer & 0b11) != encoder_state) {
        // update the buffer
        encoder_state_buffer = (encoder_state_buffer << 2) + encoder_state;
        // detect turns of the encoder
        if ((encoder_state_buffer & 0b111111) == EVENT_CLOCKWISE_TURN) {
            // if we can add the impulse without wraparound, then do so, otherwise cap
            bump_output_to(capped_move(out_d, SPIN_LED_IMPULSE));
            if (button_state) {
                // if the button is pressed then skip forward
                TrinketHidCombo.pressMultimediaKey(MMKEY_SCAN_NEXT_TRACK);
                track_skip++;
            } else {
                // if the button is not pressed then vol up
                TrinketHidCombo.pressMultimediaKey(MMKEY_VOL_UP);
            }
        } else if ((encoder_state_buffer & 0b111111) == EVENT_ANTICLOCK_TURN) {
            // if we can take the impulse without wraparound, then do so, otherwise cap
            bump_output_to(capped_move(out_d, -SPIN_LED_IMPULSE));
            if (button_state) {
                // if the button is pressed then skip forward
                TrinketHidCombo.pressMultimediaKey(MMKEY_SCAN_PREV_TRACK);
                track_skip--;
            } else {
                // if the button is not pressed then vol up
                TrinketHidCombo.pressMultimediaKey(MMKEY_VOL_DOWN);
            }
        }
    }
    // ################## Case 2
    // Filter butten buffer to see if it's changed (1 = 00000001 so masks to just the first bit)
    else if ((button_state_buffer & 0b1) != button_state) {
        button_state_buffer = (button_state_buffer << 1) + button_state;
        // is it a push or a release?
        if (button_state) {
            // push
            // ... so boost the led and reset track skip
            bump_output_to(PLAYPAUSE_LED_LEVEL);
            // reset the track buffer
            track_skip = 0;
        } else if (track_skip == 0) {
            // release (and no track skipping) - so trigger a play/pause
            TrinketHidCombo.pressMultimediaKey(MMKEY_PLAYPAUSE);
        }
        // delay a little to debounce
        delay(2);
    }
    // ################## Case 3
    else if (millis() > bookmark_time) {
        // No state change of buttons and the timeout on the fading has been reached
        if (bump_active) {
            if (out_d < bump_target) {
                out_d += 1;
            } else if (out_d > bump_target) {
                out_d -= 1;
            } else {
                bump_active = false;
            }
        } else {
            if (out_d < led_set_point) {
                out_d += 1;
            } else if (out_d > led_set_point) {
                out_d -= 1;
            }
        }
        // reset timer
        reset_led_timer();
        // write the value
        analogWrite(LED_PIN, out_d);
        // Check for disconnect
        if (TrinketHidCombo.isConnected()){
            // We're connected so make sure that the lights are on.
            led_set_point = STEADY_LED_LEVEL;
            // We're connected so reset the counter and poll
            disconn_counter = 0;   
        } else {
            // Increment the disconnect counter (to count the cycles we're disconnected
            // NB: this is cycles within the bookmark loop - so it's a slower loop than the main loop
            disconn_counter += 1;
            // Set the LED target intensity to zero (we're disconnected)
            led_set_point = 0;
            // Check if we've been disconnected long enough to warrant a reconnect
            if (disconn_counter > DISCONN_LIMIT) {
                // Force re-enumeration
                TrinketHidCombo.begin();
                // Reset counter so that we don't try too often
                disconn_counter = 0;
            }
        }
        // Send a polling stroke to remind the machine we're here (given we're already connected)
        TrinketHidCombo.poll(); // do nothing, check if USB needs anything done  
        //NB: Polling even when not yet connected - forces the connection to initiate after a .begin() command
    }
}
