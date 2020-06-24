import codeanticode.syphon.*;

PGraphics canvas;
SyphonServer server;

int numColors = 400;
float curTime;
int opacity = 20;
float r, g, b;

void setup() { 
  size(1920, 1080, P3D);
  colorMode(RGB, 1.0, 1.0, 1.0, 255);
   frameRate(10);
  //canvas = createGraphics(1920, 1080, P3D);
  server = new SyphonServer(this, "Processing Syphon");
  noStroke();
}

void draw() {
 
  color c = (10);
  float curTime = millis()/1000.0;
  noStroke();
  for (int i=100; i< numColors; i++) {
    r = sin(curTime * 0.8f + i * 0.0011f) + 0.5f;
    g = sin(curTime * 0.7f + i * 0.0013f) + 0.5f;
    b = sin(curTime * 0.3f + i * 0.0017f) + 0.5f;
    c = color(r, g, b, opacity);
  }
    fill(c);

    rect(0, 0, 1920, 1080);

    
   
    server.sendScreen();
  
}
