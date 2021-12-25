#include "Arduino.h"
#include "../../libraries/Adafruit_NeoPixel/Adafruit_NeoPixel.h"
#include "Structure.h"


Structure::Structure(int sNum, int startAdd, Adafruit_NeoPixel s)
{
	_sNum = sNum;  // structure number
	_startAdd = startAdd; // address of LED
	lite = false;  // are we lite up?
	lightPeriod = 40000; // how long it will stay lite
	tAlmostUp = false; // are we close to dying?
	fadeValue = 255;
    strip = s;  // neoPixel pin?
	

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

void Structure::go(int pH)
{

	howOld(bt, lp, tA, l); //birthTime, lightPeriod, tAlmostUp, lite
	light(pH);
	
}



void Structure::light(int pixelHue)
{
	if ( tAlmostUp == true && lite == true) { // if we should be fading
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
  else if (tAlmostUp == false && lite == true) {
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
  else if (tAlmostUp == true && lite == false){
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
/*
void howOld(){ //birthTime, lightPeriod, tAlmostUp, lite
	long age = millis() - birthTime; //millis() - birthTime
	long temp_almostDead = lightPeriod - 10000; // = lightPeriod - 10000
    if( age > temp_almostDead){
      tAlmostUp = true; //_tAlmostUp
    }
    if(age > lightPeriod) lite = false; // if(age > lightPeriod) lite = false
	//return age;
}
*/

///*
void howOld(long bt, long lp, bool tA, bool l){ //birthTime, lightPeriod, tAlmostUp, lite
	long age = millis() - bt; //millis() - birthTime
	long temp_almostDead = lp - 10000; // = lightPeriod - 10000
    if( age > temp_almostDead){
      tA = true; //_tAlmostUp
    }
    if(age > lp) l = false; // if(age > lightPeriod) lite = false
	//return age;
}
//*/