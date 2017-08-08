
/* This makes one unit or shape out of multiple rings
 * 
 *
 */

class Shape {

  //Ring[] the_shape;
  ArrayList<Ring> the_shape;  // this could be an array. length set by num_r
  int ticker;
  boolean dead;

  Shape(int x_, int y_, int num_r) {
    dead = false;
    ticker = 0;
    //the_shape = new Ring[30];
    the_shape = new ArrayList<Ring>();

    //for (int i = 0; i < num_r; i++) {  // loop through the array
    for (int i = num_r; i >= 0; i--) {  
      //the_shape[i] = new Ring(x_, y_);      // make a new object at each indice

      the_shape.add(new Ring(x_, y_));
    }
  }
  /*
  void update() {
   for (int i = 0; i < (the_shape.size()-1); i++) {
   Ring temp = the_shape.get(i);
   //temp.shiftLocs();
   }
   }
   */

  void run() {
    for (int i = 0; i < (the_shape.size()-1); i++) {
      //for (int i = the_shape.size()-1; i >= 0; i--) {
      // for (Ring temp : the_shape) {
      Ring temp = the_shape.get(i);
      //the_shape[i].move();
      /*
      if (wait == true) {
        temp.portal(mouseX, mouseY);// <-- portals  (formerly newLoc old-style)
      }
      */
      //temp.shiftLocs();
      //temp.move(); // <-- shifts towards the mouse. ...eh.
      temp.display();
      //the_shape[i].display();
    }
  }

  // if the opacity is below zero on A RING, remove it and increase our age
  void check() {
    for (int i = the_shape.size()-1; i >= 0; i--) {
      //for (int i = 0; i <= the_shape.size()-1; i++) {
      Ring temp = the_shape.get(i);
      // if they are younger than 30
      if (temp.age <= 30) { //&&(temp.age >= 2) )
         temp.opacity--;
      }
      // if they are older than thrity and younger than
      else if ((temp.age > 30)&& (temp.age <= 60) )  {
        temp.opacity = temp.opacity - 0.5;
      } 
      
      else if (temp.age > 60 ){
        temp.opacity = temp.opacity - 0.25;
      }
      
      // if a particular ring is faded away, remove it and age us
      if (temp.opacity <= 0.0) {
        the_shape.remove(i);
        ticker++;   //we've aged
      }

      // if we are older than we have rings, we are dead
      if (ticker >= the_shape.size()) {
        dead = true;
      }
    }
  }

  // current the below function is not in service
  void interaction() {
    if (mouseX != 0 || mouseY != 0) {  // if the mouse isn't pressed

      for (int i = 0; i < the_shape.size()-1; i++) { // loop through the shapes
        float rand = random(0, 1); // pick a new random value
        Ring temp = the_shape.get(i); 
        //Ring temp = the_shape[i];  // pull a shape of the array to work with
        // How response to the mouse? this slows the movement
        if (rand < .65) {  
          temp.centerX += (mouseX - temp.centerX) * 0.001;  // assign that shape a new centerX parameter
          temp.centerY += (mouseY - temp.centerY) * 0.001;
        }
        if ( rand >= .65) {
          temp.centerX += (mouseX - temp.centerX) * 0.01; // assign that shape a new centerX
          temp.centerY += (mouseY - temp.centerY) * 0.01;
        }
      } // for-loop of shapes
    } // if the mouse isn't clicked
  }
} //class