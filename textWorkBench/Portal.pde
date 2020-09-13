class Portal {
  PVector l;

  Portal(PVector loc) {
    l = new PVector(loc.x, loc.y);
    //fill(random(255), random(255), random(255), 100);
  }


  void display() {
    fill(paint, 100);
    ellipse(l.x, l.y, 80, 80);
  }
}
