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
  long age;
  boolean dead, line;
  PVector middle;
  float theta, incrementer, op;
  int j = 0;
  long mature;
  long born;
  long increment;
  color paint;
  int numColors;
  color c;
  byte mode;




  BasicShapeElement(float x_, float y_, int pts, int radius_) {
    dead = false;
    mode = 0;
    born = frameCount;
    mature = frameCount + 600;
    numPoints = pts;
    // x = new float[numPoints];
    //y = new float[numPoints];
    coordinates = new PVector[numPoints];
    opacity = 10; // was 10  // 100 for testing ***
    op_start = opacity;
    // probability for opacity starts
    //float randO = random(0); 
    //if(randO > .7){ opacity = int(random(25, 35));}
    //else if(randO > .5 ) {opacity = int(random(15, 25));}
    //else if (randO >= 0) {opacity = int(random(10, 15));}//op_start= 0;  // was 0   // 60 for testing ****
    stepSize = 3; // crazy at 5 very jiggly
    //r = radius;
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
    numColors = 500; // <--- messing with this....
    c = color(100, 100, 100, 20);

    //op = random(.2, .8);
    //print("numPoints is: "); println(numPoints);

    for (int i = 0; i < numPoints; i++) {
      coordinates[i] = new PVector(cos(angle*i) * r, sin(angle*i) * r);
    }
  } // constructor

  boolean update() {
    /*
    //incubating:
     if ((frameCount - incubate) < flashLimit) {
     incubate();
     dead = false;
     //println("incubating");
     } else {
     */
    //maturing and fading:
    int op = ageOpacity(); // fade data
    print("op is: "); 
    println(op);
    if (op <= 3) {
      dead = true;
      age = 0;
    } else {
      dead = false;
      //featureShifter();  // move/squigle <-- do we want these to change location to?
      //display(true, rd, gn, blu, op); //<-- use variables
    }
    // middle = centerLoc();
    // }

    return dead;
  }

  int ageOpacity() {
    print("mode is: ");
    println(mode);
    println();
    println();
    if (mode == 0) { // coming to maturity
      if (frameCount % 5 == 0) {
        opacity +=1;
        opacity = constrain(opacity, 4, 60);
        if (opacity == 60) {
          mode = 1;
          increment = int(random(10, 60));
           mature = millis();
        }
      } // %5
    } // mode 0

    if (mode == 1) { // decreasing
      if (frameCount % 5 == 0) {
        // initial decrease:
        if (millis() - mature < increment) {
          float r_ = random(1);
          if (r_ > .9) {
            opacity +=2;
          } else {
            opacity--;
          }
          opacity = constrain(opacity, 4, 60);
        } // initial decrease
        else {
          mode = 2;
          increment = int(random(10, 30));
           mature = millis();
        }
      } // frameCount
    } // mode 1

    if (mode == 2) {
      if (frameCount % 5 == 0) {
        if (millis() - mature < increment) {
          float r_ = random(1);
          if (r_ > .8) {
            opacity +=4;
          } else {
            opacity -=2;
          }
          opacity = constrain(opacity, 3, 60);
        } // nxt increment
        else mode = 3;
        mature = millis();
        increment = int(random(10, 30));
      } //if frameCount
    } //mode 2

    if (mode == 3) {
      println("mode3");
      println();
      println();
      if (frameCount % 5 == 0) {
        if (millis() - mature < increment) {
          float r_ = random(1);
          if (r_ > .7) {
            opacity +=4;
          } else {
            opacity -=2;
          }
          opacity = constrain(opacity, 3, 60);
        } // nxt increment
      } //framecount
    }// mode 3







    //********** before reDesign of fade + gas:
    ///*
    //need to refine this: a noticeable amount but not a flash, nor flashing
    // a noticible amount initially-stronger, then looser fog... spread?
    // if (birthTime <= (-limit + 10)){
    // trigger(); 

    // }
    // // for a time: increase the opacity:
    // // higher modulo: more fog-like;
    // // lower modulo: increased opacity + circle visual/hardness
    // else */
    //if (age <= 0 && frameCount % 10 == 0) { //gradually increase opacity
    //  //println("opacity increase");
    //  // println();
    //  opacity+=1; // if 4 or more, variable rolls over into mess; 1 = fog; 2 = circles
    //} else { // if birthTime > 0

    //  // centerX--; 
    //  // centerY--;   //shrink a bit <--- does this work?
    //  shrink();
    //  //shrinkExpand();

    //  if (age > 0) {
    //    if ( age <= (limit * .25) && frameCount % 8 == 0) {
    //      opacity--;
    //    }
    //  } else if ((age >= limit * .25) && (age < (limit * .375)) ) {  // 30, 60
    //    float rand8 = random(0, 1);
    //    if (rand8 >= .5)opacity-=2;
    //  } else if (age >= (limit * .375) && age < (limit * .75)) {  //<--- 60 - 80
    //    println("we are old");
    //    float rand9 = random(0, 1);
    //    if (rand9 > .65) {
    //      opacity+=2; // bump/increase....makes fade slower

    //      println("GETTING BRIGHTER");
    //    }
    //    println("nope");
    //  }
    //  /* } else if (yrsOld > 60 ) {
    //   opacity = opacity - 0.025;
    //   }
    //   */
    //  // /*
    //  else if (age > limit ) {  
    //    float rand3 = random(0, 1);
    //    if ( rand3 > .95) {
    //      opacity = opacity + (limit/4) ; // jump in opacity for effect
    //    } else if (rand3 < .5) {
    //      opacity = opacity - 2;  //-3
    //      // println("still here");
    //      // println();
    //    }
    //    // */
    //    /*
    // else if ( yrsOld > 80) {
    //     opacity = opacity - .05;
    //     }
    //     */
    //  }
    //} // else
    //age++;   //age by one
    ///*
    //if (opacity < 3) { 
    // opacity = 0;
    // }  // it's pretty much gone, but had to set a limit 
    // */
    //// print("birthTime is = ");
    //// println(birthTime);
    ////  print("opacity is = ");
    //// println(opacity);

    return opacity;
  }


  void colorChanger() {

    float curTime = millis()/1000.0;
    // c_rand = random(0.5, 0.6);
    // curTime = c_rand * curTime;

    //println(curTime);
    //if (frameCount % 10 == 0) {
    for (int i=0; i< numColors; i+=25) {
      c = color(
        sin(curTime * 0.8f + i * 0.0011f) + 0.8f, //R  + 0.8f
        sin(curTime * 0.7f + i * 0.0013f) + 0.5f, //G * 0.5f + 0.5f   + 0.5f
        sin(curTime * 0.3f + i * 0.0017f) + 0.5f, //B    + 0.8f
        opacity);
      /* print("color is:  ");
       print(r); 
       print(",");
       print(g); 
       print(",");
       println(b);
       println();
       c = color(r, g, b, opacity);
       */

      //);
      //theta += sin(curTime * 0.5f) * i * 0.00002;
    }


    paint = c;
    // }
    //return c;
  }


  void expand_() {  // if the mouse is close expand

    // if (r < 150) { // as long as we have a radius
    //if (rand < 0.1) {  // and once in a (fast) while:
    //r= r + 1; // expand a bit
    //}
    // }
    theta += incrementer;
    float r_local = r + r * (sin(theta) + 1);  //radius changes

    //    // update locations:
    //    for (int i = 0; i < numPoints; i++) {
    //      PVector coor = coordinates[i];
    //      coor.x += cos(angle*i) * r_local ;
    //      coor.y += sin(angle*i) * r_local ;
    //    }
  }

  void shrink() {
    float rand = random(0, 1);
    if (r > 0) { // as long as we have a radius
      if (rand < 0.3) {  // and once in a while:
        r= r - random(0, .8); // shrink a bit
        // update locations:
        //  /*
        for (int i = 0; i < numPoints; i++) {
          PVector coor = coordinates[i];
          coor.x = cos(angle*i) * r;
          coor.y = sin(angle*i) * r;
        }
        //  */
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

      // /*
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
      // */
      // ellipse(centerX, centerY, r, r);
    }
  }// display

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
    /*
    for (int i = 0; i < numPoints; i++) {
     PVector coor = coordinates[i];
     coor.x = cos(angle*i) * radius;
     coor.y = sin(angle*i) * radius;
     }
     */
  } //newLoc

  void featureShifter() {

    // location of points, shift slightly for motion:
    float rand2 = random(0, 1);
    if (rand2 > .8) { // fun to play with this value w/changing stepSize<-- 
      // r += random(-stepSize, stepSize);
      // new points for the shapes
      // /*
      for (int i = 0; i < numPoints; i++) {
        PVector coor = coordinates[i];
        coor.x += random(-stepSize, stepSize);
        coor.y += random(-stepSize, stepSize);
      }
      // */
    }
  }// feature shifter
}
