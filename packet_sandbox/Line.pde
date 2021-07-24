class Line {
  PVector loc; // location
  String l; // the text
  int yStart;
  PFont f;

  Line(int lineNum, PVector loc_) {
    loc = loc_.copy();
    l = inputText[lineNum];
    f = createFont("Arial", 16);
    textFont(f, 24);
    textAlign(LEFT);
    yStart = int(loc.y) + 200;
  }

  void scrollUp() {
    int maxPortHeight = linesPerScreen * 25 + 10;
    for (int y_ = yStart; y_ < maxPortHeight; y_+= 25) {
      loc.y = y_;
      text(l, loc.x, loc.y);
    }
    yStart--;
  }

  void display() {

    text(l, loc.x, loc.y);
  }
}
