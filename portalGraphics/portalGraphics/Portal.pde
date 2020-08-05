class Portal extends BasicShapeElement {

  PVector spread;
  float origX, origY;
  float xie, yie;
  // 1. opacity
  // 2. shrinking
  // 3. disappearance
  //color mypaint;
  long birth;
  long life;
  ArrayList<Cloud> portalClouds;

  Portal(float x_, float y_, int p_, int r) {
    super(x_, y_, p_, r, 1, 200, 0); // location, points, radius, howMany, opacity, proximity
    xie = x_;
    yie = y_;
    rd = 0;
    gn = int(random(128, 255));
    blu = int(random(100, 200));
    paint_ = color(rd, gn, blu, 200);
    birth = millis();
   // life = 10000;

    // spread = PVector.random2D();
    //origX = x_;
    //origY = y_;
    portalClouds = new ArrayList<Cloud>();
  }

  void run(){
   if(portalClouds.size() > 0){
     for(int i = portalClouds.size()-1; i >= 0; i--){
       Cloud c = portalClouds.get(i);
       c.run();
     } 
   }
    
    
    
    
  }
  //void display() {
  //  //if (millis() - birth < life) {
  //    //fill(paint_, 200);
  //   // grow();
  //    //ellipse(xie, yie, 40, 40);
  //    //super.display(false, rd, gn, blu, 200); // last is opacity
  //    super.display(true);
  // // }
  //  //featureShifter();
  //}

  void shift() {
    /*
    if (coordinate[0].x < 50 && coordinate[0].y < 50) {  // ??
     for (int i = 0; i < numPoints; i++) {
     //x[i]++;
     //y[i]++;
     coordinate[i].x++;
     coordinate[i].y++;
     };
     };
     */
  }

  void grow() {
    //if our current X/Y.0 location is less than original, minus a smidge
    //if (x[0] < (origX - 50) && y[0] < (origY - 50) ) {
    //println("meeeee");
    for (int i = 0; i < numPoints; i++) {
      PVector coor = coordinates[i];
      coor.x += cos(angle*i) * 0.05;  // decimal helps grow slow
      coor.y += sin(angle*i) * 0.05;
    }
    // } // if
  } // grow

  /*
  boolean shrink() {
   boolean tooSmall = false;
   for (int i = 0; i < numPoints; i++) {
   x[i] -= cos(angle*i) * 0.5;  
   y[i] -= sin(angle*i) * 0.5;
   }
   
   if ((x[0] <= origX) || (y[0] <= origY)) {
   tooSmall = true;
   } else{
   tooSmall = false;
   }
   return tooSmall;
   }
   */

  void featureShifter() {
   // super.featureShifter(1);
  }

  void move() {
    //super.move();  // needs to be redefined
    if (mouseX != 0 || mouseY != 0) {
      //spread.add(random(-0.01,0.01), random(-0.01, 0.01));
      //spread.x = spread.x + mouseX;
      //spread.y = spread.y + mouseX;
      //centerX += (spread.x-centerX) * 0.001;
      //centerY += (spread.y-centerY) * 0.001;
      //  centerX += (mouseX-centerX) * -0.03;
      //  centerY += (mouseY-centerY) * -0.03;
      println(centerX);
    }
  }
}
