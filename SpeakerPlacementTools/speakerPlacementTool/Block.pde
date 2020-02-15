class Block {
 
  PVector origin;
  Boolean fiber;
  //int s;
  color skin, outline;
  char identity; // "f" = fibers; "s" = speaker

  Block(PVector loc) {
    //blockWidth = 6;
    //blockHeight = 10;
    origin = loc.copy();
    identity = 'f';
  }

  boolean rollover(PVector m) {
    if (m.x >= origin.x && m.x <= origin.x + blockWidth && 
      m.y >= origin.y && m.y <= origin.y + blockHeight) {
      //println(s);
      //skin = color(255, 0, 0);
      return true;
    } else {
      return false;
    }
  }

  void fiberSpeaker(color s, color o) {
    //skin = color(127);
   // outline = color(o);
    stroke(o);
    fill(s);
    rect(origin.x, origin.y, blockWidth, blockHeight);
  }
/*
  void speaker() {
    f = color(255);
    outline = color(255);
    stroke(outline);
    fill(f);
    rect(origin.x, origin.y, blockWidth, blockHeight);
  }
  */

  void display() {
    if (identity == 's') fiberSpeaker(color(255), color(255)); // make it a white speaker
    else if (identity == 'f')fiberSpeaker(color(127), color(0)); // make it a grey block
  }
}
