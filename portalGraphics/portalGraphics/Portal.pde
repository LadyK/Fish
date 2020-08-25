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
  Cloud cp;
  boolean pcloudsAppear;

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
    portalClouds = new ArrayList<Cloud>(); // this holds the fields of clouds for each
    pcloudsAppear = false;

    // create a bunch of clouds and add them:
    for (int i = 0; i < 3; i++) {
      PVector spot = new PVector(xie, yie);
      Cloud tester = new Cloud(spot, 100, 15, 5, 10, true);  //proximity, rad, howM_, o, portal?
      portalClouds.add(0, tester);
    }
  }

  void runClouds() {

    if (portalClouds.size() >= 1) {

      for (int i = portalClouds.size()-1; i >= 0; i--) {
        cp = portalClouds.get(i); // pull out a cloud
        
        // because of how clouds work (appear), need to add additional SHAPES to the cloud after initial:
        if (cp.siblings == cp.howMany) { // if we've reached our siblings max, skip
          continue;
        } else { // otherwise, create a new sibling:
          addSiblings(cp);
        }

        print("shapes array for this portalCloud:  ");
        println(cp.shapes.size());

        // if we no longer have shapes in this cloud, get rid of the cloud from the array:
        // vv: with <=1, no clouds. with 0, never disappears
        if (cp.deadShapes == true) { 
          portalClouds.remove(cp);
          println("removed cloud");
        } else {
          
            // run the individual cloud: mind the shapes, remove if necessary, display
            cp.run();
          
        }
      } //for loop
    } // if we have clouds

    // if(
  } // run

  void display(boolean p, long s) {
    //runClouds();
    super.display(p);

    if (frameCount % 2 == 0 && s < 36000) {  // if a bit more than 30000, like 36, then get flashes of full ones at the end
      PVector spot = new PVector(xie, yie);
      // these add the sparkle (10), but not crazy full ones before disappearing
      Cloud tester = new Cloud(spot, 100, 15, 20, 10, true);  //proximity, rad, howM_, o, portal?
      portalClouds.add(0, tester);

      // also need to add siblings
    }
  }

  void addSiblings(Cloud cp_) {
    cp_.randX = int(random(-cp_.randoX, cp.randoX)) + int(cp_.loc.x);
    cp_.randY = int(random(-cp_.randoY * 4, (cp_.randoY * .2))) + int(cp_.loc.y); // increase this along the y-axis via for-loop ?
    BasicShapeElement temp = new BasicShapeElement(cp_.randX, cp_.randY, 7, cp_.radius, cp_.howMany, cp_.alpha, cp_.rando); 
    cp_.shapes.add(0, temp);
    cp_.siblings++;
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
