class Shape extends BasicShapeElement {
  int numPoints = 5; //10
  //float r = 25; //width of shape  future= relation to body re: w + h
  //int stepSize = 1;
  ////float distortionFactor = 1;

  float yrsOld;
  int opacity;

  Shape(int x_, int y_, int p_, int r) {
    super(x_, y_, p_, r);  // <--- can't pass variables
    //birth = millis();  // get a birthday
    opacity = 50;
    yrsOld = 0;
    rd = 0;
    gn = int(random(128, 255));
    blu = int(random(0, 192));
  }

  void display() {
    //super.display(true, rd, gn, blu, opacity); //50
    super.display();
    //opacity = op_;


    // move points and color:
    featureShifter();

    // depending on how old we are, mess with how quickly/slowly we age:
    if (yrsOld >=  10 && yrsOld < 40) {   //10 + 40
      float randy = random(0, 1);
      if (randy < 0.2) {   // 20% of the time,   .7
        // age much more 
        yrsOld = yrsOld + 2;
      } else {  // 70% of time:
        // yrsOld += 0.025;
        yrsOld = yrsOld+1;
        // println("slow down aging");
      }
    }
    if (yrsOld >= 40) {
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


  /// functions internal to class for better organization:

  void featureShifter() {
    super.featureShifter();
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
    if (yrsOld < 20) {
      opacity--;
    } else if ((yrsOld >= 20) && (yrsOld < 50)) {  // 30, 60
      float rand8 = random(0, 1);
      if(rand8 >= .5)opacity-=2;
    } else if (yrsOld >= 50 && yrsOld < 90 ) {  //<--- 60 - 80
      float rand8 = random(0, 1);
      if(rand8 > .95) opacity+=2;
    }
    /* } else if (yrsOld > 60 ) {
     opacity = opacity - 0.025;
     }
     */
    // /*
    else if (yrsOld > 90 ) {  //was 80
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
    if (opacity < 0) opacity = 0;
  } // age
} // end shape class
