class Shape {
  //int numPoints = 5; //10
  //float r = 25; //width of shape  future= relation to body re: w + h
  //int stepSize = 1;
  ////float distortionFactor = 1;
  boolean incubate;
  long flashLimit;
  int o;
  long birth;
  int interval;
  float centerX, centerY;
  int numPoints;
  int stepSize;
  float angle;
  float theta;
  color paint;
  float r;// 
  PVector [] coordinates;
  color c;
  int numColors = 500; // <--- messing with this....
  long presence;
  long timeStill;

  Shape(int x_, int y_, int p_, int r) {
    // super(x_, y_, p_, r);  // <--- can't pass variables
    //birth = millis();  // get a birthday
    o = 50;
    stepSize = 5; 
    interval = 6000;
    birth = frameCount;
    numPoints = p_;
    coordinates = new PVector[numPoints];
    angle = radians(360/float(numPoints));
    theta = random(PI);
    centerX = x_;
    centerY = y_;
    timeStill = 200;  // how long until portal launch
    // rd = 0;
    // gn = int(random(128, 255));
    // blu = int(random(0, 192));
    for (int i = 0; i < numPoints; i++) {
      coordinates[i] = new PVector(cos(angle*i) * r, sin(angle*i) * r);
    }
  }

  void update_() {
    changeOp();
    featureShifter();
    shrink();
    display();
   // portCheck();
  }

  void display() {
    colorChanger();
    //noStroke();
    stroke(paint, 200);
    strokeWeight(3);
    // fill(paint, o); // opacity was manually set at 25 -> ?
    noFill();
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
  
  void portCheck(){
    // if one is in the same place for awhile, make a portal:
    if (presence >= timeStill){
      Portal p = new Portal(centerX, centerY, 7, radius);
      portals.add(p);
   
    }
    
  }

  Boolean tooclose(PVector l) {
   // Boolean toClose = false;
    float d = dist(centerX, centerY, l.x, l.y);
    // if the new location is close to us:
    if ( d < 200 ) {
      presence++;
      return true;
    } else {
      return false;
    }
    //greturn toClose;
  }

  /// functions internal to class for better organization:

  void featureShifter() {
    // location of points, shift slightly for motion:
    float rand2 = random(0, 1);
    if (rand2 > .5) { // fun to play with this value w/changing stepSize<-- 
      for (int i = 0; i < numPoints; i++) {
        PVector coor = coordinates[i];
        coor.x += random(-stepSize, stepSize);
        coor.y += random(-stepSize, stepSize);
      }
    }
  } //featureShifter

  void shrink() {
    float rand = random(0, 1);
    if (r > 0) { // as long as we have a radius
      if (rand < 0.3) {  // and once in a while:
        // update locations:
        // /*
        for (int i = 0; i < numPoints; i++) {
          PVector coor = coordinates[i];
          coor.x = cos(angle*i) * r;
          coor.y = sin(angle*i) * r;
        }
        //  */
      }
    }
  }

  //  vary opacity as a result of age:
  int changeOp() {
    // if ( (frameCount - birth) < interval) {
    o = o - 2;
    // println("opacity decrease");
    // } else {
    //   o = 10;
    // }
    return o;
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
        o);
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
}// end shape class
