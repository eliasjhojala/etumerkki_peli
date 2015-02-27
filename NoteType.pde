class NoteType {
  int type;
  String imageSource;
  PVector size = new PVector(100, 100);
  PVector offset;


  NoteType(int t, String imgSrc, int w, int h, int offsetX, int offsetY) {
    type = t;
    imageSource = imgSrc;
    size = new PVector(w, h);
    offset = new PVector(offsetX, offsetY);
  }
  
  int getType() { return type; }
  String getImgSrc() { return imageSource; }
  PVector getImgSize() { return size; }
  
}
