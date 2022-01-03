#include "Arduino.h"
#include "../../libraries/Adafruit_NeoPixel/Adafruit_NeoPixel.h"
#include "Structure.h"


Structure::Structure(int sNum, int startAdd, Adafruit_NeoPixel s)
{
	_sNum = sNum;  // structure number
	_startAdd = startAdd; // address of LED
	lite = false;  // are we lite up?
	lightPeriod = 40000; // how long it will stay lite
	almostUp = false; // are we close to dying?
	fadeValue = 255;
  strip = s;  // neoPixel pin?
	//almostDead = lightPeriod - 20000; //birthTime - lightPeriod; //when we are about to die

}



void Structure::turnOn(long pixelHue)
{
	//lite = true;
	//birthTime = millis();

  //almostDead = lightPeriod - 20000; //birthTime - lightPeriod; //when we are about to die
	int sat = 105; // was 150
  // turn each on, one at a time (for one structure):
  for (int i = _startAdd; i < (_startAdd + 3); i++) {
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

bool Structure::go(long pH)
{

    
	  //howOld(); //birthTime, lightPeriod, tAlmostUp, lite

    if(almostUp == false && lite == true){
      Serial.println("lighting");
      //pValue = light(pH);
      return true; // we are alive
    }else if (almostUp == true && lite == true ){
      Serial.println("fading");
      //fadeDown(pValue);
      return true; // we are alive
    }else if (almostUp == true && lite == false){
      Serial.println("turning off");
     // turnOff(0, 3);
      return false;  // we are dead
    }
	
}

long Structure::light(long pixel_)
{
      /*
      Serial.print("       light tAlmost up is:  ");
      Serial.println(_tAlmostUp);
      Serial.println();
      Serial.print("       light lite is:  ");
      Serial.println(_lite);
      Serial.println();
      */

	

  //else if (_tAlmostUp == false && _lite == true) {
    //fadeValue = 255;
    Serial.println(" lighting + color");
    //changing color a bit:
    for (long j = pixel_; j < pixel_ + 100; j+=10){
      //send out to each pixel:
      for (int i = _startAdd; i < _startAdd + 3 ; i++) { // For each pixel in strip...
       strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(j, 255, 255)));
      }
      //update them all at once:
      strip.show(); // Update strip with new contents at once
      delay(250);  // Pause for a moment
      p = j;
   }
/*
    Serial.print("    Color is: ");
    Serial.println(pixelHue);
    Serial.print("    fade is: ");
    Serial.println(fade);
    */
   // lite = true;
  //}
  /*
  else if (_tAlmostUp == true && _lite == false){
  	turnOff(0, 3);
    lite = false;
  	///*
  	Serial.println("*****no Lights****");
  	Serial.println();
  	//*/
  //}
  //return lite;
  return p;

}

void Structure::fadeDown(long pH_){
  //if ( _tAlmostUp == true && _lite == true) { // if we should be fading
    Serial.println("INSIDE FADE MECHANISM");
    for (int j = 255; j >= 0; j -= 10) { //fade down opacity
      // set all the pixels at once (3 at a time):
      for (int i = _startAdd; i < (_startAdd + 3) ; i++) { // For each pixel in strip...
        strip.setPixelColor(i, strip.gamma32(strip.ColorHSV(pH_, 255, j)));
        //Serial.print("led #: ");
       //Serial.println(i);
      }
      strip.show();
      
//*
      Serial.print("    fadeValue is: ");
      Serial.println(j);
    //  Serial.println("    FADING ");
//*/
      delay(500);  // Pause for a moment
    }
    //lite = false;
    //lite = _lite;
  //}

   
}


void Structure::turnOff(uint32_t color, int wait)
{

// Fill strip pixels one after another with a color. Strip is NOT cleared
// first; anything there will be covered pixel by pixel. Pass in color
// (as a single 'packed' 32-bit value, which you can get by calling
// strip.Color(red, green, blue) as shown in the loop() function above),
// and a delay time (in milliseconds) between pixels.

  for (int i = _startAdd; i < (_startAdd + 3); i++) { // For each pixel in strip...
    strip.setPixelColor(i, color);         //  Set pixel's color (in RAM)
                               //  Pause for a moment
    //Serial.print("off address is: ");
    //Serial.println(i);
    //Serial.println();
  }
    strip.show();                          //  Update strip to match
    delay(wait);
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
void Structure::howOld(){ //birthTime, lightPeriod, tAlmostUp, lite
	//age = millis() - birthTime; //millis() - birthTime
	//temp_almostDead = (lightPeriod - 10000); // = lightPeriod - 10000
    if( age > almostDead){
      //tA = true;
      //almostUp = true; //_tAlmostUp
      Serial.print("       howOld tAlmost up is:  ");
      Serial.println(almostUp);
      Serial.println();
    } else if (age < almostDead){
      //almostUp = false;
      Serial.print("       howOld tAlmost up is:  ");
      Serial.println(almostUp);
      Serial.println();
    }
    if(age > lightPeriod) {
      //l = false;
    //lite = false; // if(age > lightPeriod) lite = false
    Serial.print("       howOld lite is:  ");
    Serial.println(lite);
    Serial.println();
  } else if (age < lightPeriod){
    //lite = true; // if(age > lightPeriod) lite = false
    Serial.print("       howOld lite is:  ");
    Serial.println(lite);
    Serial.println();
  }
	//return age;
}
//*/