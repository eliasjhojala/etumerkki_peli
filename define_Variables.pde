

//Define all the variables
boolean showAlsoHiddenNotes = true;

float zoom = 0.8;

color bgColor = color(255, 255, 200);
color noteColor = color(255, 0, 0);
color viivastoColor = color(0, 0, 0);
color textColor = color(0, 0, 0);

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
//End defining variables


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
