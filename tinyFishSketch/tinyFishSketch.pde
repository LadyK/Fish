color shimmer;
float rand;
int flutwidth;
float z, t;

int octaves = 4;
float falloff = 0.3;
float noiseScale = 0.2;

color midColor, topColor, bottomColor;
float threshold = 0.30;

void setup() {
  size(800, 800, P3D);
  background(0);
  shimmer = 127;
  noStroke();
  //flutwidth = 2;
  
  topColor = color(180);
  midColor = color(127);
  bottomColor = color(80);
}


void draw() {
  background(0);
  noiseDetail(octaves, falloff);

  //*/

  //z = int(random(-30, 30));
  //for (int y = 0; y < 30; y++) {
  //  for (int x = 0; x < 30; x++) {
  // z = int(sin(sqrt(x*x + y*y)));
  //shimer 

  // if (frameCount%13 == 3) { //needs to happen more slowly + organically

  float randie = random(0, 1);
  if (randie > .7) {
    
    float noiseX = map(mouseX, 0, width, 0, 400); //change these off the mouse
    float noiseY = map(mouseY, 0, height, 0, 400);
    float z1 = noise(noiseX, noiseY);
    float noiseYMax = max(0, z1);
    color intercolor;
    if(z1 <= threshold){
      float amount = map(z1, 0, threshold, 0.15, 1);
      intercolor = lerpColor(bottomColor, midColor, amount);
    }
    else {
      float amount = map(z1, threshold, noiseYMax, 0, 1);
      intercolor = lerpColor(midColor, topColor, amount);
    }
  
    //float noiseVal = noise(shimmer+noiseScale);
    //shimmer = int(shimmer + noiseVal);
    shimmer = intercolor;

    // */
    /*  //no
     else if (rand < .6){
     shimmer = 150;
     }
     else if (rand < .4){
     shimmer = 100;
     }
     */
    ///* // yes
    /*
    else if (rand < .2) {
     shimmer = 50;
     } else {
     shimmer = 20;
     }
     */
    //float r = random(-.5, .5);
   
  }
  
   //float noiseVal = map(mouseX, 0, width, 0, noiseScale);//noise((mouseX ) * noiseScale);
   t = t + 0.1;
   float noiseVal = noise(t);
   z = noiseVal; // was PI/noiseVal
  
  pushMatrix();
  translate(width/2, height/2);
  rotateY(z);
  fill(shimmer);
  ellipse(0, 0, 200, 200);
  popMatrix();
  // }
  // }


  flutwidth = 0;
}

void mouseClicked() {
  flutwidth = int(random(-80, 80));
}
