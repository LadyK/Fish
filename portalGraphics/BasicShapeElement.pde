class BasicShapeElement {
  int numPoints;
  float r;//  = 25; //width of shape  future= relation to body re: w + h
  int stepSize; // = 1;
  //float distortionFactor = 1;
  float centerX, centerY;
  float [] x; // = new float[numPoints];
  float [] y; // = new float[numPoints];
  int rd, gn, blu;
  float opacity; //= 0; // 100
  float op_start;// = 50; // orignation of opacity
  float opChanger;  ///slow down death
  float angle;

  BasicShapeElement(int x_, int y_, int pts, int radius) {
    numPoints = pts;
    x = new float[numPoints];
    y = new float[numPoints];
    opacity = 0;
    op_start= 50;
    stepSize = 1;
    r = radius;
    smooth();
    centerX = x_;
    centerY = y_;
    angle = radians(360/float(numPoints));
    //print("numPoints is: "); println(numPoints);
    for (int i = 0; i < numPoints; i++) {
      x[i] = cos(angle*i) * r;
      y[i] = sin(angle*i) * r;
    }
  } // constructor

  void display(boolean line, int rd, int gn, int blu, int op) {
    if (line == true) {
      stroke(0, op);
      strokeWeight(0.75);
    }
    fill(rd, gn, blu, op); // opacity was manually set at 25 -> ?
    beginShape();
    //start controlpoint from the last point in the array
    curveVertex(x[numPoints-1]+centerX, y[numPoints-1]+centerY);

    //only these points are drawn
    for (int i = 0; i < numPoints; i++) {
      curveVertex(x[i]+centerX, y[i]+centerY);
    }
    //
    curveVertex(x[0]+centerX, y[0]+centerY);
    //end control point

    curveVertex(x[1]+centerX, y[1]+centerY);
    endShape();
  } // display

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

  void featureShifter() {
    // location of points, shift slightly for motion:
    float rand2 = random(0, 1);
    if (rand2 > .95) {
      // new points for the shapes
      for (int i = 0; i < numPoints; i++) {
        x[i] += random(-stepSize, stepSize);
        y[i] += random(-stepSize, stepSize);
      }
    }
  }// feature shifter
}
