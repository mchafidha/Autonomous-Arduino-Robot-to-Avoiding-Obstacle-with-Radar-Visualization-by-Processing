import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;
Serial myPort;// defubes variables
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;
void setup() {

  size (1356, 700);
  smooth();
  myPort = new Serial(this, "COM9", 9600); // pembacaan port serial
  myPort.bufferUntil('.'); // pembacaan data dari port serial (sudut,jarak.)
}
void draw() {



  fill(98, 245, 31);
  noStroke();
  fill(0, 4);
  rect(0, 0, width, height-height*0.045);

  fill(98, 245, 31); // hijau
  // pemanggilan fungsi untuk menampilkan radar
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}
void serialEvent (Serial myPort) { // mulai pembacaan data dari port serial

  data = myPort.readStringUntil('.');
  data = data.substring(0, data.length()-1);

  index1 = data.indexOf(","); // membaca sampai karakter ',' kemudian dimasukkan pada variabel "index1"
  angle= data.substring(0, index1); // membaca data dari posisi 0 ke posisi dari variable index1 atau nilai sudut yang dikirim dari Arduino
  distance= data.substring(index1+1, data.length()); // membaca data dari posisi "index1" sampai data terakhir menampilkan jarak

  // konversi variabel string menjadi int
  iAngle = int(angle);
  iDistance = int(distance);
}
void drawRadar() {
  pushMatrix();
  translate(width/2, height-height*0.12); // pergerakan dari koordinat awal ke lokasi selanjutnya
  noFill();
  strokeWeight(2);
  stroke(250, 250, 250);
  // draws the arc lines
  arc(0, 0, (width-width*0.15), (width-width*0.15), PI, TWO_PI);
  arc(0, 0, (width-width*0.4137), (width-width*0.4137), PI, TWO_PI);
  arc(0, 0, (width-width*0.6227), (width-width*0.6227), PI, TWO_PI);
  arc(0, 0, (width-width*0.830), (width-width*0.830), PI, TWO_PI);
  // draws the angle lines
  line(-width/2, 0, width/2, 0);
  line(0, 0, (-width/2.3)*cos(radians(30)), (-width/2.3)*sin(radians(30)));
  line(0, 0, (-width/2.3)*cos(radians(60)), (-width/2.3)*sin(radians(60)));
  line(0, 0, (-width/2.3)*cos(radians(90)), (-width/2.3)*sin(radians(90)));
  line(0, 0, (-width/2.3)*cos(radians(120)), (-width/2.3)*sin(radians(120)));
  line(0, 0, (-width/2.3)*cos(radians(150)), (-width/2.3)*sin(radians(150)));
  line((-width/2)*cos(radians(30)), 0, width/2, 0);
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(width/2, height-height*0.12); // pergerakan koordinat awal ke lokasi baru
  strokeWeight(9);
  stroke(255, 10, 10); // red color
  pixsDistance = iDistance*((height-height*0.1666)*0.025); // konversi cm ke pixels
  // batasan display jarak pada grafik 40 cm
  if (iDistance<40) {
    // penggambaran grafik berdasarkan sudut dan jarak
    line(pixsDistance*cos(radians(iAngle)), -pixsDistance*sin(radians(iAngle)), (width-width*0.565)*cos(radians(iAngle)), -(width-width*0.565)*sin(radians(iAngle)));
  }
  popMatrix();
}
void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(250, 250, 250);
  translate(width/2, height-height*0.12); // gerak dari koordinat awal ke koordinat baru baru
  line(0, 0, (height-height*0.159)*cos(radians(iAngle)), -(height-height*0.159)*sin(radians(iAngle))); // garis berdasarkan sudut
  popMatrix();
}
void drawText() { // menampilkan text pada layar

  pushMatrix();
  if (iDistance>40) {
    noObject = "Out of Range";
  } else {
    noObject = "In Range";
  }
  fill(0, 0, 0);
  noStroke();
  rect(0, height-height*0.07, width, height);
  fill(98, 245, 31);
  textSize(25);

  text("10cm", width-width*0.3854, height-height*0.0833);
  text("20cm", width-width*0.281, height-height*0.0833);
  text("30cm", width-width*0.177, height-height*0.0833);
  text("40cm", width-width*0.0729, height-height*0.0833);
  textSize(40);
  text("RODEUS", width-width*0.875, height-height*0.02);
  text("Angle: " + iAngle +" °", width-width*0.58, height-height*0.02);
  text("Distance: ", width-width*0.32, height-height*0.02);
  if (iDistance<40) {
    fill(255,0,0);
    text(" " + iDistance +" cm", width-width*0.195, height-height*0.02);
  }
  textSize(25);
  fill(98, 245, 60);
  translate((width-width*0.5594)+width/2*cos(radians(30)), (height-height*0.0907)-width/2*sin(radians(30)));
  rotate(-radians(-60));
  text("30°", 0, 0);
  resetMatrix();
  translate((width-width*0.538)+width/2*cos(radians(60)), (height-height*0.0388)-width/2*sin(radians(60)));
  rotate(-radians(-30));
  text("60°", 0, 0);
  resetMatrix();
  translate((width-width*0.51)+width/2*cos(radians(90)), (height-height*0.00233)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°", 0, 0);
  resetMatrix();
  translate(width-width*0.493+width/2*cos(radians(120)), (height-height*0.01029)-width/2*sin(radians(120)));
  rotate(radians(-30));
  text("120°", 0, 0);
  resetMatrix();
  translate((width-width*0.4604)+width/2*cos(radians(150)), (height-height*0.0454)-width/2*sin(radians(150)));
  rotate(radians(-60));
  text("150°", 0, 0);
  popMatrix();
}
