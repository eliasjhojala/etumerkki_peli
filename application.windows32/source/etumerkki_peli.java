import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import java.lang.reflect.Method; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class etumerkki_peli extends PApplet {

public void draw() {
  //Infinite loop until program end
  background(bgColor); //Clear screen in every loop
  translate(getX(offset), getY(offset));
  doScale();
  
  
  if(gameStarted && countPoints() >= 0) {
    if(!allMajorsCompleted) runGame(); //Run game if it's not completed yet
    else congratulations(); //If completed then show congratulations text
  }
  else if(countPoints() < 0) {
    gameOver(); //Write game over text
  }
  else {
    gameStartMillis = millis();
    gameStarted = true;
  }
  
}

public void gameOver() {
  bgColor = color(255, 0, 0);
  textSize(200);
  textAlign(CENTER);
  fill(invert(bgColor));
  text("GAME OVER", width/2, height/2);
}

public void congratulations() {
  if(!finalPointsCounted) {
    finalPoints = round(countPoints());
    finalPointsCounted = true;
  }
  textSize(50);
  textAlign(CENTER);
  fill(invert(bgColor));
  text("Congratulations! You completed the game and got " + str(finalPoints) + "/10 points", width/2, height/2);
  if(!gameCompleteTimeCounted) {
    completeTime = millis()-gameStartMillis;
    gameCompleteTimeCounted = true;
  }
}

public int invert(int c) {
  return color(255-red(c), 255-green(c), 255-blue(c));
}

public void changeMajor(int direction) {
  if(direction == UP) { actualMajor++; } else if(direction == DOWN) { actualMajor--; }
  if(actualMajor >= majors.length) {
    allMajorsCompleted = true;
  }
  actualMajor = constrain(actualMajor, 0, majors.length-1);
  createNotesToDrag();
}

public void mouseDragged() {
  mouseIsDragged = true;
}
public void mousePressed() {
  mouseIsDragged = true;
}
public void mouseReleased() {
  mouseIsDragged = false;
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
class Note {
  PVector location;
  int type;
  
  String imageSource;
  PImage img;
  PVector imgSize = new PVector(50, 100);
  
  boolean selected = false;
  
  int hiddedColor = color(150, 150, 150);
  int thisColor = hiddedColor;
  
  boolean isShown;
  
  boolean found;
  
  PVector defaultLocation;
  
  boolean dragging;
  int lastDraggedTime;
  
  public void show() {
    isShown = true;
    thisColor = noteColor;
  }
  public void hide() {
    isShown = false;
    thisColor = hiddedColor;
  }
  
  Note(int x, int y, int t) {
    setType(t);
    setLocationWithOffset(x, y, true);
  }
  
  Note(int x, int y, String t) {
    setType(t);
    setLocationWithOffset(x, y, true);
  }
  
  public void setLocationWithOffset(int x, int y, boolean thisIsDefault) {
    int id = getNoteTypeId();
    PVector offset = new PVector(0, 0);
    if(id >= 0) {
      offset = noteTypes[id].offset.get();
    }
    setLocation(round(x+offset.x), round(y+offset.y));
    
    if(thisIsDefault) { defaultLocation = new PVector(round(x+offset.x), round(y+offset.y)); }
  }
  
  
  public void setLocation(int x, int y) {
    location = new PVector(x, y);
  }
  
  public void setLocation(PVector loc) {
    location = loc.get();
  }
  
  public void locationOffset(PVector originalLoc, PVector newLoc) {
    PVector loc = location.get();
    PVector offset = new PVector(0, 0);
    offset.x = originalLoc.x - newLoc.x;
    offset.y = originalLoc.y - newLoc.y;
    loc.x += offset.x;
    loc.y += offset.y;
    setLocation(loc);
  }
  
  public PVector getLocation() {
    return location.get();
  }
  
  public void setType(String typeAsString) {
    if(typeAsString == "Alennus") {
      setType(0);
    }
    else if(typeAsString == "Ylennys") {
      setType(1);
    }
  }
  
  public String getTypeAsString() {
    if(type == 0) { return "Alennus"; }
    else if(type == 1) { return "Ylennys"; }
    return "";
  }
  
  public void setType(int t) {
    type = t;
    loadImageFromSource(getImageSource());
    imgSize = getImageSize().get();
  }
  
  public String getImageSource() {
    //Here should be commands which draws the note
    String toReturn = "";
    int id = getNoteTypeId();
    if(id >= 0) { toReturn = noteTypes[id].getImgSrc(); }
    return toReturn;
  }
  
  public PVector getImageSize() {
    //Here should be commands which draws the note
    PVector toReturn = new PVector(100, 100);
    int id = getNoteTypeId();
    if(id >= 0) { toReturn = noteTypes[id].getImgSize().get(); }
    return toReturn;
  }
  
  public int getNoteTypeId() {
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

 
  public PVector getImgSizeFast() {
    return imgSize.get();
  }
  
  public void loadImageFromSource(String source) {
    img = loadImage(source);
  }
  
  public void drawImage(PVector loc) {
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
  
  public void moveTo(PVector newPlace) {
    placeToMove = newPlace.get();
  }  
  
  public void moveToDefault() {
    moveTo(defaultLocation);
  }
  
  public boolean isInDefaultLocation() {
    return location.x == defaultLocation.x && location.y == defaultLocation.y;
  }
  
  public void draw() {
    if(isShown || showAlsoHiddenNotes) {
      //Draw the note
      drawImage(location);
    }
   checkMoving();
  }
  
  public void checkMoving() {
    if(placeToMove != null) {
      if(placeToMove.x != -1) {
         if(placeToMove.x < location.x-1) {
           location.x -= (location.x - placeToMove.x) / 10;
           movingObjects = true;
         }
         else if(placeToMove.x > location.x+1) {
           location.x += (placeToMove.x - location.x) / 10;
           movingObjects = true;
         }
         else {
           placeToMove.x = -1;
         }
      }
      if(placeToMove.y != -1) {
         if(placeToMove.y < location.y-1) {
           location.y -= (location.y - placeToMove.y) / 10;
           movingObjects = true;
         }
         else if(placeToMove.y > location.y+1) {
           location.y += (placeToMove.y - location.y) / 10;
           movingObjects = true;
         }
         else {
           placeToMove.y = -1;
         }
      }
   }
  }
}
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
  
  public int getType() { return type; }
  public String getImgSrc() { return imageSource; }
  public PVector getImgSize() { return size; }
  
}


//Define all the variables
boolean showAlsoHiddenNotes = true;

float zoom = 0.8f;

int bgColor = color(200, 255, 255);
int noteColor = color(0, 0, 0);
int viivastoColor = color(0, 0, 0);
int textColor = color(0, 0, 0);

PVector programSize = new PVector(1000, 800);
PVector offset = new PVector(100, 100);
PVector mouseLocation;
PVector mouseOldLocation;
PVector rectLocation = new PVector(0, 0);
PVector storageLocation = new PVector(0, 0);

int numberOfMajors = 7;
int numberOfNotes = 10;
Note[][] notes = new Note[numberOfMajors][numberOfNotes];
Note[] notesToDrag = new Note[100];
Note[][] notesToDragTemp = new Note[3][100];

NoteType[] noteTypes;

Major[] majors;

int firstSelected = -1;

PImage viivasto;

int actualMajor = 0;

boolean mouseIsDragged = true;
boolean movingObjects = false;

boolean allMajorsCompleted;

boolean gameStarted;
long gameStartMillis;
boolean gameCompleteTimeCounted;
long completeTime;

int mistakes;
int finalPoints;
boolean finalPointsCounted;
//End defining variables


//------------------------------OSC-------------------------//|
//touchOSC libraries                                        //|
                                             //|
                                             //|
                                                            //|
//import method class                                       //|
                            //|
                                                            //|
OscP5 oscP5;                                                //|
                                                            //|
NetAddress Remote;                                          //|
int portOutgoing = 9000;                                    //|
String remoteIP = "192.168.0.12"; //iPadin ip-osoite        //|
//----------------------------OSC END-----------------------//|
public void createNotesToDragObjects() {
  //Todo: create objects all the time in thread --> changing major won't take so much time
  for(int i = 0; i < 10; i++) {
    notesToDragTemp[getNext(actualNotesToDrag, 0, 2)][i*2] = new Note(width-100, height-300, "Alennus");
    notesToDragTemp[getNext(actualNotesToDrag, 0, 2)][i*2+1] = new Note(width-300, height-300, "Ylennys");
    notesToDragTemp[getNext(actualNotesToDrag, 0, 2)][i*2].show();
    notesToDragTemp[getNext(actualNotesToDrag, 0, 2)][i*2+1].show();
  }
}

int actualNotesToDrag = 0;
public void createNotesToDrag() {
  notesToDrag = notesToDragTemp[getNext(actualNotesToDrag, 0, 2)];
  thread("createNotesToDragObjects");
  actualNotesToDrag = getNext(actualNotesToDrag, 0, 2);
}

public void resetNoteToDragLocation(Note note) {
  PVector newLocation = new PVector(0, 0);
  if(note.getTypeAsString().equals("Alennus")) {
    newLocation.x = width-100;
    newLocation.y = height-300;
  }
  if(note.getTypeAsString().equals("Ylennys")) {
    newLocation.x = width-300;
    newLocation.y = height-300;
  }
  note.moveTo(newLocation);
}

public void drawViivasto(int x, int y, int w, int h) {
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
public void exitProgram() {
  //Closes the program
  exit();
}

public int getX(PVector v) { //return x location from PVector as int
  return PApplet.parseInt(v.x);
}
public int getY(PVector v) { //return y location from PVector as int
  return PApplet.parseInt(v.y);
}

public boolean vectorsAreOnTopOfEachOthers(PVector a, PVector b, PVector s) {
  //Check that are the locations of two PVectors near each others
  if((a.x > b.x && a.x < b.x + s.x) && (a.y > b.y && a.y < b.y + s.y)) { //Check x and y locations seperately
    return true;
  }
  return false;
}

public boolean vectorCentersAreOnTopOfEachOthers(PVector a, PVector b, PVector s) {
  PVector center1 = getCenterOfVector(a, s);
  PVector center2 = getCenterOfVector(b, s);
  PVector acc = new PVector(100, 30);
  return vectorsAreAboutSame(center1, center2, acc);
}

public PVector getCenterOfVector(PVector vector, PVector size) {
  return new PVector((size.x / 2 + vector.x), (size.y / 2 + vector.y));
}

public boolean vectorsAreAboutSame(PVector a, PVector b) {
  //Check that are the locations of two PVectors near each others
  if(isAbout(a.x, b.x) && isAbout(a.y, b.y)) { //Check x and y locations seperately
    return true;
  }
  return false;
}

public boolean vectorsAreAboutSame(PVector a, PVector b, float acc) {
  //Check that are the locations of two PVectors near each others
  return isAbout(a.x, b.x, acc) && isAbout(a.y, b.y, acc); 
}

public boolean vectorsAreAboutSame(PVector a, PVector b, PVector acc) {
  //Check that are the locations of two PVectors near each others
  return isAbout(a.x, b.x, acc.x) && isAbout(a.y, b.y, acc.y); 
}

public boolean isAbout(float a, float b) { //Check are the values of two variables about the same
  return isAbout(a, b, 5);
}
public boolean isAbout(float a, float b, float acc) {
  return abs(a-b) < acc;
}

public String secondsToGoodTime(int seconds) {
  String toReturn = "";
  int minutes = PApplet.parseInt(seconds/60);
  seconds = seconds % 60;
  int hours = PApplet.parseInt(minutes/60);
  minutes = minutes % 60;
  int days = PApplet.parseInt(hours/24);
  hours = hours % 24;
  if(days != 0) {
    toReturn = days + "days " + hours + "h " + minutes + "min " + str(seconds) + "sec";
  }
  else if(hours != 0) {
    toReturn = hours + "h " + minutes + "min " + str(seconds) + "sec";
  }
  else if(minutes != 0) {
    toReturn = minutes + "min " + str(seconds) + "sec";
  }
  else {
    toReturn = str(seconds) + "sec";
  }
  return toReturn;
}

public int getNext(int val, int min, int max) {
  if(val >= min && val < max) {
    val++;
  }
  else {
    val = min;
  }
  return val;
}

//This OSC receiver is made only to control colors from sliders on touch screen on some mobile device

public void oscEvent(OscMessage theOscMessage) {
  String addr = theOscMessage.addrPattern(); //Luetaan touchOSCin elementin osoite
  int val = round(theOscMessage.get(0).floatValue()); //Luetaan touchOSCin elementin arvo
  
  for(int i = 1; i <= 12; i++) { //K\u00e4yd\u00e4\u00e4n kaikki touchOSCin kanavat (faderit) l\u00e4pi
    String nimi = "/1/fader" + str(i);
    if(addr.equals(nimi)) {
      if(i == 1) {
        bgColor = color(val, green(bgColor), blue(bgColor));
      }
      if(i == 2) {
        bgColor = color(red(bgColor), val, blue(bgColor));
      }
      if(i == 3) {
        bgColor = color(red(bgColor), green(bgColor), val);
      }
      if(i == 4) {
        noteColor = color(val, green(noteColor), blue(noteColor));
      }
      if(i == 5) {
        noteColor = color(red(noteColor), val, blue(noteColor));
      }
      if(i == 6) {
        noteColor = color(red(noteColor), green(noteColor), val);
      }
      if(i == 7) {
        viivastoColor = color(val, green(viivastoColor), blue(viivastoColor));
      }
      if(i == 8) {
        viivastoColor = color(red(viivastoColor), val, blue(viivastoColor));
      }
      if(i == 9) {
        viivastoColor = color(red(viivastoColor), green(viivastoColor), val);
      }
    }
  }
  
  println("RECEIVED");
}
public void runGame() { 
  drawViivasto(); //Draw viivasto
  showMajorName(); //Show current major name
  showTime(); //Show how many seconds (and minutes) you have played the game
  showMistakes(); //Show how many mistakes have you done
  drawPointBar(); //Draw bar which shows your current points
  
  setMouseLocations(); //Save mouseLocation to PVectors
  doDragging(); //Drag notes
  checkIfRight(); //Check if note is dragged to right place
  drawToDrag(); //Draw notes to drag
}

public void doScale() {
  scale(zoom);
}

public void drawViivasto() {
  drawViivasto(100, 300, 1000, 400);
}

public void showMajorName() {
  //Show current major name
  pushStyle();
    stroke(textColor);
    fill(textColor);
    textSize(50);
    text(majors[constrain(actualMajor, 0, majors.length-1)].name, 50, 50);
  popStyle();
  //End of showing current major name
}

public void showTime() {
  //Show time in top right corner
  pushStyle();
    pushMatrix();
      stroke(textColor);
      fill(textColor);
      textSize(50);
      text(secondsToGoodTime(round(millis()-gameStartMillis)/1000), width-100, 50);
    popMatrix();
  popStyle();
  //End of showing time in top right corner
}

public void showMistakes() {
  //Show all the mistakes in top right corner
  pushStyle();
    pushMatrix();
      stroke(textColor);
      fill(textColor);
      textSize(50);
      text("mistakes " + str(mistakes), width-100, 150);
    popMatrix();
  popStyle();
  //End of showing all the mistakes in top right corner
}

public void setMouseLocations() {
  mouseLocation = new PVector(mouseX-getX(offset), mouseY-getY(offset)); //Save mouse location to PVector
  mouseOldLocation = new PVector(pmouseX-getX(offset), pmouseY-getY(offset));
  mouseLocation.div(zoom);
  mouseOldLocation.div(zoom);
}

public void doDragging() {
  { //Dragging
     movingObjects = false;
     if(notesToDrag != null) { //Check that notesToDrag array is not null
      Note[] actualNotes = notesToDrag;
      boolean handCursor = false;
      for(int j = 0; j < actualNotes.length; j++) {
        int i = j + 100;
        Note note = actualNotes[j];
        if(note != null) { //Check that note object isn't null
          
          if(((vectorsAreOnTopOfEachOthers(mouseLocation, note.location, note.getImgSizeFast())))) {
            handCursor = true;
          }
          
          
          boolean noteIsAlreadySelected = note.selected;
          boolean nothingSelected = firstSelected == -1;
          boolean thisSelected = firstSelected == i;
          boolean noOthersSelected = nothingSelected || thisSelected;
          boolean notAlreadyFound = !note.found;
          boolean mouseOverNote = vectorsAreOnTopOfEachOthers(mouseLocation, note.location, note.getImgSizeFast());
          boolean clickedNote = mouseOverNote && mousePressed && nothingSelected;
  
          //Check if we want to move note
          if(((clickedNote || noteIsAlreadySelected) && noOthersSelected) && notAlreadyFound) {
            note.locationOffset(mouseLocation, mouseOldLocation);
            note.selected = true;
            
            if(nothingSelected) {
              firstSelected = i;
            }
            
            note.dragging = true;
            note.lastDraggedTime = frameCount;
          } //End of: Check if we want to move note
          else { //If you dragged note to wrong place then move it back to default location
              if(!note.isInDefaultLocation() && !note.found) {
                if(frameCount - note.lastDraggedTime == 1) {
                  note.moveToDefault();
                  mistakes++;
                }
              }
          }
          
          if(!mousePressed) {
            note.selected = false;
            firstSelected = -1;
          }
          note.checkMoving();
        }
      }
      if(handCursor) { cursor(HAND); }
      else { cursor(ARROW); }
    } //End of checking notesToDrag array isn't null
  } //End of dragging
}

public void checkIfRight() {
  { //CHECK IF DRAGGED TO RIGHT PLACE --> IF ALL DRAGGED TO RIGHT PLACE CHANGE MAJOR
    if(notes != null) { //Check that notes object array isn't null
      for(int i = 0; i < notes.length; i++) { //Go through all the note objects
        if(actualMajor == i) {
          Note[] actualNotes = notes[i];
          boolean thisMajorIsCompleted = true;
          if(actualNotes != null) {
            for(int j = 0; j < actualNotes.length; j++) {
              Note note = actualNotes[j];
              if(note != null) { //Check that note object isn't null
                
                if(!note.found) { //Check if note is not "found" already
                  thisMajorIsCompleted = false;
                  { //Check if some note is dragged to right place
                    boolean draggedToRightPlace = false; //By default nothing is in right place
                    if(notesToDrag != null) { //Check that notesToDrag array isn't null
                      for(int k = 0; k < notesToDrag.length; k++) { //Go through all the notesToDrag
                      Note toDrag = notesToDrag[k];
                        if(notesToDrag[k] != null) { //Check that single notesToDrag object isn't null
                          if(vectorCentersAreOnTopOfEachOthers(toDrag.location, note.location, note.getImgSizeFast()) && !mousePressed && toDrag.type == note.type && !note.found) {
                            //What to do if dragged (near) to right place
                            draggedToRightPlace = true; //Tell that there are notes dragged to right place
                            toDrag.moveTo(note.location);
                            toDrag.thisColor = color(0, 255, 0); //Set green color to tell that's right place
                            note.found = true; //Never move this note anymore
                            toDrag.found = true; //Never move this note anymore
                            //End of what to do if dragged (near) to right place
                          }
                        } //End of checking that single notesToDrag object isn't null
                      } //End of going through all the notesToDrag
                    } //End of checking that notesToDrag array isn't null
                    if(draggedToRightPlace) { 
                      //What to do if dragged to right place
                    }
                  } //End of checkin are there any notes dragged to right place
                  
                } //End of checking if note is not "found" anymore
                
                note.draw();
                
                
              } //End of checking single note object isn't null
            } //End of going through actualNotes (notes in current major)
          } //End of checking actualNotes object array isn't null
          if(thisMajorIsCompleted && !movingObjects) {
            changeMajor(UP);
          }
        } //End of if(actualMajor == i)
      } //End of for(int i = 0; i < notes.length; i++)
    } //End of if(notes != null)
  } //END OF CHECKING IF DRAGGED TO RIGHT PLACE ETC.
}

public void drawToDrag() {
  { //Draw notes to drag
    Note[] actualNotes = notesToDrag;
    for(int j = 0; j < actualNotes.length; j++) {
      Note note = actualNotes[j];
      if(note != null) { //Check that note object isn't null
        note.draw();
      } //End of checking that note object isn't null
    }
  } //End of drawing notes to drag
}

public long getRunMillis() {
  return millis()-gameStartMillis;
}
public int getRunSecs() {
  return round(getRunMillis()/1000);
}
public int getMistakes() {
  return mistakes;
}
public int getActualMajor() {
  return actualMajor;
}
public float countPoints() {
  return 10-getRunMillis()/PApplet.parseFloat(10000)-getMistakes()+getActualMajor();
}

public void drawPointBar() {
  pushMatrix();
    pushStyle();
      fill(0);
      rect(50, height-50, map(countPoints(), 0, 10, 0, width-100), 50);
    popStyle();
  popMatrix();
}
public void setup() {
  //Setup commands here
  { //Set window size to display size (full screen)
    programSize = new PVector(displayWidth, displayHeight);
    size(getX(programSize), getY(programSize));
  } //End of setting window site to display size (full screen)
  storageLocation = new PVector(width-500, height-100); //Location for notes to drag "storage"
  
    //---------------------------------------------------------Setup commands of touchOsc-----------------------------------------------------------
      oscP5 = new OscP5(this, 8000); 
    //----------------------------------------------------------------------------------------------------------------------------------------------
    
  { //Create noteTypes
    int numberOfNoteTypes = 2;
    noteTypes = new NoteType[numberOfNoteTypes];
    noteTypes[0] = new NoteType(0, "media/alennus.png", 60, 190, 0, -50);
    noteTypes[1] = new NoteType(1, "media/ylennys.png", 60, 190, 0, -35);
  } //End of creating noteTypes

  
  String viivastoUrl = "media/viivasto.png"; //Set right path for viivasto file
  
  viivasto = loadImage(viivastoUrl); //Load viivasto image from file
  
  { //Create all the majors
    majors = new Major[numberOfMajors];
    //Syntax: Major(String: name, float[]: ylennykset, float[]: alennukset);
    majors[0] = new Major("C", new float[] { }, new float[] { }); 
    majors[1] = new Major("D", new float[] { 5, 3.5f }, new float[] { });
    majors[2] = new Major("E", new float[] { 5, 3.5f, 5.5f, 4 }, new float[] { });
    majors[3] = new Major("F", new float[] { }, new float[] { 3 });
    majors[4] = new Major("G", new float[] { 5 }, new float[] { });
    majors[5] = new Major("A", new float[] { 5, 3.5f, 5.5f }, new float[] { });
    majors[6] = new Major("H", new float[] { 5, 3.5f, 5.5f, 4, 2.5f }, new float[] { });
  } //End of creating all the majors
  
  { //Set right places to all the notes according to majors
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
  } //End of setting right places to all the notes according to majors
  
  createNotesToDrag(); //And here create the notes which user can drag
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "etumerkki_peli" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
