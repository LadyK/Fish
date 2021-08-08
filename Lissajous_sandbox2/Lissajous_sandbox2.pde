int pointCount = 600;
int freqX = 1;
int freqY = 2;
float phi = 90;

int freq = 2;
float modFreq = 12;
float changeMod =.005;


float modFreqX = 2;
float modFreqY = 1;
float changemodX = .5;
float changemodY = .001;

float angle;
float x, y;
float factorX, factorY;

int margin = 25;

int changeY = 1;
int changeX = 1;

void setup() {
  size(800, 800, P2D);
  smooth();

  //frameRate(5);
}




void draw() {
  background(255);
noStroke();
fill(37, 94, 250, 100);
beginShape();
 vertex(50, 50);
 vertex(250, 50);
 
 vertex(175, 480);
 vertex(80, 450);



endShape();


  //pushMatrix();
  //translate(0, 300);
  //curveMe(53, .389, .2);
  //popMatrix();


  //pushMatrix();
  //translate(400, 0);
  //rotate(radians(90));
  
  //curveMe(10, .589, .1);
  //popMatrix();

  //translate(width/2+ 200, height/2);


  //pointCount = int(map(mouseX, 0, width, 0, 600));
  //  maniFreqX();

  //pushMatrix();
  //// draw x oscillator
  //translate(0, 200);
  //beginShape();
  //for (int i=0; i<=pointCount; i++) {
  //  angle = map(i, 0, pointCount, 0, TWO_PI);
  //  x = sin(angle*freqX + radians(phi));
  //  x = x * (width/4-margin);
  //  y = -height*2/3.0-margin + (float)i/pointCount * (height/2-2*margin);
  //  vertex(x, y);
  //}
  //endShape();
  //popMatrix();



  // draw y oscillator
  //pushMatrix();
  //translate(0, 200);
  //stroke(0);
  //beginShape();
  //for (int i=0; i<=pointCount; i++) {
  //  angle = map(i, 0, pointCount, 0, TWO_PI);
  //  y = sin(angle*freqY);
  //  y = y * (height/4-margin);
  //  x = -width*2/3.0-margin + (float)i/pointCount * (width/2-2*margin);
  //  vertex(x, y);
  //}
  //endShape();
  //popMatrix();


  pushMatrix();
  translate(0, 150);
  scale(.5);
  //beginShape();
  //for (int i=0; i<=pointCount; i++) {
  //  angle = map(i, 0, pointCount, 0, TWO_PI);

  //  // modFreq();
  //  //float info = sin(angle * freq + radians(phi));
  //  //float carrier = cos(angle * modFreq);
  //  //y = info * carrier;

  //  modFreqX();

  //  x = sin(angle*freqX + radians(phi))  * cos(angle * modFreqX);
  //  y = sin(angle*freqY) * cos(angle * modFreqY);

  //  x = x * factorX;
  //  y = y * factorY;

  //  vertex(x, y);
  //}
  //endShape();
  popMatrix();

  //noLoop();
}

void curveMe(int o, float h, float l) {

  beginShape();
  //fill(37, 94, 250, 100);
  stroke(37, 94, 250, 100);
  strokeWeight(2);
  for (int i = 0; i <= pointCount; i++) {

    if ( i % 200 == 0) {
      fill(0, 0, 255, 100);
      //} else if ( i % 10 == 0) {
      //  fill(0, 0, 255, 50);
      //} else if ( i % 5 == 0) {
      //  fill(0, 0, 255, 80);
      //} else if ( i % 2 == 0) {
      //  fill(0, 0, 255, 200);
    } else {
      noFill();
    }

    angle = map(i, 0, pointCount, 0, TWO_PI);
    modFreq(o, h, l);
    float info = sin(angle * freq + radians(phi));
    float carrier = cos(angle * modFreq);
    y = info * carrier;
    //fun:
    //float r_ = random(0, .5);
    //if (r_ > .489) {
    //  y = y + .05;
    //}
    //println(y);

    //    x = sin(angle*freqX + radians(phi))  * cos(angle * modFreq);
    //    y = sin(angle*freqY) * cos(angle * modFreq);

    //    x = x * factorX;
    //    y = y * factorY;


    y = y * (height/4);
    vertex(i, y);
  }
  endShape();
}


void maniFreqX() {
  //  freqY+= changeY;

  //if (freqY > 7) {
  //  changeY = changeY * -1;
  //}

  //if (freqY < 2) {
  //  changeY = changeY * -1;
  //}
  float r = random(0, 1);

  if (r >.9998) {
    //changeX = changeX * -1;
    freqX += changeX;
  }
  if ( r < .02) {
    freqX -= changeX;
  }

  //freqX += changeX;

  if (freqX > 7) {
    changeX = changeX * -1;
  }

  if (freqX < 1) {
    changeX = changeX * -1;
  }
}


void modFreq(int often, float high, float low) {
  if (frameCount % often == 0) {  // was 53  // 10
    float r = random(0, .5);

    if (r > high) { // .389
      modFreq += changeMod;
    }
    if (r < low) {  // .2
      modFreq -= changeMod;
    }
    //}

    if (modFreq > 10) {
      modFreq = 1;
    }

    if (modFreq < -10) {
      modFreq = 1;
    }

    println(modFreq);
  }
}

void modFreqX() { //** needs sorting and smoothing
  if (frameCount % 47 == 0) {
    float r = random(0, .5);

    if ( r > .48) {
      modFreqX += changemodX;
    }
    if ( r < .12) {
      modFreqX -= changemodX;
    }
    if (modFreqX > 12) {
      //changemodX = changemodX * -1;
      modFreqX = 1;
    }
    if (modFreqX < -0.5) {
      //changemodX = changemodX * -1;
      modFreqX = 2;
    }
  }
  println(modFreqX);
}

void mousePressed() {

  modFreqX += changemodX;


  if (modFreqX > 12) {
    changemodX = changemodX * -1;
  } else if (modFreqX < -0.5) {
    changemodX = changemodX * -1;
  }
  println(modFreqX);

  //modFreq += changeMod;

  ////println(modFreq);

  //if (modFreq > 15) {
  //  modFreq = 1;
  //}

  //freqY+= changeY;

  //if (freqY > 7) {
  //  changeY = changeY * -1;
  //}

  //if (freqY < 2) {
  //  changeY = changeY * -1;
  //}

  //freqX += changeX;

  //if (freqX > 7) {
  //  changeX = changeX * -1;
  //}

  //if (freqX < 1) {
  //  changeX = changeX * -1;
  //}


  //println(freqX);
}
