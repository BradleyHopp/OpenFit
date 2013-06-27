import toxi.geom.*;
import toxi.processing.*;
import processing.pdf.*;
import controlP5.*;
ControlP5 cp5;

PFont font;
float drawingScale = 15; // 30 to zoom in on crotch, 15 is nice on macbook air
float pointSize = 6;

// measurements on lisa, in inches
float hipEase = -1.;
float buttEase = -1.;
float thighEase = -.5;
float kneeEase = 1.; 
float calfEase = -.5; 
float ankleEase = 4;
// pant specific variables
float hemHeight = 0; // 0 is ankle, - or + inches above and below
boolean pocket = false;
float pocketHeight = 2;
float pocketWidth = 3;
boolean yoke = false;
float yokeInside = 2;
float yokeOutside = 1.25;
float seamAllowance = 3/8.;

//vertical measurements
float inseam = 31; // crotch to floor 
float sideseam = 37; // hip to floor

float kneeToFloor = 19; // 
float calfToFloor = 11;
float ankleToFloor = 4.75;
float instep = 3; // top of instep to floor

float crotchLength = 17; 
float crotchLengthFront = 6.5; 

//circumference measurements
float hip = 32;
float hipFront = 15;

float butt = 35;
float buttFront = 16; 
float thigh = 21;
float thighFront = 9;

float midthighToCrotch = 3;
float midthigh = 18.5;
float midthighFront = 7.75;

float knee = 13; 
float kneeFront = 5.5;// can simply be knee/2, -1 for front, +1 for back
float calf = 13; //at fullest part
float calfFront= 5.5;
float ankle = 7.5; 
float ankleFront = 3.5;

float hipToButtF = 3;
float hipToButtB = 6;
float hipToButtS = 4;

float crotchToButt = 2.5;

// ease variables, defaults to skinny jean
// negative if smaller than body
// ease operate on x axis, comparison between body point and pant point

// Drafting points mark horizontal planes
// Body points are drafted in the following order:
// Thigh circumference is centered on 0 for F and B
// Crotch curve is widened based on crotch length and begins from inner thigh point
// Hipline is drawn from the beginning of the crotch curve
// Other end of hipline stops at sideseam
// Ankle, Calf and Knee are marked around center and can be shifted L/R as a unit
// Midthigh is three inches below thigh and can be shifted L/R
// Butt is marked from its intersection with crotch curve

PVector d0, d1, d2, d2a, d3, d4, d5, d6, d0R; // drafting points
PVector b1, b2, b3, b3a, b4, b5, b6, b7, b8, b9, b9a, b10, b11, b12, cp1, cp2; //body points front
PVector b13, b14, b15, b15a, b16, b17, b18, b19, b20, b20a, b21, b21a, b22, b23, b24, cp3, cp4; //body points back
PVector p1, p2, p3, p3a, p4, p5, p6, p7, p8, p9, p9a, p10, p11, p12; //pant points front
PVector p13, p14, p15, p15a, p16, p17, p18, p19, p20, p21, p21a, p22, p23, p24; // pant points back
//PVector p5a, p6a, c5, c6, p4a, p4b, p6b; // front pocket, currently only half size
//PVector p17a, p19a; // yoke


void setup() {  
  size(900, 720);
  font = createFont("Arial", 12);
  textFont(font);
  measurementGui();
}

float crotchLengthBack, hipBack, buttBack, thighBack, midthighBack, kneeBack, calfBack, ankleBack;

void draw() {
  crotchLengthBack = crotchLength - crotchLengthFront; 
  hipBack = hip - hipFront;
  buttBack = butt - buttFront;
  thighBack = thigh - thighFront; 
  midthighBack = midthigh - midthighFront;
  kneeBack = knee - kneeFront;
  calfBack= calf - calfFront;
  ankleBack = ankle - ankleFront;


  background(255);
  grid(); 
  //calculate points, can these go in the setup? bodypartBack would need to be declared outside of draw for this to work
  draftingPoints();
  bodyPointsF();
  bodyPointsB();
  pantPointsF();
  pantPointsB();

  //drafting points
  pushMatrix();
  translateScale (2, 8);
  drawDraftingPoints();
  popMatrix();

  // front
  pushMatrix();
  translateScale (12, 8);
  
  //BODY FRONT
  //drawBodyPointsF(); 
  drawBezier(b9, cp1, cp2, b7);
  //bodyShapeF();
  
  //PANT FRONT
  drawPantPointsF();
  pantShapeF();
  popMatrix();

  // back
  pushMatrix();
  translateScale (30, 8);
  
  //BODY BACK
  //drawBodyPointsB();
  drawBezier(b21, cp3, cp4, b19);
//bodyShapeB();
  
  // PANT BACK
  drawPantPointsB();
  pantShapeB();
  popMatrix();
}

void grid() { // why do i need to pass drawing scale here? -- if isnt global? 
  stroke(150, 150, 150, 30);
  int xsegments = int(width / drawingScale);
  int ysegments = int(height / drawingScale);
  for (int y = 0; y < ysegments; y++) {
    line(0, y * drawingScale, width, y * drawingScale);
  }
  for (int x = 0; x < xsegments; x++) {
    line(x * drawingScale, 0, x * drawingScale, height);
  }
}

