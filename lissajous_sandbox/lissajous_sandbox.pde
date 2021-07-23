/*
Referenced from 
 // Generative Gestaltung, ISBN: 978-3-87439-759-9
 // http://www.generative-gestaltung.de
 A fabulous and beautiful text!
 M_2_3_02.pde
 */


//float r = 8;

int pointCount;

int freqX = 1;
int freqY = 4;
float phi = 60;
int modFreqX = 2;
int modFreqY = 1;
float modulationPhi = 0;

float angle, x, y, w, maxDist, oldX, oldY;

void setup() {
  size(800, 800);
  pointCount = width-100;
  smooth();
  strokeCap(ROUND);
  maxDist = sqrt(sq(width/2-50) + sq(height/2-50));
}



void draw() {
  background(255);

  strokeWeight(1);
  stroke(0);
  noFill();
  //pointCount = mouseX*2+200;

  //float x = r * cos(angle - HALF_PI);
  //float y = r * sin(angle - HALF_PI);
  translate(width/2, height/2);
  beginShape();
  for (int i = 0; i <= pointCount; i++) {
    angle = map(i, 0, pointCount, 0, TWO_PI);
    x = sin(angle * freqX + radians(phi)) * cos(angle * modFreqX);
    y = sin(angle * freqY) * cos(angle * modFreqY);
    x = x * (width/2-50);
    y = y * (height/2-50);
    /*
    if( i > 0){
     w = dist(x, y, 0, 0);
     float lineAlpha = map(w, 0, maxDist, 255, 0);
     stroke(i%2*2, lineAlpha);
     line(oldX, oldY, x, y);
     
     }
     oldX = x;
     oldY = y;
     */
    vertex(x, y);
  }
  endShape();
}

void keyPressed() {

  if (key == '1') freqX--;
  if (key == '2') freqX++;
  freqX = max(freqX, 1);

  if (key == '3') freqY--;
  if (key == '4') freqY++;
  freqY = max(freqY, 1);

  if (keyCode == LEFT) phi -= 15;
  if (keyCode == RIGHT) phi += 15;

  if (key == '7') modFreqX--;
  if (key == '8') modFreqX++;
  modFreqX = max(modFreqX, 1);

  if (key == '9') modFreqY--;
  if (key == '0') modFreqY++;
  modFreqY = max(modFreqY, 1);
}
