class BasicShapeElement {
  int numPoints;
  float r;//  = 25; //width of shape  future= relation to body re: w + h
  int stepSize; // = 1;
  //float distortionFactor = 1;
  float centerX, centerY;
  //float [] x; // = new float[numPoints];
  //float [] y; // = new float[numPoints];
  PVector [] coordinates;

  int opacity; //= 0; // 100
  int op_start;// = 50; // orignation of opacity
  int opChanger;  ///slow down death
  float angle;
  //  long age;
  boolean dead, line;
  PVector middle;
  float theta, incrementer;
  int j = 0;
  long mature;
  //  long born;
  long increment;
  //color paint;
  int numColors;
  color c, paint_;
  byte mode;
  float hu;

  int op_limit;
  int howM, op;

  float  rd, gn, blu;
  float age;
  char controlO;


  BasicShapeElement(float x_, float y_, int pts, int radius_, int howMany, int o, int prox) {
    dead = false;
    mode = 0;
    //born = frameCount;
    mature = frameCount + 600;
    numPoints = pts;
    // x = new float[numPoints];
    //y = new float[numPoints];
    coordinates = new PVector[numPoints];
    opacity = o; // was 10  // 100 for testing *** <<
    op_start = opacity;
    // probability for opacity starts
    //float randO = random(0); 
    //if(randO > .7){ opacity = int(random(25, 35));}
    //else if(randO > .5 ) {opacity = int(random(15, 25));}
    //else if (randO >= 0) {opacity = int(random(10, 15));}//op_start= 0;  // was 0   // 60 for testing ****
    stepSize = 3; // crazy at 5 very jiggly
    //r = radius;
    r = radius_;
    line = false;
    smooth();
    //   rd = 0;
    //   gn = int(random(128, 255));
    //   blu = int(random(0, 192));
    rd = 100;
    gn = 200;
    blu = 170;
    centerX = x_;
    centerY = y_;
    angle = radians(360/float(numPoints));
    theta = random(PI);
    incrementer = random(0.02, 0.05);
    paint_ = color(rd, gn, blu, opacity);
    //age = 0;

    //numColors = 500; // <--- messing with this....
    //c = color(100, 100, 100, 20);
    //    op_limit = ceil(howMany * 3) + 5 ; // <-- hmmm  multiplied by how many stages we have
    howM = howMany;
    //op = random(.2, .8);
    //print("numPoints is: "); println(numPoints);

    controlOpacity(radius_, howMany, o, prox);

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
    op = ageOpacity(); // fade data
    //    print("op is: "); 
    //    println(op);
    if (op <= 0) {
      dead = true;
      //age = 0;
    } else {
      dead = false;
      if (frameCount % 5 == 0) {
        featureShifter();
      }

      //display(true, rd, gn, blu, op); //<-- use variables
    }
    // middle = centerLoc();
    // }

    return dead;
  }

  int ageOpacity() {

    age();
    if (age <= 30) {
      //if (frameCount % 2 == 0) {
      opacity +=1;  // increase, not decrease
      //}
    } else if ( (age > 30) && (age <= 45)) {
      opacity -=1; //0.5; // not going to work. on a scale of 255
    } else if ( age > 45 && age <=60) {
      float randy = random(1);
      if (randy <= .3) {
        opacity +=2;
      } else {
        opacity -=1;
      }
    } else if ( age > 60 && age <= 80) {
      float randy = random(1);
      if (randy <= .05) {
        opacity +=3;
      } else {
        //opacity -=1;
      }
    } else if (age > 80) {
      if (frameCount % 5 == 0) {
        opacity -=1;
      }
    }

    if (opacity < 0) opacity = 0;
    print("opacity  ");
    println(opacity);

    /*    
     //    print("mode is: ");
     //    println(mode);
     if (mode == 0) { // coming to maturity
     if (frameCount % 5 == 0) {
     float r_ = random(1);
     if (r_ < .9) {
     opacity +=1;
     opacity = constrain(opacity, 4, op_limit);
     if (opacity == op_limit) {
     mode = 1;
     increment = int(random(1000, 1800));
     mature = millis(); // reset
     op_limit = op_limit - howM;  // take off a section from the limit, to lower the max; thus not as bright
     } // if opp limit
     } //random
     } // %
     } // mode 0
     
     if (mode == 1) { // decreasing
     if (frameCount % 5 == 0) {
     // initial decrease:
     if (millis() - mature < increment) {
     float r_ = random(1);
     if (r_ > .7) {
     opacity +=2;
     } else {
     opacity--;
     }
     opacity = constrain(opacity, 4, op_limit);
     } // initial decrease
     else {
     mode = 2;
     increment = int(random(1800, 3000));
     mature = millis();
     op_limit = op_limit - howM;
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
     opacity = constrain(opacity, 4, op_limit);
     } // nxt increment
     else {
     mode = 3;
     mature = millis();
     increment = int(random(1800, 3000));
     op_limit = op_limit - howM;
     }
     } //if frameCount
     } //mode 2
     
     if (mode == 3) {
     
     if (frameCount % 5 == 0) {
     if (millis() - mature < increment) {
     float r_ = random(1);
     if (r_ > .7) {
     opacity +=6;
     } else {
     opacity -=2;
     }
     opacity = constrain(opacity, 4, op_limit);
     } // nxt increment
     else {
     mode = 4;
     mature = millis();
     increment = int(random(1800, 3000));
     op_limit = op_limit - howM;
     } //else
     } //framecount
     }// mode 3
     
     if (mode == 4) {
     if (frameCount % 5 == 0) {
     if (millis() - mature < increment) {
     float r_ = random(1);
     if (r_ > .5) {
     opacity--;
     } else {
     opacity +=4;
     }
     //           opacity = constrain(opacity, 4, op_limit);
     } //increment
     else {
     opacity--;
     }
     } //framecount
     } //mode 4
     */

    if (controlO == 1) {
      opacity = constrain(opacity, 0, 20);
    } else if (controlO == 2) {
      opacity = constrain(opacity, 0, 40);
    } else if (controlO == 3) {
      opacity = constrain(opacity, 0, 60);
    } else if( controlO == 4){
     //opacity = constrain(opacity, 0 
    } else if (controlO == 5){
     opacity = constrain(opacity, 0, 80); 
    }
    println(controlO);

    return opacity;
  }

