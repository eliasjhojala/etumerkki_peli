class Major {
  float[] ylennykset;
  float[] alennukset;
  String name;
  
  Major(String n, float[] ylen, float alen[]) {
    name = n;
    ylennykset = new float[ylen.length];
    arrayCopy(ylen, ylennykset);
    alennukset = new float[alen.length];
    arrayCopy(alen, alennukset);
    for(int i = 0; i < ylennykset.length; i++) {
      ylennykset[i] = 6-ylennykset[i];
    }
    for(int i = 0; i < alennukset.length; i++) {
      alennukset[i] = 6-alennukset[i];
    }
  }
}
