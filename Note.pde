class Note {
  PVector location;
  int type;
  
  String imageSource;
  PImage img;
  PVector imgSize = new PVector(50, 100);
  
  boolean selected = false;
  
  color hiddedColor = color(150, 150, 150);
  color thisColor = hiddedColor;
  
  boolean isShown;
  
  void show() {
    isShown = true;
    thisColor = noteColor;
  }
  void hide() {
    isShown = false;
    thisColor = hiddedColor;
  }
  
  Note(int x, int y, int t) {
    setType(t);
    setLocationWithOffset(x, y);
  }
  
  Note(int x, int y, String t) {
    setType(t);
    setLocationWithOffset(x, y);
  }
  
  void setLocationWithOffset(int x, int y) {
    int id = getNoteTypeId();
    PVector offset = new PVector(0, 0);
    if(id >= 0) {
      offset = noteTypes[id].offset.get();
    }
    setLocation(round(x+offset.x), round(y+offset.y));
  }
  
  
  void setLocation(int x, int y) {
    location = new PVector(x, y);
  }
  
  void setLocation(PVector loc) {
    location = loc.get();
  }
  
  void locationOffset(PVector originalLoc, PVector newLoc) {
    PVector loc = location.get();
    PVector offset = new PVector(0, 0);
    offset.x = originalLoc.x - newLoc.x;
    offset.y = originalLoc.y - newLoc.y;
    loc.x += offset.x;
    loc.y += offset.y;
    setLocation(loc);
  }
  
  PVector getLocation() {
    return location.get();
  }
  
  void setType(String typeAsString) {
    if(typeAsString == "Alennus") {
      setType(0);
    }
    else if(typeAsString == "Ylennys") {
      setType(1);
    }
  }
  
  String getTypeAsString() {
    if(type == 0) { return "Alennus"; }
    else if(type == 1) { return "Ylennys"; }
    return "";
  }
  
  void setType(int t) {
    type = t;
    loadImageFromSource(getImageSource());
    imgSize = getImageSize().get();
  }
  
  String getImageSource() {
    //Here should be commands which draws the note
    String toReturn = "";
    int id = getNoteTypeId();
    if(id >= 0) { toReturn = noteTypes[id].getImgSrc(); }
    return toReturn;
  }
  
  PVector getImageSize() {
    //Here should be commands which draws the note
    PVector toReturn = new PVector(100, 100);
    int id = getNoteTypeId();
    if(id >= 0) { toReturn = noteTypes[id].getImgSize().get(); }
    return toReturn;
  }
  
  int getNoteTypeId() {
    int toReturn = -1;
    if(noteTypes != null) { //Check if noteTypes object array is not null
      for(int i = 0; i < noteTypes.length; i++) { //Go through all the noteTypes
        if(noteTypes[i] != null) { //Check if noteTypes object is not null
          if(noteTypes[i].getType() == type) { //Check if found right noteType
            toReturn = i;
            break;
          }
        }
      }
    }
    return toReturn;
  }

 
  PVector getImgSizeFast() {
    return imgSize.get();
  }
  
  void loadImageFromSource(String source) {
    img = loadImage(source);
  }
  
  void drawImage(PVector loc) {
   //Draw the note image
   PVector size = imgSize.get();
   if(img != null) {
     pushStyle();
       tint(thisColor);
       image(img, getX(loc), getY(loc), getX(size), getY(size));
     popStyle();
   }
   else {
     pushMatrix();
     pushStyle();
       textSize(20);
       stroke(255);
       fill(255);
       text("?", getX(loc), getY(loc));
     popStyle();
     popMatrix();
   }
  }
  
  PVector placeToMove;
  
  void moveTo(PVector newPlace) {
    placeToMove = newPlace;
  }
  
  void draw() {
    if(isShown) {
      //Draw the note
      drawImage(location);
    }
   if(placeToMove != null) {
     if(placeToMove.x < location.x) {
       location.x -= round((location.x - placeToMove.x) / 10);
     }
     if(placeToMove.x > location.x) {
       location.x += round((placeToMove.x - location.x) / 10);
     }
     if(placeToMove.y < location.y) {
       location.y -= round((location.y - placeToMove.y) / 10);
     }
     if(placeToMove.y > location.y) {
       location.y += round((placeToMove.y - location.y) / 10);
     }
   }
  }
}
