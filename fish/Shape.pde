
/* This makes one unit or shape out of multiple rings
 * 
 *
 */

class Shape {

  //Ring[] the_shape;
  ArrayList<Ring> the_shape;
  int ticker;
  boolean dead;

  Shape(int x_, int y_, int num_r) {
    dead = false;
    ticker = 0;
    //the_shape = new Ring[30];
    the_shape = new ArrayList<Ring>();

    for (int i = 0; i < num_r; i++) {  // loop through the array
      //the_shape[i] = new Ring(x_, y_);      // make a new object at each indice

      the_shape.add(new Ring(x_, y_));
    }
  }


  /*
  for (int i = 0; i < the_shapes.length-1; i++) {  // loop through the arrray
   the_shapes[i] = the_shapes[i+1];    // fill the first spot, with the one to the right
   }
   //portal.display();
   //portal.move();
   
   //add a new one on the end of the array with new location
   Shape newbie = new Shape();  // make a new shape objecct
   newbie.centerX = mouseX;    // assign mouseX to shape's centerX parameter
   newbie.centerY = mouseY;
   the_shapes[the_shapes.length-1] = newbie; // put that new shape in the last spot
   */

  void run() {
    //for (int i = 0; i < the_shape.size()-1; i++) {
    for (int i = the_shape.size()-1; i >= 0; i--) {
   // for (Ring temp : the_shape) {
      Ring temp = the_shape.get(i);
      //the_shape[i].move();
      //temp.newLoc(mouseX, mouseY);
      temp.move();
      temp.display();
      //the_shape[i].display();
      
    }
  }

  void check() {

    for (int i = the_shape.size()-1; i >= 0; i--) {
      Ring temp = the_shape.get(i);
      if (temp.opacity <= 0) {
        the_shape.remove(i);
        ticker++;
      }
    }
    if (ticker >= the_shape.size()) {
      dead = true;
    }
  }

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