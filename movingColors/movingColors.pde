int numColors = 400;
float curTime;
int opacity = 20;
float r, g, b;

void setup() {
  size(400, 400);
   colorMode(RGB, 1.0, 1.0, 1.0, 255);
   frameRate(10);
}


void draw() {
  color c = (10);
  float curTime = millis()/1000.0;
 noStroke();
  for (int i=100; i< numColors; i++) {
    /*
    c = color(
      sin(curTime * 0.8f + i * 0.0011f), //R
      sin(curTime * 0.7f + i * 0.0013f), //G * 0.5f + 0.5f
      sin(curTime * 0.3f + i * 0.0017f), //B
      opacity);
      */
       r = sin(curTime * 0.8f + i * 0.0011f) + 0.5f;
       g = sin(curTime * 0.7f + i * 0.0013f) + 0.5f;
      b = sin(curTime * 0.3f + i * 0.0017f) + 0.5f;
      c = color(r,g,b, opacity);
      println(r);
  }
  fill(c);
  
  rect(0, 0, 400, 400);
  //print("(");
  //print(c.r);
}
