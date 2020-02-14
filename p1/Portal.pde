class Portal extends BasicShapeElement {

  PVector spread;
  int origX, origY;

  // 1. opacity
  // 2. shrinking
  // 3. disappearance

  Portal(int x_, int y_, int p_, int r) {
    super(x_, y_, p_, r);
    rd = 0;
    gn = int(random(128, 255));
    blu = int(random(100, 200));
    spread = PVector.random2D();
    origX = x_;
    origY = y_;
  }

  void display() {
    //super.display(false, rd, gn, blu, 200); // last is opacity
    super.display();
    //featureShifter();
  }

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
    super.featureShifter();
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
