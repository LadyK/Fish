#include <CapacitiveSensor.h>

/*
   CapitiveSense Library Demo Sketch
   Paul Badger 2008
   Uses a high value resistor e.g. 10M between send pin and receive pin
   Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
   Receive pin is the sensor pin - try different amounts of foil/metal on this pin
*/


CapacitiveSensor   cs_10_11 = CapacitiveSensor(10, 11);       // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
//CapacitiveSensor   cs_4_6 = CapacitiveSensor(4,6);        // 10M resistor between pins 4 & 6, pin 6 is sensor pin, add a wire and or foil
//CapacitiveSensor   cs_4_8 = CapacitiveSensor(4,8);        // 10M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil
long threshold;
int led = 6;
long readings[4];
long lastReading;
long currentReading;
long runningTotal;


void setup()
{
  cs_10_11.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example


  threshold = 500;

  pinMode(led, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  //long start = millis();
  //long total1 =   cs_10_11.capacitiveSensor(30);
  //long total2 =  cs_4_6.capacitiveSensor(30);
  //long total3 =  cs_4_8.capacitiveSensor(30);

  //Serial.print(millis() - start);        // check on performance in milliseconds
  //Serial.print("\t");                    // tab character for debug windown spacing

  //Serial.println(total1);                  // print sensor output 1
  // Serial.print("\t");
  // Serial.print(total2);                  // print sensor output 2
  // Serial.print("\t");
  // Serial.println(total3);                // print sensor output 3

  //delay(10);                             // arbitrary delay to limit data to serial port

  for (long i = 0; i < 4; i++) {
    long total1 =   cs_10_11.capacitiveSensor(30);
    readings[i] = total1;
    runningTotal += readings[i];
  }
  currentReading = runningTotal/4;
  Serial.println(currentReading);
  runningTotal = 0;
//  Serial.println();
//  Serial.println();
//  Serial.print("difference is: ");
//  Serial.println(abs(currentReading - lastReading));

  if (abs(currentReading - lastReading) > threshold) {  // this whill have it occur once on entry and once more upon exit; not continiously 
    digitalWrite(led, HIGH);

  }

  else {
    digitalWrite(led, LOW);
  }

 lastReading = currentReading;
  //delay(500);
}
