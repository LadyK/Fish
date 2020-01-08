class BasicShapeElement {
  int numPoints;
  float r;//  = 25; //width of shape  future= relation to body re: w + h
  int stepSize; // = 1;
  //float distortionFactor = 1;
  float centerX, centerY;
  //float [] x; // = new float[numPoints];
  //float [] y; // = new float[numPoints];
  PVector [] coordinates;
  int rd, gn, blu;
  int opacity; //= 0; // 100
  int op_start;// = 50; // orignation of opacity
  int opChanger;  ///slow down death
  float angle;
  float birthTime;
  boolean dead, line;
  PVector middle;

  float theta, incrementer, c_rand;



  BasicShapeElement(int x_, int y_, int pts, int radius) {
    dead = false;
    numPoints = pts;
    // x = new float[numPoints];
    //y = new float[numPoints];
    coordinates = new PVector[numPoints];
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
    theta = random(PI);
    incrementer = random(0.02, 0.05);
    c_rand = random(0.5, 0.6);  //we want the color to be slightly different than the last
    middle = new PVector(centerX, centerY);
    //print("numPoints is: "); println(numPoints);
    for (int i = 0; i < numPoints; i++) {
      coordinates[i] = new PVector(cos(angle*i) * r, sin(angle*i) * r);
    }
  } // constructor

  boolean update(boolean h) {
    int op = ageOpacity(h); // fade data
    //print("op is: "); println(op);
    if (op < 1) {
      dead = true;
    } else {
      dead = false;
      featureShifter();  // move/squigle <-- do we want these to change location to?
      //display(true, rd, gn, blu, op); //<-- use variables
    }
    // middle = centerLoc();

    return dead;
  }

  int ageOpacity(boolean h) {
    birthTime++;   //age by one
    // centerX--; 
    // centerY--;   //shrink a bit <--- does this work?
    if(!h) shrink();
    else if(h == true){    }
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

    theta += incrementer;
    float r_local = r + r * (sin(theta) + 1);  //radius changes


    // update locations:
    for (int i = 0; i < numPoints; i++) {
      PVector coor = coordinates[i];

      //coor.x += cos(angle*i) * r_local ;
      //coor.y += sin(angle*i) * r_local ;

      coor.x = cos(angle*i) * 0.05;
      coor.y = sin(angle*i) * 0.05;
    }
  }

  void shrink() {
    float rand = random(0, 1);
    if (r > 0) { // as long as we have a radius
      if (rand < 0.3) {  // and once in a while:
        r= r - random(0, .8); // shrink a bit
        // update locations:
        for (int i = 0; i < numPoints; i++) {
          PVector coor = coordinates[i];
          coor.x = cos(angle*i) * r;
          coor.y = sin(angle*i) * r;
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
    curveVertex(coordinates[numPoints-1].x +centerX, coordinates[numPoints-1].y+centerY);

    //only these points are drawn
    for (int i = 0; i < numPoints; i++) {
      curveVertex(coordinates[i].x+centerX, coordinates[i].y+centerY);
    }
    //
    curveVertex(coordinates[0].x +centerX, coordinates[0].y+centerY);
    //end control point

    curveVertex(coordinates[1].x+centerX, coordinates[1].y+centerY);
    endShape();
  } // display

  //void move() {
  //  if (mouseX != 0 || mouseY != 0) {
  //    centerX += (mouseX-centerX) * 0.01;
  //    centerY += (mouseY-centerY) * 0.01;
  //  }
  //}
  /*
  PVector centerLoc() {   // this logic is whack
   // int xC = int(abs(x[3] - x[0]));
   // int yC = int(abs(y[3] - y[0]));
   // return new PVector(xC, yC);
   }
   */

  void newLoc(int cX, int cY) {
    centerX = cX;
    centerY = cY;
    float angle = radians(360/float(numPoints));
    float radius = r * random(0.5, 1.0);
    for (int i = 0; i < numPoints; i++) {
      PVector coor = coordinates[i];
      coor.x = cos(angle*i) * radius;
      coor.y = sin(angle*i) * radius;
    }
  } //newLoc

  void featureShifter() {
    // location of points, shift slightly for motion:
    float rand2 = random(0, 1);
    if (rand2 > .8) { // fun to play with this value w/changing stepSize<-- 
      // new points for the shapes
      for (int i = 0; i < numPoints; i++) {
        PVector coor = coordinates[i];
        coor.x += random(-stepSize, stepSize);
        coor.y += random(-stepSize, stepSize);
      }
    }
  }// feature shifter
}
