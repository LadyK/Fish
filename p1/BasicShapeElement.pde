class BasicShapeElement {
  int numPoints;
  float r;//  = 25; //width of shape  future= relation to body re: w + h
  int stepSize; // = 1;
  //float distortionFactor = 1;
  float centerX, centerY;
  //float [] x; // = new float[numPoints];
  //float [] y; // = new float[numPoints];
  PVector [] coordinates;
  float  rd, gn, blu;
  int opacity; //= 0; // 100
  int op_start;// = 50; // orignation of opacity
  int opChanger;  ///slow down death
  float angle;
  float birthTime;
  boolean dead, line;
  PVector middle;
  float theta, incrementer, op;
  int j = 0;
  int limit;
  color paint;
  int numColors;
  color c;

  BasicShapeElement(float x_, float y_, int pts, int radius_) {
    dead = false;
    limit = 300;  //max age
    birthTime = -limit;
    numPoints = pts;
    // x = new float[numPoints];
    //y = new float[numPoints];
    coordinates = new PVector[numPoints];
    opacity = 50;
   // op_start= 50;
    stepSize = 3; // crazy at 5 very jiggly
    r = radius_ * 2;
    line = false;
    smooth();
    rd = 0;
    gn = random(128, 255);
    blu = random(0, 192);
    centerX = x_;
    centerY = y_;
    angle = radians(360/float(numPoints));
    theta = random(PI);
    incrementer = random(0.02, 0.05);
    paint = color(rd, gn, blu, opacity);
    numColors = 500;
    c = color(100, 100, 100, 20);
    //op = random(.2, .8);
    //print("numPoints is: "); println(numPoints);
    for (int i = 0; i < numPoints; i++) {
      coordinates[i] = new PVector(cos(angle*i) * r, sin(angle*i) * r);
    }
  } // constructor

  boolean update() {
    int op = ageOpacity(); // fade data
    //print("op is: "); println(op);
    if (op < 9) {
      dead = true;
      birthTime = 0;
    } else {
      dead = false;
      //featureShifter();  // move/squigle <-- do we want these to change location to?
      //display(true, rd, gn, blu, op); //<-- use variables
    }
    // middle = centerLoc();

    return dead;
  }

  int ageOpacity() {
    if (birthTime <= 0  && frameCount % 10 == 0) {
      //println("opacity increase");
      //println();
      opacity+=1; // if 4 or more, variable rolls over into mess
    } else { // if birthTime > 0
      // centerX--; 
      // centerY--;   //shrink a bit <--- does this work?
      shrink();
      //shrinkExpand();

      if (birthTime > 0 && birthTime < (limit * .25)) {
        opacity--;
      } else if ((birthTime >= limit * .25) && (birthTime < (limit * .375)) ) { 
        float rand8 = random(0, 1);
        if (rand8 >= .5)opacity-=2;
      } else if (birthTime >= (limit * .375) && birthTime < (limit * .75)) {  //<---
        float rand9 = random(0, 1);
        if (rand9 > .65) {
          opacity+=2; // bump/increase....makes fade slower

          println("GETTING BRIGHTER");
        }
      }
      /* } else if (yrsOld > 60 ) {
       opacity = opacity - 0.025;
       }
       */
      // /*
      else if (birthTime > limit ) {  
        float rand3 = random(0, 1);
        if ( rand3 > .95) {
          opacity = opacity + (limit/4) ; // jump in opacity for effect
        } else if (rand3 < .5) {
          opacity = opacity - 2;  //-3
          // println("still here");
        }
        // */
        /*
     else if ( yrsOld > 80) {
         opacity = opacity - .05;
         }
         */
      }
    } // else
    birthTime++;   //age by one
    /*
    if (opacity < 3) { 
     opacity = 0;
     }  // it's pretty much gone, but had to set a limit
     */
    return opacity;
  }

  void colorChanger() {
    //color c = (0);
    float curTime = millis()/1000.0;
    //c_rand = random(0.5, 0.6);
    // curTime = c_rand * curTime;

    //println(curTime);
    for (int i=0; i< numColors; i+=10) {
      c = color(
        sin(curTime * 0.8f + i * 0.0011f) * 0.5f + 0.5f, //R
        sin(curTime * 0.7f + i * 0.0013f) * 0.5f + 0.5f, //G
        sin(curTime * 0.3f + i * 0.0017f) * 0.5f + 0.5f, //B
        opacity);
      //theta += sin(curTime * 0.5f) * i * 0.00002;
    }
    //print("color is: ");
    //println(c);
    paint = c;
    //return c;
  }

  void expand() {  // if the mouse is close expand

    // if (r < 150) { // as long as we have a radius
    //if (rand < 0.1) {  // and once in a (fast) while:
    //r= r + 1; // expand a bit
    //}
    // }
    theta += incrementer;
    float r_local = r + r * (sin(theta) + 1);  //radius changes

    //// update locations:
    //for (int i = 0; i < numPoints; i++) {
    //  PVector coor = coordinates[i];
    //  coor.x += cos(angle*i) * r_local ;
    //  coor.y += sin(angle*i) * r_local ;
    //}
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
    colorChanger();
    if (line == true) {
      stroke(0, opacity);
      strokeWeight(0.25);
    } else {
      noStroke();
      fill(paint, opacity); // opacity was manually set at 25 -> ?

      // fill(_c);
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
    }
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
    //for (int i = 0; i < numPoints; i++) {
    //  PVector coor = coordinates[i];
    //  coor.x = cos(angle*i) * radius;
    //  coor.y = sin(angle*i) * radius;
    //}
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
