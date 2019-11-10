class BasicShapeElement {
  int numPoints;
  float r;//  = 25; //width of shape  future= relation to body re: w + h
  int stepSize; // = 1;
  //float distortionFactor = 1;
  float centerX, centerY;
  float [] x; // = new float[numPoints];
  float [] y; // = new float[numPoints];
  int rd, gn, blu;
  int opacity; //= 0; // 100
  int op_start;// = 50; // orignation of opacity
  int opChanger;  ///slow down death
  float angle;
  float birthTime;
  boolean dead, line;
  PVector middle;
  

  BasicShapeElement(int x_, int y_, int pts, int radius) {
    dead = false;
    numPoints = pts;
    x = new float[numPoints];
    y = new float[numPoints];
    opacity = 150;
    op_start= 50;
    stepSize = 1; // crazy at 5 very jiggly
    r = radius;
    line = true;
    smooth();
    rd = 0;
    gn = int(random(128, 255));
    blu = int(random(0, 192));
    centerX = x_;
    centerY = y_;
    angle = radians(360/float(numPoints));
    //print("numPoints is: "); println(numPoints);
    for (int i = 0; i < numPoints; i++) {
      x[i] = cos(angle*i) * r;
      y[i] = sin(angle*i) * r;
    }
  } // constructor

  boolean update() {
    int op = ageOpacity(); // fade data
    //print("op is: "); println(op);
    if (op < 1) {
      dead = true;
    } else {
      dead = false;
      featureShifter();  // move/squigle <-- do we want these to change location to?
      //display(true, rd, gn, blu, op); //<-- use variables
    }
    middle = centerLoc();
    return dead;
  }

  int ageOpacity() {
    birthTime++;   //age by one
    // centerX--; 
    // centerY--;   //shrink a bit <--- does this work?
    shrink();
    //shrinkExpand();

    if (birthTime < 50) {
      opacity--;
    } else if ((birthTime >= 50) && (birthTime < 70)) {  // 30, 60
      float rand8 = random(0, 1);
      if (rand8 >= .5)opacity-=2;
    } else if (birthTime >= 70 && birthTime < 130 ) {  //<--- 60 - 80
      float rand8 = random(0, 1);
      if (rand8 > .75) opacity+=2;
    }
    /* } else if (yrsOld > 60 ) {
     opacity = opacity - 0.025;
     }
     */
    // /*
    else if (birthTime > 130 ) {  //was 80
      float rand3 = random(0, 1);
      if ( rand3 > .6) {
        opacity = opacity + 1 ; //2
      } else {
        opacity = opacity - 2;  //-3
        // println("still here");
        // println();
      }
      // */
      /*
     else if ( yrsOld > 80) {
       opacity = opacity - .05;
       }
       */
    }
    if (opacity < 3) { 
      opacity = 0;
    }  // it's pretty much gone, but had to set a limit
    return opacity;
  }


  void expand() {  // if the mouse is close expand

   // if (r < 150) { // as long as we have a radius
      //if (rand < 0.1) {  // and once in a (fast) while:
      //r= r + 1; // expand a bit
      //}
   // }

    // update locations:
    for (int i = 0; i < numPoints; i++) {
      x[i] = cos(angle*i) * 0.05;
      y[i] = sin(angle*i) * 0.05;
    }
  }

  void shrink() {
    float rand = random(0, 1);
    if (r > 0) { // as long as we have a radius
      if (rand < 0.3) {  // and once in a while:
        r= r - random(0,.8); // shrink a bit
        // update locations:
        for (int i = 0; i < numPoints; i++) {
          x[i] = cos(angle*i) * r;
          y[i] = sin(angle*i) * r;
        }
      }
    }
  }

  void display() {
    if (line == true) {
      stroke(0, opacity);
      strokeWeight(0.25);
    }
    fill(rd, gn, blu, opacity); // opacity was manually set at 25 -> ?
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

  //void move() {
  //  if (mouseX != 0 || mouseY != 0) {
  //    centerX += (mouseX-centerX) * 0.01;
  //    centerY += (mouseY-centerY) * 0.01;
  //  }
  //}
  
  PVector centerLoc(){   // this logic is whack
    int xC = int(abs(x[3] - x[0]));
    int yC = int(abs(y[3] - y[0]));
    return new PVector(xC, yC);
    
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
    if (rand2 > .8) { // fun to play with this value w/changing stepSize<-- 
      // new points for the shapes
      for (int i = 0; i < numPoints; i++) {
        x[i] += random(-stepSize, stepSize);
        y[i] += random(-stepSize, stepSize);
      }
    }
  }// feature shifter
}
