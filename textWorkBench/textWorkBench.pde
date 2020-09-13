int p_width;
float scale ;
PFont f;
ArrayList<Portal>windows;
Portal p;
int indexPos = 0;

int numColors = 600; 
float  rd, gn, blu, rdshift, gnshift, blushift;
color  kuler, paint, previousKuler, lerpKuler;


void setup() {
  size(800, 800);
  colorMode(RGB, 1.0, 1.0, 1.0, 255);
  f = createFont("Courier", 12);
  //background(255);
  windows = new ArrayList<Portal>(5);
  scale = 5;

  rd = 0;
  gn = random(1);  // 128, 255
  blu = random(1); // 0, 192
  kuler = color(rd, gn, blu);


  PVector location = new PVector(-100, -100);
  p = new Portal(location);
  //indexPos = (indexPos + 1) % 10;
  windows.add(p);
}


void draw() {
  //Portal p_ = windows[0];
  //println(p_.l.x);
  background(1.0);

  colorChange();

  // fill(paint);
  //fill(255);
  // ellipse( 60, 60, 50, 50);
  if (windows.size()-1 > 0) {


    textAlign(CENTER);
    noStroke();
    fill(0);
    textFont(f, 14);
    String t = "this is a test of the LadyK broadcasting system...";
    // riff off Dan Shiffman's Learning Processing example 17-4:
    //fill(paint, 100);
    //fill(255);


    for (int i = 0; i <= windows.size()-1; i++) {
      Portal p_ = windows.get(i);
      p_.display();
      pushMatrix();
      //println(p_.l.x);

      translate(p_.l.x, p_.l.y);
      fill(0);
      //text(t, 0, 0);

      //float scale = 20; // unit scale. this will change
      //float cols = 80/scale;  // <-- need to work on this so all text can be seen
      //float rows = 80/scale;
      //int charCount = 0;

      //fill(0);
      //for (int j = 0; j < rows; j++) {
      //  for (int k = 0; k < cols; k++) {
      //    //where are we, pixel-wise:
      //    float x = j * scale;
      //    float y = i * scale;
      //    text(t.charAt(charCount), x, y);
      //    //text(t, xLoc, yLoc); // starter code
      //    //move to next character
      //    charCount = (charCount + 1) % t.length();
      //  }
      //} // for-loops

      /*
      reference via Luke:
       
       var margin = 20;
       var thex = margin; // start at the left
       var they = 40; // start one line down
       
       
       for(i in termfrequency)
       {
       if(termfrequency[i]/documentfrequency[i]>=thresh)
       {
       var tw = textWidth(i+' ');
       if(thex+tw>width)
       {
       thex = margin;
       they = they+12;
       }
       text(i, thex, they);
       thex+=tw;
       
       }
       }
       
       
       */
      int limit = 80;
      int text_x =0;
      int text_y = 0;
      //int charCount = 0;
      for (int j = 0; j < t.length(); j++) {
       float tw = textWidth(t.charAt(j));
        if (text_x >= limit) {
          text_y += 28;
        }
        text(t.charAt(j), text_x, text_y);
        //move to next character
        //charCount = (charCount + 1) % t.length();
      }

      popMatrix();
      //fill(lerpKuler, 100);
    } //windows array
  }// if
}// draw


void mousePressed() {
  PVector location = new PVector(mouseX, mouseY);
  p = new Portal(location);
  windows.add(0, p);
}

void colorChange() {

  //previousKuler = color(abs(rd * .3), abs(gn * .2), abs(blu * .3));

  float curTime = millis()/1000.0;
  // c_rand = random(0.5, 0.6);
  // curTime = c_rand * curTime;

  //println(curTime);
  //if (frameCount % 10 == 0) {
  for (int i=0; i< numColors; i++) {

    rd = sin(curTime * 0.8f + i * 0.0011f) + 0.5f; //R  + 0.8f
    gn = sin(curTime * 0.7f + i * 0.0013f) + 0.5f; //G * 0.5f + 0.5f   + 0.5f
    blu = sin(curTime * 0.3f + i * 0.0017f) + 0.5f; 
    rdshift = abs(rd - .5);
    gnshift = abs(gn - .5);
    blushift = abs(blu - .5);
    rd = abs(rd);
    gn = abs(gn);
    blu = abs(blu);
    kuler = color(rd, gn, blu);

    //previousKuler = color(rdshift, gnshift, blushift);
  }

  paint = kuler;
  //lerpKuler = lerpColor(paint, previousKuler, 0.5);
}
