class Shape {
  int numPoints = 10;
  float r = 25; //width of shape  future= relation to body re: w + h
  int stepSize = 1;
  //float distortionFactor = 1;
  float centerX, centerY;
  float [] x = new float[numPoints];
  float [] y = new float[numPoints];
  int rd, gn, blu;
  //float centerX = width/2;
  //float centerY = height/2;
  float opacity = 0; // 100
  float op_start = 50; // orignation of opacity
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
    opacity = op_start ;
    yrsOld = 0;
  }

  void display() {
    //opacity = op_;
    stroke(0, opacity);

    // move points and color:
    featureShifter();

    strokeWeight(0.75);
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

    // depending on how old we are, mess with how quickly/slowly we age:
    if (yrsOld >=  10 && yrsOld < 80) {   //10 + 40
      float randy = random(0, 1);
      if (randy < 0.2) {   // 30% of the time,   .7
        // age much more 
        yrsOld = yrsOld + 2;
      } else {  // 70% of time:
        // yrsOld += 0.025;
        yrsOld = yrsOld+1;
        // println("slow down aging");
      }
    }
    if (yrsOld >= 80) {
      float randy = random(0, 1);
      if (randy > 0.3) {
        yrsOld = yrsOld + 1;
      } else {  // 30% of the time, slow down how fast we age
        yrsOld -= 1;
        //println("slow down aging");
      }
    } else {
      float randy = random(0, 1);
      if (randy > 0.3) {
        yrsOld+=3;
      } else {
        yrsOld -=2;
      }
    }
    //print("we are: "); 
    //println(yrsOld);
    changeOp();
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
    if (rand3 > 0.7) {
      rd = 0;
      gn = int(random(128, 255));
      blu = int(random(0, 192));
    }
  } //featureShifter


  //  vary opacity as a result of age:
  void changeOp() {
    if (yrsOld < 30) {
      opacity--;
    } else if ((yrsOld >= 30) && (yrsOld < 80)) {  // 30, 60
      opacity = opacity - 0.5;
    } else if (yrsOld >= 80 && yrsOld < 190 ) {  //<--- 60 - 80
      opacity = opacity - 0.05;
    }
    /* } else if (yrsOld > 60 ) {
     opacity = opacity - 0.025;
     }
     */
    // /*
    else if (yrsOld > 190 ) {  //was 80
      float rand3 = random(0, 1);
      if ( rand3 > .6) {
        opacity = opacity + 1 ; //2
      } else {
        opacity = opacity - 2;  //-3
        println("still here");
        println();
      }
      // */
      /*
     else if ( yrsOld > 80) {
       opacity = opacity - .05;
       }
       */
    }
    if (opacity < 0) opacity = 0;
  } // age
} // end shape class
