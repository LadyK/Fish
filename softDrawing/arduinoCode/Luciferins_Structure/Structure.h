

/*
Structure.h - Library for individual fiber structure's LED control. Intended for a soft drawing of Luciferins

*/


#ifndef Structure_h
#define Structure_h

#include "Arduino.h"
#include "Adafruit_NeoPixel.h"


class Structure
{
	
	public:
	   Structure(int sNum, int startAdd);
	   void turnOn(int pixelHue);
	   void light(int pixelHue);
	   void turnOff(uint32_t color, int wait);
	   long howOld();
	   bool lite;
	   long birthTime;
	   long lightPeriod;
	   int fadeValue;

	private:
		int _sNum;
		int _startAdd;
		long _tAlmostUp;


};

#endif