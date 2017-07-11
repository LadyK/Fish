/*
this is the base unit for a shape. It makes 1 ring/unit

*/

class Ring {
  int numPoints = 10;
  float r = 10;  // 25, 75, 125
  int stepSize = 2;  // 10 - 125
  //float distortionFactor = 1;
  float centerX, centerY;
  float [] x = new float[numPoints];
  float [] y = new float[numPoints];
  int rd, gn, blu;
  //float centerX = width/2;
  //float centerY = height/2;
  int opacity = 50;


  Ring(int mX, int mY) {

    smooth();
    centerX = mX;
    centerY = mY;
    float angle = radians(360/float(numPoints));
    for (int i = 0; i < numPoints; i++) {
      x[i] = cos(angle*i) * r;
      y[i] = sin(angle*i) * r;
    }
  }

  void display() {
  // stroke fill here
   //stroke(0, opacity); // line-y scribble 
   noStroke();
   
    float rand2 = random(0, 1); // new step

    if (rand2 > .4) { // lower this and increase in diversity of size
      // new points for the shapes
      //for (int i = 0; i < numPoints; i++) {
        for (int i = numPoints-1; i >= 0; i--) {
        x[i] += random(-stepSize, stepSize);
        y[i] += random(-stepSize, stepSize);
      }
    }

    strokeWeight(0.75);
  
  
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

    //only these points are drawn
    for (int i = 0; i < numPoints; i++) {
      //for (int i = numPoints-1; i >= 0; i--) {
      curveVertex(x[i]+centerX, y[i]+centerY);
    }
    //
    curveVertex(x[0]+centerX, y[0]+centerY);
    //end control point

    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();
    opacity--;
  }

  void move() {
    if (mouseX != 0 || mouseY != 0) {
      centerX += (mouseX-centerX) * 0.01;
      centerY += (mouseY-centerY) * 0.01;
    }
  }

  void newLoc(int cX, int cY) {
    centerX = cX;
    centerY = cY;
    float angle = radians(360/float(numPoints));
    float radius = r * random(0.5, 1.0);
    for (int i = 0; i < numPoints; i++) {
      x[i] = cos(angle * i) * radius;
      y[i] = sin(angle * i) * radius;
    }
  } //newLoc
  
  
} // end shape class