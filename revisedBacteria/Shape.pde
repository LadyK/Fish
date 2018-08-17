class Shape {
  int numPoints = 10;
  float r = 25; //width of shape
  int stepSize = 1;
  //float distortionFactor = 1;
  float centerX, centerY;
  float [] x = new float[numPoints];
  float [] y = new float[numPoints];
  int rd, gn, blu;
  //float centerX = width/2;
  //float centerY = height/2;
  float opacity = 100; // 100
  float op_start; // orignnation of opacity
  float opChanger;  ///slow down death


  float yrsOld;

  Shape(int x_, int y_) {

    smooth();
    centerX = x_;
    centerY = y_;
    float angle = radians(360/float(numPoints));
    for (int i = 0; i < numPoints; i++) {
      x[i] = cos(angle*i) * r;
      y[i] = sin(angle*i) * r;
    }
    //birth = millis();  // get a birthday
    op_start = opacity;
    yrsOld = 0;
  }

  void display(float op_) {
    opacity = op_;
    stroke(0, opacity);
    // println(opacity);
    featureShifter();

    strokeWeight(0.75);
    fill(rd, gn, blu, 25);
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
    
    if (yrsOld >=  30 && yrsOld < 80) {
      float randy = random(0, 1);
      if (randy > 0.7) {
        // age more 
        yrsOld = yrsOld + 1.05;
      } else {  // 30% of the time, 
       // yrsOld += 0.025;
       yrsOld = yrsOld-1;
        println("slow down aging");
      }
    }
    if (yrsOld >= 80) {
      float randy = random(0, 1);
      if (randy > 0.3) {
        // don't age
        //yrsOld = yrsOld + .05;
      } else {  // 30% of the time, slow down how fast we age
        yrsOld += 0.025;
        println("slow down aging");
      }
    } else {
      yrsOld++;
    }
    print("we are: "); 
    println(yrsOld);
    age();
    ///*


    //*/
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


  /// functions internal to class for better organization:

  void featureShifter() {
    // location of points, shift slightly for motion:
    float rand2 = random(0, 1);
    if (rand2 > .8) {
      // new points for the shapes
      for (int i = 0; i < numPoints; i++) {
        x[i] += random(-stepSize, stepSize);
        y[i] += random(-stepSize, stepSize);
      }
    }

    // shift the color
    float rand3 = random(0, 1);
    // likelihood to shift color
    if (rand3 > 0.9) {
      rd = 0;
      gn = int(random(128, 255));
      blu = int(random(0, 192));
    }
  } //featureShifter

  //update: kill off some shapes, vs lower opacity. Seems to be too many
  // shapes to see it fade out properly, even though duration is nice

  // age the shape and vary opacity as a result:
  float age() {
    /*
    if(opacity < (op_start * 0.25)){
     //opChanger *= 0.25; //bottoms out somewhere and sticks
     opChanger = .025;
     //println("last words");
     }
     else if (opacity < (op_start * 0.5)) {
     // opChanger = opChanger + .025;
     opChanger = .25;
     //opacity = opacity - .5;
     // println("dying out");
     }  else if ((opacity < (op_start * .75) ) ) { // if opacity is half way gone...
     //AARP = true;
     // opChanger = opChanger + .25; // shrink the amount we are changing the opacity by to slow down
     opChanger = .5;
     //opacity = opacity - .75;
     // println(opacity);
     // println("starting to fade");
     } else {
     //opChanger = .5;
     //opacity = opacity - 1; // fast
     opChanger = 1;
     //println("regular aging");
     }
     
     
     // if(millis() - birth > elderly){
     //  opChanger *= 0.25;
     //  } 
     opacity = opacity - abs(opChanger);
     */
    if (yrsOld <= 20) {
      opacity--;
      // opacity = opacity - 2;
    } else if ((yrsOld > 30) && (yrsOld <= 45)) {
      opacity = opacity - 0.5;
      //opacity--;
    } else if (yrsOld > 45 && yrsOld <= 60 ) {
      opacity = opacity - 0.05;
    } else if (yrsOld > 60 && yrsOld <= 80 ) {
      //opacity = opacity ;
    } else if ( yrsOld > 80) {
      opacity = opacity - .05;
    }
    if (opacity < 0) opacity = 0;
    println(opacity);
    return opacity;
  } // age
} // end shape class
