//------------------------------OSC-------------------------//|
//touchOSC libraries                                        //|
import oscP5.*;                                             //|
import netP5.*;                                             //|
                                                            //|
//import method class                                       //|
import java.lang.reflect.Method;                            //|
                                                            //|
OscP5 oscP5;                                                //|
                                                            //|
NetAddress Remote;                                          //|
int portOutgoing = 9000;                                    //|
String remoteIP = "192.168.0.12"; //iPadin ip-osoite        //|
//----------------------------OSC END-----------------------//|

//Define all the variables
color bgColor = color(100, 100, 100);
color noteColor = color(255, 0, 0);
color viivastoColor = color(0, 0, 0);
color textColor = color(0, 0, 0);

PVector programSize = new PVector(1000, 800);
PVector offset = new PVector(0, 0);
PVector mouseLocation;
PVector mouseOldLocation;
PVector rectLocation = new PVector(0, 0);
PVector storageLocation = new PVector(0, 0);

int numberOfMajors = 7;
int numberOfNotes = 10;
Note[][] notes = new Note[numberOfMajors][numberOfNotes];

NoteType[] noteTypes;

Major[] majors;

int firstSelected = -1;

PImage viivasto;

int actualMajor = 0;
//End defining variables

void setup() {
  //Setup commands here
  programSize = new PVector(displayWidth, displayHeight);
  size(getX(programSize), getY(programSize));
  storageLocation = new PVector(width-500, height-100);
  
      //---------------------------------------------------------Touchoscin setup-komennot------------------------------------------------------------
      oscP5 = new OscP5(this, 8000); 
    //----------------------------------------------------------------------------------------------------------------------------------------------
    
  
  int numberOfNoteTypes = 2;
  noteTypes = new NoteType[numberOfNoteTypes];
  noteTypes[0] = new NoteType(0, "media/alennus.png", 30, 120);
  noteTypes[1] = new NoteType(1, "media/ylennys.png", 30, 120);

  
  String viivastoUrl = "media/viivasto.png";
  
  viivasto = loadImage(viivastoUrl);
  
  majors = new Major[numberOfMajors];
  majors[0] = new Major("C", new float[] { }, new float[] { });
  majors[1] = new Major("D", new float[] { 3.5, 5 }, new float[] { });
  majors[2] = new Major("E", new float[] { 3.5, 4, 5, 5.5 }, new float[] { });
  majors[3] = new Major("F", new float[] { }, new float[] { 3 });
  majors[4] = new Major("G", new float[] { 5 }, new float[] { });
  majors[5] = new Major("A", new float[] { 5, 3.5, 5.5 }, new float[] { });
  majors[6] = new Major("B", new float[] { 5, 3.5, 5.5, 4, 2.5 }, new float[] { });
  
  for(int i = 0; i < majors.length; i++) {
    int a = 0;
    for(int j = 0; j < majors[i].ylennykset.length; j++) {
      notes[i][a] = new Note(a*50+100, round(majors[i].ylennykset[j]*100)-60, "Ylennys");
      a++;
    }
    for(int j = 0; j < majors[i].alennukset.length; j++) {
      notes[i][a] = new Note(a*50+100, round(majors[i].alennukset[j]*100)-80, "Alennus");
      a++;
    }
  }
}

void drawViivasto(int x, int y, int w, int h) {
  pushMatrix();
  pushStyle();
    stroke(viivastoColor);
    strokeWeight(10);
    for(int i = 0; i < 5; i++) {
      translate(0, 100);
      line(100, 0, 1000, 0);
    }
  popMatrix();
  popStyle();
}

void draw() {
  //Infinite loop until program end
  background(bgColor); //Clear screen in every loop
  translate(getX(offset), getY(offset));
  drawViivasto(100, 300, 1000, 400);
  pushStyle();
    stroke(textColor);
    fill(textColor);
    textSize(50);
    text(majors[constrain(actualMajor, 0, majors.length-1)].name, 50, 50);
  popStyle();
  mouseLocation = new PVector(mouseX-getX(offset), mouseY-getY(offset)); //Save mouse location to PVector
  mouseOldLocation = new PVector(pmouseX-getX(offset), pmouseY-getY(offset));
  if(mousePressed) {
    rectLocation = mouseLocation.get(); //Copy mouseLocation to rectLocation
  }
  
  
  
  
  if(notes != null) { //Check that notes object array isn't null
    for(int i = 0; i < notes.length; i++) { //Go through all the note objects
      if(actualMajor == i) {
        if(notes[i] != null) {
          for(int j = 0; j < notes[i].length; j++) {
            if(notes[i][j] != null) { //Check that note object isn't null
              if(((vectorsAreOnTopOfEachOthers(mouseLocation, notes[i][j].location, notes[i][j].getImgSizeFast()) && mousePressed && firstSelected == -1) || notes[i][j].selected) && (firstSelected == -1 || firstSelected == i)) { //Check if mouse is about in the same place where the note object is
                notes[i][j].locationOffset(mouseLocation, mouseOldLocation);
                notes[i][j].selected = true;
                if(firstSelected == -1) {
                  firstSelected = i;
                }
              }
              if(!mousePressed) {
                notes[i][j].selected = false;
                firstSelected = -1;
              }
              notes[i][j].draw();
            }
          }
        }
      }
    }
  }
}

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

boolean vectorsAreAboutSame(PVector a, PVector b) {
  //Check that are the locations of two PVectors near each others
  if(isAbout(a.x, b.x) && isAbout(a.y, b.y)) { //Check x and y locations seperately
    return true;
  }
  return false;
}

boolean isAbout(float a, float b) { //Check are the values of two variables about the same
  if(isAbout(a, b, 5)) { //The different between a and b can be not more than five
    return true;
  }
  return false;
}
boolean isAbout(float a, float b, float acc) {
  if(abs(a-b) < acc) {
    return true;
  }
  return false;
}

class Note {
  PVector location;
  int type;
  
  String imageSource;
  PImage img;
  PVector imgSize = new PVector(50, 100);
  
  boolean selected = false;
  
  
  Note(int x, int y, int t) {
    setLocation(x, y);
    setType(t);
  }
  
  Note(int x, int y, String t) {
    setLocation(x, y);
    setType(t);
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
       tint(noteColor);
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
  
  void draw() {
    //Draw the note
    drawImage(location);
  }
}

class NoteType {
  int type;
  String imageSource;
  PVector size = new PVector(100, 100);
  
  NoteType(int t, String imgSrc) {
    type = t;
    imageSource = imgSrc;
  }
  
  NoteType(int t, String imgSrc, int w, int h) {
    type = t;
    imageSource = imgSrc;
    size = new PVector(w, h);
  }
  
  int getType() { return type; }
  String getImgSrc() { return imageSource; }
  PVector getImgSize() { return size; }
  
}

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

void keyReleased() {
  if(keyCode == UP) {
    actualMajor++;
  }
  else if(keyCode == DOWN) {
    actualMajor--;
  }
  println(actualMajor);
}
