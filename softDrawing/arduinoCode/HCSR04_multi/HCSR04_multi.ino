#include <HCSR04.h>

HCSR04 hc(9, new int[1]{5}, 1); //initialisation class HCSR04 (trig pin , echo pin, number of sensor)

void setup()
{
    Serial.begin(9600);
}

void loop()
{
    for (int i = 0; i < 1; i++)
        Serial.println(hc.dist(i)); //return curent distance in serial for sensor 1 to 6
    delay(60);                      // we suggest to use over 60ms measurement cycle, in order to prevent trigger signal to the echo signal.
}
