void exitProgram() {
  //Closes the program
  exit();
}

int getX(PVector v) { //return x location from PVector as int
  return int(v.x);
}
int getY(PVector v) { //return y location from PVector as int
  return int(v.y);
}

boolean vectorsAreOnTopOfEachOthers(PVector a, PVector b, PVector s) {
  //Check that are the locations of two PVectors near each others
  if((a.x > b.x && a.x < b.x + s.x) && (a.y > b.y && a.y < b.y + s.y)) { //Check x and y locations seperately
    return true;
  }
  return false;
}

boolean vectorCentersAreOnTopOfEachOthers(PVector a, PVector b, PVector s) {
  PVector center1 = getCenterOfVector(a, s);
  PVector center2 = getCenterOfVector(b, s);
  PVector acc = new PVector(100, 30);
  return vectorsAreAboutSame(center1, center2, acc);
}

PVector getCenterOfVector(PVector vector, PVector size) {
  return new PVector((size.x / 2 + vector.x), (size.y / 2 + vector.y));
}

boolean vectorsAreAboutSame(PVector a, PVector b) {
  //Check that are the locations of two PVectors near each others
  if(isAbout(a.x, b.x) && isAbout(a.y, b.y)) { //Check x and y locations seperately
    return true;
  }
  return false;
}

boolean vectorsAreAboutSame(PVector a, PVector b, float acc) {
  //Check that are the locations of two PVectors near each others
  return isAbout(a.x, b.x, acc) && isAbout(a.y, b.y, acc); 
}

boolean vectorsAreAboutSame(PVector a, PVector b, PVector acc) {
  //Check that are the locations of two PVectors near each others
  return isAbout(a.x, b.x, acc.x) && isAbout(a.y, b.y, acc.y); 
}

boolean isAbout(float a, float b) { //Check are the values of two variables about the same
  return isAbout(a, b, 5);
}
boolean isAbout(float a, float b, float acc) {
  return abs(a-b) < acc;
}

