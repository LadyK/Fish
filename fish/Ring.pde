/*
this is the base unit for a shape. It makes 1 ring/unit
 
 References: 
 // Generative Gestaltung, ISBN: 978-3-87439-759-9
 // First Edition, Hermann Schmidt, Mainz, 2009
 // Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
 
 */

class Ring {
  int numPoints = 5;
  float r;  // 25, 75, 125
  int stepSize;  // 10 - 125  /* size 10, with 5 shapes, is cool effect */
  //float distortionFactor = 1;
  float centerX, centerY;
  float [] x = new float[numPoints];
  float [] y = new float[numPoints];
  int rd, gn, blu;
  //float centerX = width/2;
  //float centerY = height/2;
  float opacity = 50;
  float age;

  Ring(int mX, int mY, int rad_, int s) {

    smooth();
    centerX = mX;
    centerY = mY;
    r = rad_;
    float angle = radians(360/float(numPoints));
    /*
    assign values to x + y, which create a circular shape 
     */
    for (int i = 0; i < numPoints; i++) {
      x[i] = cos(angle*i) * r;
      y[i] = sin(angle*i) * r;
    }
    age = 0;
    stepSize = s;
  }

  void display() {
    // stroke fill here
    //stroke(0, opacity); // line-y scribble; better when stepsize is lower
    noStroke();

    float rand2 = random(0, 1); // new step

    if (rand2 > .2) { // lower this and increase in diversity of size each ring

      // modify/update points for the ring
      // x,y locations are updated with stepsize for each point on the ring    
      for (int i = 0; i < numPoints; i++) {  
        x[i] += random(-stepSize, stepSize);
        y[i] += random(-stepSize, stepSize);
      }
    }

    strokeWeight(0.75);
    /*
     x[numPoints-2] = mouseX;
     y[numPoints-2] = mouseY;
     */

    float rand3 = random(0, 1);

    if (rand3 > 0.9) {  // lower this and increase color difference
      rd = 0;
      gn = int(random(128, 255));
      blu = int(random(128, 255));  //0, 192
    }


    fill(rd, gn, blu, opacity);  // opacity was 25

    beginShape();
    //start controlpoint from the last point in the array
    curveVertex(x[numPoints-1]+centerX, y[numPoints-1]+centerY);
    //curveVertex(x[numPoints-1], y[numPoints-1]);

    //only these points are drawn
    for (int i = 0; i < numPoints; i++) {
      //for (int i = numPoints-1; i >= 0; i--) {
      curveVertex(x[i]+centerX, y[i]+centerY); //x, y with reference to orginal mouse
      // from birth
    }
    //
    curveVertex(x[0]+centerX, y[0]+centerY);
    //end control point

    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();
    //opacity--;  // <-- muck with opacity here; good for faster disappear without slow down at the end in shape
    age++;
    /*
    //if we are young, fade faster
    if (age < 10) {
      opacity--;  // <-- muck with opacity here
    }
    // if we are old, linger a bit
    if (age >= 10) {
      opacity = opacity - 0.5;  //0.25 is quite slow,, but interesting. 
    }
    */
  }


  void move() {
    if (mouseX != 0 || mouseY != 0) {
      centerX += (mouseX-centerX) * 0.01;
      centerY += (mouseY-centerY) * 0.01;
    }
  }

  void portalGrowth(int r__) { //(int cX, int cY, int r__)
    //centerX = cX;
    //centerY = cY;
    float angle = radians(360/float(numPoints));
    float radius = r__ * random(0.5, 1.0);
    radius = constrain(radius, 0.0, 3.5); // limit the radius
    print("Radius is:  "); println(radius);
    for (int i = 0; i < numPoints; i++) {  
      x[i] += cos(angle * i) * radius;
      y[i] += sin(angle * i) * radius;
    }
  } //portal

  void shiftLocs() {
    // Shift array values:
    // /*
    for (int i = 0; i < numPoints-1; i++) {
      x[i] = x[i+1];
      y[i] = x[i+1];
    }
    //*/
    //capture new location:   // <--- this isn't going to work
    x[numPoints-1] = mouseX;  // <--- needs to be done to centerX
    y[numPoints-1] = mouseY;
  } //shiftLocs
} // end shape class