  void age() {
    if (age >= 30 && age < 80) {
      float randy = random(0, 1);
      if (randy > 0.7) {
        age += 2;  // speed up age
      } else {
        age -= 1; // slow down aging/reverse
      }
    } else if (age >= 80) {
      float randy = random(0, 1);
      if (randy > 0.3) {
        // do nothing
      } else {
        age +=1;  //age slowly
      }
    } else {
      float randy = random(1);
      if (randy < 0.7) {
        age++;   //70% of time- age
      }
    }
    // print("age is: "); 
    // println(age);
  }


  color colorChanger() {



    //  /*  
    //fill(hu%255, 255, 255, 10);
    //hu += .1;
    float curTime = millis()/1000.0;
    // c_rand = random(0.5, 0.6);
    // curTime = c_rand * curTime;

    //println(curTime);
    //if (frameCount % 10 == 0) {
    for (int i=0; i< numColors; i++) {

      rd = sin(curTime * 0.8f + i * 0.0011f) + 0.5f; //R  + 0.8f
      gn = sin(curTime * 0.7f + i * 0.0013f) + 0.5f; //G * 0.5f + 0.5f   + 0.5f
      blu = sin(curTime * 0.3f + i * 0.0017f) + 0.5f; 
      rd = abs(rd);
      gn = abs(gn);
      blu = abs(blu);
      kuler = color(rd, gn, blu);
    }

    paint = kuler;
    //paint_ = c;
    return paint;
  }

  //100, 30, 30, 10);  // loc,     prox, radius, #, o
  void controlOpacity(int r_, int howM_, int o_, int prox_) { // add more as needed
    
    if ( r_ >= 30 && howM_ >= 10 && prox_ <= 30) {
      controlO = 1; // opacity is lowest
    } else if (prox_ >= 30 && r_ <= 30 && howM_ >= 30) {  //30, 10, 60, 10)  prox, radius, #, o
      controlO = 5; // 
    } else if ( prox_ < 30 && howM <= 10 && r_ <= 30) {
      controlO = 5;
    } else if (prox_ >= 30 && r_ > 50 && howM_ < 20){
     controlO = 3; 
    }
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

    //  color c_ = colorChanger(); // change opacity + color mode; this calls within class; individual colors for cloud
    //    print("op is: ");
    //    println(op);

    //print("red is ");
    //println(red(paint));
    //       print("op is: "); 
    //       println(op);

    if (line == true) {
      stroke(0, op);
      strokeWeight(0.25);
    } else {
      noStroke();
      //       fill(c_, op); // need to change color mode and initial opacity need to pass opacity again here
      fill(paint, op);
      // fill(_c); // 

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

  //void newLoc(int cX, int cY) {
  //  centerX = cX;
  //  centerY = cY;
  //  float angle = radians(360/float(numPoints));
  //  float radius = r * random(0.5, 1.0);
  //  /*
  //  for (int i = 0; i < numPoints; i++) {
  //   PVector coor = coordinates[i];
  //   coor.x = cos(angle*i) * radius;
  //   coor.y = sin(angle*i) * radius;
  //   }
  //   */
  //} //newLoc

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

    //// shift the color
    //float rand3 = random(0, 1);
    //// likelihood to shift color
    //if (rand3 > 0.9) {
    //  rd = 0;
    //  gn = int(random(128, 255));
    //  blu = int(random(0, 192));

    //  paint = color(rd, gn, blu);
    //}
  } // feature Shifter
}
