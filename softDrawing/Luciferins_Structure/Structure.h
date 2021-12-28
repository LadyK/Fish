

/*
Structure.h - Library for individual fiber structure's LED control. Intended for a soft drawing of Luciferins

*/


#ifndef Structure_h
#define Structure_h

#include "Arduino.h"
#include "../../libraries/Adafruit_NeoPixel/Adafruit_NeoPixel.h"


class Structure
{
	
	public:
	   Structure(int sNum, int startAdd, Adafruit_NeoPixel s);
	   void turnOn(int pixelHue);
	   bool light(int pixelHue_);
	   void turnOff(uint32_t color, int wait);
	   void howOld();
	   bool go(int pH);
	   bool lite;
	   //unsigned long birthTime;
	   //unsigned long lightPeriod;
	   int fadeValue;
	   Adafruit_NeoPixel strip;
	   unsigned long age;
	   //unsigned long tAlmostUp;
	


	private:
		int _sNum;
		int _startAdd;
		//long _tAlmostUp;
		unsigned long _temp_almostDead;
		unsigned long _birthTime;
		unsigned long _lightPeriod;
		unsigned long _tAlmostUp;
		bool _lite;


};

#endif