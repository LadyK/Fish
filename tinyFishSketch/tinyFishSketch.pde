//color shimmer;
//float rand;
////int flutwidth;
//float z, t, tc, noiseVal, noiseValCum;

int octaves = 4;
float falloff = 0.3;
float noiseScale = 0.2;

color midColor, topColor, bottomColor, interColor;
float threshold = 0.90;

School school;

void setup() {
  size(800, 800, P3D);
  school = new School();
  PVector loc = new PVector(width/2, height/2);
  for (int i = 0; i < 30; i++) {
    Fish f = new Fish(loc);
    school.addFish(f);
  }
  background(0);
  shimmer = 127;
  noStroke();
  //flutwidth = 2;
  noiseDetail(octaves, falloff);
  topColor = color(160);
  midColor = color(127);
  bottomColor = color(100);
}


void draw() {
  background(0);
  school.run();

  //*/

  //z = int(ra8om(-30, 30));
  //for (int y = 0; y < 30; y++) {
  //  for (int x = 0; x < 30; x++) {
  // z = int(sin(sqrt(x*x + y*y)));
  //shimer 

  // if (frameCount%13 == 3) { //needs to happen more slowly + organically

  //float randie = random(0, 1);
  //if (randie > .8) {
  //  t += 0.1;
  //  noiseVal = noise(t);
  //  noiseValCum += noiseVal;
  
    //   flt colorNoise = noise(t);
    //   float1 = random(0, 1);
    //float noiseX = map(mouseX, 0, width, 0, 400); //change these off the mouse
    //float noiseY = map(mouseY, 0, height, 0, 400);
    //float z1 = noise(noiseX, noiseY);
    //float noiseYM = max(0, z1);
    //println(noiseVal
  //  println(noiseValCum);
    //if (noiseValCum > 4) {

    //  float randieC = random(0, 4);
    //  float amount = map(randieC, 0, 4, 0, 1);
    //  interColor = lerpColor(midColor, topColor, amount);
    //  noiseValCum = 0;
    //} else {
    //  float randieC = random(0, 2);
    //  float amount= map(randieC, 0, 2, 0.5, 1);
    //  interColor = lerpColor(bottomColor, midColor, amount);
    //}

    ///float noiseamountoi  ///shimmer =nt(shimmer + noiseVal);
   // shimmer = interColor;
    // *intercolor = shimmer;/
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
 // }



  //pushMatrix();
  //translate(width/2, height/2);  
  //rotateY(noiseVal);
  //fill(shimmer);
  //ellipse(0, 0, 200, 200);
  //popMatrix();
  // }
  // }


  //flutwidth = 0;
}

void mouseClicked() {
  //flutwidth = int(random(-80, 80));
}
