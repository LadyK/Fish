/*Arduino Agent I2C*/

#include <Wire.h>
#define ledPin 9

byte rcvData;
int potValue;

void setup()
{
//  Wire.begin(0x14);
 Wire.begin(4);
  /*Event Handlers*/
  Wire.onReceive(DataReceive);
  Wire.onRequest(DataRequest);
  
  rcvData = 255;
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  potValue = analogRead(A2);
  Serial.println(potValue);
  potValue = map(potValue, 0, 1023, 0, 255);
  analogWrite(ledPin, rcvData);
}

void DataReceive(int numBytes)
{
  while(Wire.available()) 
  { 
    rcvData = Wire.read();
  }
  Serial.print("rcvData is: ");
  Serial.println(rcvData);
}

void DataRequest()
{
  Wire.write(potValue);
}
