#include "Arduino.h"
#include "Structure.h"
#include "Adafruit_NeoPixel.h"

Structure::Structure(int sNum, int startAdd)
{
	_sNum = sNum;
	_startAdd = startAdd;
	lite = false;
	lightPeriod = 40000; // how long it will stay lite
	tAlmostUp = false; 
	fadeValue = 255;
	

}


void Structure::turnOn(int pixelHue)
{
	lite = true;
	birthTime = millis();
	int sat = 105; // was 150
  // turn each on, one at a time (for one structure):
  for (int i = _startAdd; i < 3; i++) {
    strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue, 255, sat)));
    strip.show(); // Update strip with new contents
    delay(1500);  // Pause for a moment
  }
  //fade up:
  for (int j = sat; j <= 255; j += 10) { //fade up
    // set all the pixels at once:
    for (int i = _startAdd; i < _startAdd + 3; i++) { // For each pixel in strip...
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue, 255, j)));
    }
    strip.show();
    delay(500);
  }

}


void Structure::light(int pixelHue)
{
	if ( _tAlmostUp == true && lite == true) { // if we should be fading
    Serial.println("INSIDE FADE MECHANISM");
    for (int j = 255; j >= 80; j -= 5) { //fade down
      // set all the pixels at once (3 at a time):
      for (int i = _startAdd; i < _startAdd + 3 ; i++) { // For each pixel in strip...
        strip.setPixelColor(_startAdd, strip.gamma32(strip.ColorHSV(pixelHue, 255, j)));
      }
/*
      Serial.print("    fadeValue is: ");
      Serial.println(j);
      Serial.println("    FADING ");
*/
      strip.show();
      delay(500);  // Pause for a moment
    }
    lite = false;
  }
  else if (_tAlmostUp == false && lite == true) {
    //fadeValue = 255;
    Serial.println("    not fading");
    for (int i = _startAdd; i < _startAdd + 2 ; i++) { // For each pixel in strip...
      strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pixelHue, 255, 255)));
    }
    //update them all at once:
    strip.show(); // Update strip with new contents at once
    delay(50);  // Pause for a moment
/*
    Serial.print("    Color is: ");
    Serial.println(pixelHue);
    Serial.print("    fade is: ");
    Serial.println(fade);
    */
  }
  else if (_tAlmostUp == true && lite == false){
  	turnOff(0, 3);
  	/*
  	Serial.println("*****no Lights****")
  	Serial.println();
  	*/
  }

}


void Structure::turnOff(uint32_t color, int wait)
{

// Fill strip pixels one after another with a color. Strip is NOT cleared
// first; anything there will be covered pixel by pixel. Pass in color
// (as a single 'packed' 32-bit value, which you can get by calling
// strip.Color(red, green, blue) as shown in the loop() function above),
// and a delay time (in milliseconds) between pixels.

  for (int i = _startAdd; i < _startAdd + 2; i++) { // For each pixel in strip...
    strip.setPixelColor(i, color);         //  Set pixel's color (in RAM)
    strip.show();                          //  Update strip to match
    delay(wait);                           //  Pause for a moment
  }
}

long howOld(){
	long age = millis() - birthTime;
    if( age > (lightPeriod - 10000)){
      tAlmostUp = true;
    }
    if(age > lightPeriod) lite = false;
	return age;
}