
#include <Adafruit_NeoPixel.h>
#include <CapacitiveSensor.h>

// Which pin on the Arduino is connected to the NeoPixels?
#define LED_PIN    6

// How many NeoPixels are attached to the Arduino?
#define LED_COUNT 3

// Declare our NeoPixel strip object:
Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);
// Argument 1 = Number of pixels in NeoPixel strip
// Argument 2 = Arduino pin number (most are valid)
// Argument 3 = Pixel type flags, add together as needed:
//   NEO_KHZ800  800 KHz bitstream (most NeoPixel products w/WS2812 LEDs)
//   NEO_KHZ400  400 KHz (classic 'v1' (not v2) FLORA pixels, WS2811 drivers)
//   NEO_GRB     Pixels are wired for GRB bitstream (most NeoPixel products)
//   NEO_RGB     Pixels are wired for RGB bitstream (v1 FLORA pixels, not v2)
//   NEO_RGBW    Pixels are wired for RGBW bitstream (NeoPixel RGBW products)

boolean newStructure;
long pixelHue;
int wait;

CapacitiveSensor   cs_10_11 = CapacitiveSensor(10, 11);       // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
long threshold;
long readings[4];
long lastReading;
long currentReading;
long runningTotal;

long lightPeriod;
boolean lite, triggered;
long triggerTime, lastTime;
long tAlmostUp;
int fadeValue;


void setup() {

  strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip.show();            // Turn OFF all pixels ASAP
  strip.setBrightness(20); // Set BRIGHTNESS to about 1/5 (max = 255)

  newStructure = true;
  pixelHue = 0;
  wait = 20;

  cs_10_11.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  threshold = 500;
  Serial.begin(9600);

  lightPeriod = 40000;
  lite = false; // is one lite?
  triggered = false; // recent trigger
  triggerTime = 0;
  lastTime = 0;
  fadeValue = 255;
  tAlmostUp = false;
}

void loop() {
  // Fill along the length of the strip in various colors...
  //colorWipe(strip.Color(255,   0,   0), 50); // Red
  //colorWipe(strip.Color(  0, 255,   0), 50); // Green
  //colorWipe(strip.Color(  0,   0, 255), 50); // Blue
  // rainbow(20); //10            // Flowing rainbow cycle along the whole strip

  // ********** sensor reading: **********
  for (long i = 0; i < 4; i++) {
    long total1 =   cs_10_11.capacitiveSensor(30);
    readings[i] = total1;
    runningTotal += readings[i];
  }
  currentReading = runningTotal / 4;
  Serial.print("Sensor is: ");
  Serial.println(currentReading);
  runningTotal = 0;
  if (abs(currentReading - lastReading) > threshold) {  // this whill have it occur once on entry and once more upon exit; not continiously
    newStructure = true;
    triggered = true;
    tAlmostUp = false; // for fade down
    //triggerTime = millis(); // take a time stamp
  }
  lastReading = currentReading;

  // ******** change color *********
  //
  //  //change color:
  if ( lite == true) {
    pixelHue += 256;
    if (pixelHue > 5 * 65536) {
      pixelHue = 0;
    }
  }
  Serial.print("pixelHue is: ");
  Serial.println(pixelHue);

  //  for (long firstPixelHue = pixelHue; firstPixelHue < 5 * 65536; firstPixelHue += 256) {
  //  }


  // light 3 gradually
  if (newStructure == true) {
    lightNewbie(0);
    newStructure = false;
    Serial.println("            can't repeat until new trigger");
    lite = true; // we are lite
    triggerTime = millis(); // take a time stamp
  }
  // if we are not new, but lite, animate:
  else if ( lite == true) { //if any of the timers are still going
    long howOld = millis() - triggerTime;
    Serial.print(" current time - trigger is : ");
    Serial.println(howOld);
    Serial.println();
    if (newStructure == false && howOld < lightPeriod) {
      Serial.println("lighting lighting");
      pixelHue += 500;
      Serial.print(" Hue is: ");
      Serial.println(pixelHue);
      Serial.println();

      //** if triggerTime is almost up, dimm lights
      if (howOld > (lightPeriod - 10000) ) {
        tAlmostUp = true;
        Serial.println("**almost up**");
      }

      lightLights(pixelHue, tAlmostUp);
    }
    // if we aren't new and we are out of time:
    else if (newStructure == false && howOld > lightPeriod) {
      lite = false;
    }
  } // lite = true
  if (lite == false) { // no timers are going
    colorWipe(0, 3);

    Serial.println("*****no lights******");
    Serial.println();
  }

  Serial.print("lite is:   ");
  Serial.println(lite);

  // once lite, same color to each
  //  if (newStructure == false && triggered == true) {
  //  while (millis() - currentTime < lightPeriod)
  //   {
  //for (long firstPixelHue = pixelHue; firstPixelHue < 5 * 65536; firstPixelHue += 256) {
  //        for (int i = 0; i < strip.numPixels(); i++) { // For each pixel in strip...
  //          Serial.println("changing colors");
  //Serial.println();
  // Offset pixel hue by an amount to make one full revolution of the
  // color wheel (range of 65536) along the length of the strip
  // (strip.numPixels() steps):
  //pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());
  // strip.ColorHSV() can take 1 or 3 arguments: a hue (0 to 65535) or
  // optionally add saturation and value (brightness) (each 0 to 255).
  // Here we're using just the single-argument hue variant. The result
  // is passed through strip.gamma32() to provide 'truer' colors
  //Serial.print("for-loop pixelHue is: ");
  // Serial.println(pixelHue);

  // before assigning to each pixel:
  //          strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(firstPixelHue)));

  //  }
  //        strip.show(); // Update strip with new contents
  //        delay(5);  // Pause for a moment
  //        if (millis() - currentTime < lightPeriod) {
  //          break;
  //          Serial.println("*****************breaking******************");
  //        } else {
  //          Serial.println();
  //          Serial.println("still in");
  //        }

  //  } // for-loop pixelHue

  //  } // while
  //    triggered = false;
  //  } //if
  //  else {
  //    colorWipe(0, 3);
  //  }


}// loop

