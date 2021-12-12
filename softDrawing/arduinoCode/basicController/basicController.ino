/*Arduino Controller I2C*/

#include <Wire.h>
#define ledPin 9

//byte rcvData;
int potValue;
int rcvData;

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
  rcvData = 255;
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  potValue = analogRead(A2);
  Serial.println(potValue);
  potValue = map(potValue, 0, 1023, 0, 255);

  Wire.beginTransmission(4);  // transmit to device #4 // 0x14 
  Wire.write(potValue);
  Wire.endTransmission();

  delay(2000);

//  Wire.requestFrom(0x14, 1);
//  if (Wire.available())
//  {
//    rcvData = Wire.read();
//  }

  analogWrite(ledPin, rcvData);
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany)
{
  while(1 < Wire.available()) // loop through all but the last
  {
    char c = Wire.read(); // receive byte as a character
    Serial.print(c);         // print the character
  }
  rcvData = Wire.read();    // receive byte as an integer
  Serial.print("rcvData is: ");
  Serial.println(rcvData);         // print the integer
}
