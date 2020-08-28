class Cloud {

  //ArrayList<Shape> shapeCloud; //shapes to form one cloud

  int howMany;
  //int numPts;
  //int rad;
  PVector loc;
  long birth;
  ArrayList<BasicShapeElement>shapes; //how many shapes in cloud? How big/wide cloud?
  int rando, randoX, randoY, randY, randX;
  //int rando;
  int radius; //= 30; // radius of shapes *********
  long stillThere;
  int siblings;
  int alpha;
  boolean portalTrigger;
  boolean deadShapes = false;



  // how many, radius + rando are difference btwn spots, portals, gas

  Cloud(PVector newbie, int proximity, int rad, int howM_, int o, boolean p) {
    //shapeCloud = new ArrayList<Shape>();
    //loc = newbie.copy();
    loc = new PVector(newbie.x, newbie.y);
    howMany = howM_; //10;  // the more the foggier. but need to mind cpu; was 30 ********
    shapes = new ArrayList<BasicShapeElement>(); // not predetermining length
    //numPts = 5; //10
    radius = rad;
    rando = proximity;//30; // was 100  ********
    alpha = o;
    randoX = int(proximity * .2); // not so much on the x axis
    randoY = int(proximity * 1); //rando; // more spread on the y axis

    birth = millis();
    if ( p == true) {
      randX = int(random(-20, 30)) + int(newbie.x);
      randY = int(random(-30, 40)) + int(newbie.x);
    } else {
      randX = int(newbie.x); //int(random(-randoX, randoX)) + int(newbie.x);
      randY = int(newbie.y); //int(random(-randoY * 4, randoY * .2)) + int(newbie.y); // increase along y-axis
    }
    BasicShapeElement temp = new BasicShapeElement(randX, randY, 7, radius, howMany, o, rando);
    shapes.add(0, temp);

    siblings++;
    portalTrigger = false;

    //// creating #limit shapes and push to cloud array:
    //for (int i = 0; i < howMany; i++) {

    //  // pick some points around the mouse for the shape
    //  randX = int(random(-randoX, randoX)) + int(newbie.x);
    //  randY = int(random(-randoY * 4, (randoY * .2))) + int(newbie.y); // increase this along the y-axis via for-loop ?

    //  BasicShapeElement temp = new BasicShapeElement(randX, randY, 7, radius, howMany, o, rando); 
    //  shapes.add(0, temp);
    //}
    //println("done");
  } 

  void run() {
    for (int i = shapes.size()-1; i >= 0; i--) {
      //for (BasicShapeElement temp : shapes) { 
      BasicShapeElement temp = shapes.get(i);
      //temp.featureShifter(); // might save processor to not call so often
      //int rand_c = int(random(1, 300));
      //color c_ = colorChanger();
      //shape.shrink();
      boolean dead = temp.update();
      // if the shape is dead/dim:
      if (dead) {  
       // println("removed a basic shape");
        shapes.remove(temp);
      } else { 
        // if (frameCount % 5 == 0) {
        //temp.featureShifter();
        // }
        //temp.centerY= temp.centerY - 1;
        //constrain(temp.centerY,temp.centerY, temp.centerY-10);
        temp.display(false);
      }
    } // for
    //if(shapes.size() <= 1){
    //  deadShapes = true;
    //  println("dead shapes array");
    //}
  } // run

  Boolean tooclose(PVector l) {
    //Boolean toClose = false;
    float d = dist(loc.x, loc.y, l.x, l.y);
    if ( d < radius * .5) {
      //stillThere = millis();   // this was start of portal development
      return true;
    } else {
      return false;
    }
    //return toClose;
  }


  //kills off a shape, not a cloud; part of a cloud
  void plague() {
    float whichOne = floor(random(0, shapes.size()-1));
    shapes.remove(whichOne);
    //shapeCloud = shorten(shapeCloud);  //<-- stuck
    println("lost one");
  }
} // end class
