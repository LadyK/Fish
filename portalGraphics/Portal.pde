class Portal extends BasicShapeElement {

  PVector spread;
  int origX, origY;

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
    super.display(false, rd, gn, blu, 200);
    //featureShifter();
  }

  void shift() {
    if (x[0] < 50 && y[0] < 50) {
      for (int i = 0; i < numPoints; i++) {
        x[i]++;
        y[i]++;
      };
    };
  }

  void grow() {
    if (x[0] < (origX - 10) && y[0] < (origY - 10) ) {
      for (int i = 0; i < numPoints; i++) {
      x[i] += cos(angle*i) * 0.05;  // decmal helps grow slow
      y[i] += sin(angle*i) * 0.05;
    }
      
    }; // if
  } // grow

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