void lightLights(long color, bool fade) {
  //
  if ( fade == true ) { // if we should be fading
    Serial.println("INSIDE FADE MECHANISM");
    for (int j = 255; j >= 80; j -= 5) { //fade down
      // set all the pixels at once:
      for (int i = 0; i < strip.numPixels() ; i++) { // For each pixel in strip...
        strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(color, 255, j)));
      }

      Serial.print("    fadeValue is: ");
      Serial.println(j);
      Serial.println("    FADING ");

      strip.show();
      delay(500);  // Pause for a moment
    }
    lite = false;
  }
  else if (fade == false) {
    //fadeValue = 255;
    Serial.println("    not fading");
    for (int i = 0; i < strip.numPixels() ; i++) { // For each pixel in strip...
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(color, 255, 255)));
    }
    //update them all at once:
    strip.show(); // Update strip with new contents at once
    delay(50);  // Pause for a moment

    Serial.print("    Color is: ");
    Serial.println(color);
    Serial.print("    fade is: ");
    Serial.println(fade);
  }


}



void lightNewbie(int ledNum) {
  //** fade up in color
  //  pixelHue += 127;
  //  if (pixelHue > 5 * 65536) {
  //    pixelHue = 0;
  //  }
  int sat = 105; // was 150
  // turn each on, one at a time (for one structure):
  for (int i = ledNum; i < 3; i++) {
    strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue, 255, sat)));
    strip.show(); // Update strip with new contents
    delay(1500);  // Pause for a moment
  }
  //fade up:
  for (int j = sat; j <= 255; j += 10) { //fade up
    // set all the pixels at once:
    for (int i = 0; i < strip.numPixels(); i++) { // For each pixel in strip...
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue, 255, j)));
    }
    strip.show();
    delay(500);
  }
}


// Rainbow cycle along whole strip. Pass delay time (in ms) between frames.
void rainbow(int wait) {
  // Hue of first pixel runs 5 complete loops through the color wheel.
  // Color wheel has a range of 65536 but it's OK if we roll over, so
  // just count from 0 to 5*65536. Adding 256 to firstPixelHue each time
  // means we'll make 5*65536/256 = 1280 passes through this outer loop:
  for (long firstPixelHue = 0; firstPixelHue < 5 * 65536; firstPixelHue += 256) {
    for (int i = 0; i < strip.numPixels(); i++) { // For each pixel in strip...
      // Offset pixel hue by an amount to make one full revolution of the
      // color wheel (range of 65536) along the length of the strip
      // (strip.numPixels() steps):
      int pixelHue = firstPixelHue + (i * 65536L / strip.numPixels());
      // strip.ColorHSV() can take 1 or 3 arguments: a hue (0 to 65535) or
      // optionally add saturation and value (brightness) (each 0 to 255).
      // Here we're using just the single-argument hue variant. The result
      // is passed through strip.gamma32() to provide 'truer' colors
      // before assigning to each pixel:
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue)));
    }
    strip.show(); // Update strip with new contents
    delay(wait);  // Pause for a moment
  }
}


// Fill strip pixels one after another with a color. Strip is NOT cleared
// first; anything there will be covered pixel by pixel. Pass in color
// (as a single 'packed' 32-bit value, which you can get by calling
// strip.Color(red, green, blue) as shown in the loop() function above),
// and a delay time (in milliseconds) between pixels.
void colorWipe(uint32_t color, int wait) {
  for (int i = 0; i < strip.numPixels(); i++) { // For each pixel in strip...
    strip.setPixelColor(i, color);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}
