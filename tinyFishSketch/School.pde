class School {
  ArrayList<Fish> school;
  float z, t, tc, noiseVal, noiseValCum;
  School() {
    school = new ArrayList<Fish>();
  }
  void run() {
    float randie = random(0, 1);
    if (randie > .8) {
      t += 0.1;
      noiseVal = noise(t);
      noiseValCum += noiseVal;
      if (noiseValCum > 4) {

        float randieC = random(0, 4);
        float amount = map(randieC, 0, 4, 0, 1);
        interColor = lerpColor(midColor, topColor, amount);
        noiseValCum = 0;
      } else {
        float randieC = random(0, 2);
        float amount= map(randieC, 0, 2, 0.5, 1);
        interColor = lerpColor(bottomColor, midColor, amount);
      }
      shimmer = interColor;
    }
    
    
    noiseVal += .05 ;

    for (Fish f : school) {
      f.run(school, noiseVal);
    }
  }
  void addFish(Fish f) {
    school.add(f);
  }
}
