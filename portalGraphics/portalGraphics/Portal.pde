class Portal extends BasicShapeElement { //<>// //<>// //<>// //<>//

  PVector spread;
  float origX, origY;
  float xie, yie, o_x, o_y;
  // 1. opacity
  // 2. shrinking
  // 3. disappearance
  //color mypaint;
  long birth;
  long mature;
  long life;
  ArrayList<Cloud> portalClouds;
  Cloud cp;
  boolean pcloudsAppear;
  boolean text;
  PFont f;
  int rad;
  int p_width;
  float scale ;
  PVector change;
  PVector loc, acceleration, velocity, loc_original, locdup;
  String[] inputText;
  int currentLineNum, howManyLines, linesPerScreen, cln, yScreen, screenLine, numScreens;
  ArrayList<Screen> textBuffers;
  color t;
  //int topacity;
  int fontSize;
  int cloudLimit, cloudNum;
  boolean textop, full; //text opacity
  boolean shrinkMSG;


  Portal(float x_, float y_, int p_, int r) {
    super(x_, y_, p_, r, 2, 200, 20); // location, points, radius, howMany 15?, opacity, proximity
    loc = new PVector(x_, y_);
    locdup =  new PVector(x_, y_);;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    loc_original= new PVector(x_, y_); // need to see how much location changes
    cloudLimit = 300;
    shrinkMSG = false;

    rd = 0;
    gn = int(random(128, 255));
    blu = int(random(100, 200));
    paint_ = color(rd, gn, blu, 200);
    birth = millis();
    // life = 10000;
    mature = 18000;
    rad = r;
    p_width = rad * 2;
    change = new PVector(0, 0);

    // spread = PVector.random2D();
    //origX = x_;
    //origY = y_;
    portalClouds = new ArrayList<Cloud>(); // this holds the fields of clouds for each
    pcloudsAppear = true;

    //packet text setup:
    fontSize = 24;
    f = createFont("Courier", fontSize);
    
    
    
    inputText = loadStrings("packets.txt");
    howManyLines = inputText.length;
    //print("number of lines: ");
    //println(howManyLines);
    linesPerScreen = 19; //*** this
    numScreens = ceil(howManyLines/(linesPerScreen + 1)); // *** this
   //print("number of screens: "); 
    //println(numScreens);
    textBuffers = new ArrayList<Screen>();
    currentLineNum = 0;
    //linesPerScreen = 9;
    // yScreen = 420; // ***needs modification
    //PVector offscreen = new PVector(20, yScreen); //** location of portal
    //PVector offScreen = loc.copy();
    locdup.y -= 130;  // want it to start a bit more north than south
    int nextStart = 0;
    for (int i = 0; i <numScreens; i++) {
      Screen s = new Screen(locdup, nextStart); //** this is going to need the portal location + some y to it
      nextStart = s.initalize(linesPerScreen, inputText);
      locdup.y = locdup.y + ( linesPerScreen + 20 ); // each LINE plus some space; was * 28; need to tweak if scale changes  //* (fontSize *.5)
      textBuffers.add(s);
    }
    //topacity = 100;
    //t = color(75, 255, 85, 100);

    textFont(f, fontSize);
    textop = true;

    //fill(t);
    //fill(t, 100); // was topacity

    // end of text setup

    /*
    xie = random(x_ - 5, x_ + 5); //*** may need to tweak this
     yie = random(y_ - 30, y_ + 5);
     
     // create a bunch of clouds and add them:
     for (int i = 0; i <= 15; i++) {  // lowered this
     PVector spot = new PVector(xie, yie);
     Cloud tester = new Cloud(spot, 100, 15, 8, 10, true);  //proximity, rad,  more here **howM_, o, portal?
     portalClouds.add(0, tester);
     }
     
     */
    screenLine = 0;
  }

  void runClouds() {

    if (portalClouds.size() >= 1) {
      //print("we have ");
      //print(portalClouds.size()-1);
      //println("  clouds");

      for (int i = portalClouds.size()-1; i >= 0; i--) {
        cp = portalClouds.get(i); // pull out a cloud

        // code below, in conjunction with 77-80, creates lovely sparkle/glitter effect
        // yet, at the same time, cannot remove cloud from portalclouds as a result of this being here:
        // BECAUSE we are adding to each cloud as we run each cloud AND the "continue"
        // because of how clouds work (appear), need to add additional SHAPES to the cloud after initial:
        if (cp.siblings == cp.howMany) { // if we've reached our siblings max, skip
          continue; // this skips everything until the next iteration
        } else { // otherwise, create a new sibling:
          addSiblings(cp);
        }
        //  // run the individual cloud: mind the shapes, remove if necessary, display
        cp.run();
      } //for loop
    } // if we have clouds
  } // run

  void display(boolean p, long s) {
    //runClouds();
    super.display(p);
    if (s > 3000 && s < 40000) {

      // apply change to location
      // limit location so not beyond boundaries

      PVector move = new PVector(-0.10, -0.10);  //slowly move
      if (frameCount % 25 == 0) { //update not so often so as to move more slowly
        if ((loc.x > loc_original.x - 25) && (loc.y > loc_original.y - 25)) {
          applyForce(move);
          updateVectors();
        }
      }

      showText(); // then change second parameter to less
    }

    // took this out to speed things up vvvvvv  (howM_ was 15, took it to 3)
    PVector spot = new PVector();
    int cloudOp;
    //print("loc.y is: "); println(loc_original); 
    if ( cloudNum < cloudLimit || s > 3000 && s < 34000) {  // if a bit more than 30000, like 36, then get flashes of full ones at the end
      float randX = random(-30, 30) + loc_original.x;
      float randY = random(-55, -15) + loc_original.y;
     // print("randy is: "); println(randY);
     // print("loc origin y is: "); println(loc_original.y);
      //println("creating a spot");
      spot = new PVector(randX, randY);
       // tinkering with slightly different opacities as gets older. seemed to slow down, text lingered and shapes lingered
      //if (s < 28000) {
      //  //float opRand = random(30, 60);
      //  //cloudOp = int(opRand);
      //  cloudOp = 40;
      //} else {
      //  cloudOp = 20;
      //}
      Cloud tester = new Cloud(spot, 100, 15, 20, 30, true);  //proximity, rad,was 4 howM_ 20, o 10, portal?
      portalClouds.add(0, tester);
      cloudNum++;
      //println("still adding clouds");
    } else {
      //println("we've reached out limit");
      //print("s is: "); 
      //println(s);
    }
  }

  void applyForce(PVector f) {
    acceleration.add(f);
  }


  void updateVectors() {
    velocity.add(acceleration);
    loc.add(velocity);
    acceleration.mult(0);
  }

  Boolean tooclose(PVector l) {
    //Boolean toClose = false;
    float d = dist(loc.x, loc.y, l.x, l.y);
    if ( d < (rad * 10) ) {
      //stillThere = millis();   // this was start of portal development
      return true;
    } else {
      return false;
    }
    //return toClose;
  }

  void addSiblings(Cloud cp_) {  // 4 was tweaked to 8
    cp_.randX = int(random(-cp_.randoX, cp.randoX)) + int(cp_.loc.x);
    cp_.randY = int(random(-cp_.randoY * 8, (cp_.randoY * .2))) + int(cp_.loc.y); // increase this along the y-axis via for-loop ?
    BasicShapeElement temp = new BasicShapeElement(cp_.randX, cp_.randY, 7, cp_.radius, cp_.howMany, cp_.alpha, cp_.rando); 
    // (float x_, float y_, int pts, int radius_, int howMany, int o, int prox) 
    cp_.shapes.add(0, temp);
    cp_.siblings++;
    // println("adding");
  }

  void showText() {  // flip on or fade up once portal expands enough
    //fill(75, 255, 85, 255);
    //fill(0, 255, 0, 100); // <-- topacity here
    if(textop == false) full = false;
    else if (textop == true) full = true;
    for (Screen sc : textBuffers) {

      sc.run(full);
      //print("Screen number: "); 
      //println(sc);
    }
    for ( int i = textBuffers.size()-1; i >= 0; i--) {
      Screen sn = textBuffers.get(i);
    
      if ((sn.screen_location.y + (linesPerScreen * fontSize) ) < 0) { // play with this value if scale more (was 10 * 22)
        //      println(sn.screen_location.y);
        textBuffers.remove(i);  // + (10 * 22
        //       println("removed one");
      }
    }


    /* initial test code:
     textAlign(CENTER);
     noStroke();
     fill(0);
     textFont(f, 10);
     String t = "this is a test of the LadyK broadcasting system";
     // riff off Dan Shiffman's Learning Processing example 17-4:
     pushMatrix();
     
     translate(l.x, l.y);
     scale = s;
     //float scale = 5; // unit scale. this will change
     float cols = p_width/scale;  // <-- need to work on this so all text can be seen
     float rows = p_width/scale;
     int charCount = 0;
     
     for (int j = 0; j < rows; j++) {
     for (int i = 0; i < cols; i++) {
     //where are we, pixel-wise:
     float x = i * scale;
     float y = j * scale;
     text(t.charAt(charCount), x, y);
     //text(t, xLoc, yLoc); // starter code
     //move to next character
     charCount = (charCount + 1) % t.length();
     }
     } // for-loops
     popMatrix();
     */
  }// showText


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
      //println(centerX);
    }
  }
}
