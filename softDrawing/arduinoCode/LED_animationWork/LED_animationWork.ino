
#include <Adafruit_NeoPixel.h>
//#include <CapacitiveSensor.h>
//#include <HCSR04.h>
#include <Structure.h>

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

int startAdd = 0; // LED start address

// declare each structure:
Structure one(1, startAdd, strip); // (snumber, start LED address, adafruit_neoPixel_Strip)
Structure two(2, startAdd + 3, strip);
/*
  Structure three(3,startAdd + 3, strip);
  Structure four(4,startAdd + 3, strip);
  Structure five(5,startAdd + 3, strip);
  Structure six(6,startAdd + 3, strip);
  Structure seven(7,startAdd + 3, strip);
  Structure eight(8,startAdd + 3, strip);
*/

// load structures into array:
//Structure structures[8] = {one, two, three, four, five, six, seven, eight};
Structure structures[2] = {one, two};

boolean newStructure;  //
long pixelHue; //
int wait;

//HCSR04 hc(9, 5); // initization of HCSR04 (trigger pin, echo pin);
//HCSR04 hc(9, new int[1] {5}, 1); //initization of HCSR04 (trigger pin, {echo pins(s)}, number of sensors)
const int trig = 9;
const int echo = 5;
long time, dist;

float distance[1];
float maxDistanceThresholds[1]; //distance limits
int numSensors = 1;
boolean someoneNear;

/*
  CapacitiveSensor   cs_10_11 = CapacitiveSensor(10, 11);       // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
  long threshold;
  long readings[4];
  long lastReading;
  long currentReading;
  long runningTotal;
*/


boolean liteAny, triggered;
/* moved to class
  long lightPeriod;
  long triggerTime, lastTime;
  int startAddress;
  long tAlmostUp;

*/

int fadeValue;


void setup() {
  Serial.begin(9600);

  strip.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
  strip.show();            // Turn OFF all pixels ASAP
  strip.setBrightness(20); // Set BRIGHTNESS to about 1/5 (max = 255)

  newStructure = true;
  pixelHue = 0;
  wait = 20;

  // cs_10_11.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  // threshold = 500;

  someoneNear = false;
  // /*
  // take max readings to calibrate sensors:
  Serial.println("Calibrating: finding current distance limits");
  Serial.println();
  for (int i = 0; i < numSensors; i++) {
    maxDistanceThresholds[i] = 70; //hc.dist(i);
    Serial.print("Max Dist ");
    Serial.print(i);
    Serial.print(": ");
    Serial.println(maxDistanceThresholds[i]);
    delay(70);
  }
  //*/

  pinMode(trig, OUTPUT);
  pinMode(echo, INPUT);


  // lightPeriod = 40000; //moved to class
  //  lite = false; // is one lite?
  triggered = false; // recent trigger
  //  triggerTime = 0;
  //  lastTime = 0;
  //fadeValue = 255; // moved to class
  // tAlmostUp = false; // moved to class
  //  startAddress = 0; // pixel address to start with
}

void loop() {
  // Fill along the length of the strip in various colors...
  //colorWipe(strip.Color(255,   0,   0), 50); // Red
  //colorWipe(strip.Color(  0, 255,   0), 50); // Green
  //colorWipe(strip.Color(  0,   0, 255), 50); // Blue
  // rainbow(20); //10            // Flowing rainbow cycle along the whole strip


  // ********** sensor reading: **********
  /*
    for (int i = 0; i < numSensors; i++) {
      distance[i] = hc.dist(i);
      Serial.print("distance is: ");
      Serial.println(distance[i]);
       delay(70);
    }
  */
  //distance[0] = hc.dist();
  //delay(60);
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  time = pulseIn(echo, HIGH);
  dist = (time / 2) / 29.1;
  if (dist > 500 or dist == 0) Serial.println("Out of Range");
  else {
    Serial.print(dist);
    Serial.println(" cm");
  }
  delay(500);

  distance[0] = dist;
  //Serial.println(distance[0]);


  // ********* reading evaluation: **********
  for (int i = 0; i < numSensors; i++) {
    // if distance is less than the threshold:
    if (distance[i] != 0 && distance[i] < maxDistanceThresholds[i]) {
      someoneNear = true;
      liteAny = true;
      Serial.println("              trigger");
      break;
    } else if ( distance[i] > maxDistanceThresholds[i]) { // if distance is greater than threshold
      someoneNear = false;
     // liteAny = false;
      Serial.println("             NOT trigger");
    }

  }
  /*
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

  **********************************
  */ 

  
  // ******** change color *********
  //
  //  //change color:
  if ( liteAny == true) {  //change this variable to be associated with any of them lite
    pixelHue += 256;
    if (pixelHue > 5 * 65536) {
      pixelHue = 0;
    }
    Serial.print("pixelHue is: ");
    Serial.println(pixelHue);
  }

  //  for (long firstPixelHue = pixelHue; firstPixelHue < 5 * 65536; firstPixelHue += 256) {
  //  }


  // ***** if someone is near: light 1 structure gradually
  // light 3 gradually
  if (someoneNear == true) {

    one.turnOn(pixelHue);
    someoneNear = false;
    //Serial.println("            can't repeat until new trigger");
  }


  // ***** animate for life of structure trigger
  // if we are not new, but lite, animate:
  else if ( liteAny == true) { //if any of the timers are still going
    int offCount = 0;
    for (int i = 0; i < sizeof(structures) - 1; i++) {
      if (structures[i].go(pixelHue) == false) {
        offCount++;
      }
    }
    // if the offCount is less than the number of structures that we have:
    if (offCount < sizeof(structures) - 1) {
      pixelHue += 500;
    } else if (offCount >= sizeof(structures) - 1){ // if we are all off then:
      liteAny = false;
    }
    Serial.print(" Hue (while lighting) is: ");
    Serial.println(pixelHue);
    Serial.println();
  } // lite = true


  Serial.print("liteAny is:   ");
  Serial.println(liteAny);

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

/* moved to class
  void lightLights(long color, bool fade, int pixelNum) {
  //
  if ( fade == true ) { // if we should be fading
    Serial.println("INSIDE FADE MECHANISM");
    for (int j = 255; j >= 80; j -= 5) { //fade down
      // set all the pixels at once (3 at a time):
      for (int i = pixelNum; i < pixelNum + 3 ; i++) { // For each pixel in strip...
        strip.setPixelColor(pixelNum, strip.gamma32(strip.ColorHSV(color, 255, j)));
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
    for (int i = pixelNum; i < pixelNum + 3 ; i++) { // For each pixel in strip...
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
*/


/*
   Moved to the Structure Class/Library


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
    for (int i = ledNum; i < ledNum + 3; i++) { // For each pixel in strip...
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue, 255, j)));
    }
    strip.show();
    delay(500);
  }
  }
*/


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

/* moved to class
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
*/
