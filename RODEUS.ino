#include <NewPing.h>
#include <Servo.h>

#define TRIG_PIN A3
#define ECHO_PIN A1
#define MAX_DISTANCE 200

#define kanan 1
#define kiri 0

NewPing sonar(TRIG_PIN, ECHO_PIN, MAX_DISTANCE);

Servo myservo;

const int in1 = 5;
const int in2 = 6;
const int in3 = 3;
const int in4 = 4;
const int enA = 7;
const int enB = 2;
int i;
int mSpeed = 175;
int bspeed = 255;

long duration;
int distance[181], jarDepan;
int maxLowDistance=100;
float kompenKa=1, kompenKi=0.7;
bool belok, serong;

void setup() 
{
  // put your setup code here, to run once:
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  pinMode(in3, OUTPUT);
  pinMode(in4, OUTPUT);
  pinMode(enA, OUTPUT);
  pinMode(enB, OUTPUT);
  
  Serial.begin(9600);

  myservo.attach(A0);
  myservo.write(90);
}

void loop() 
{
  // put your main code here, to run repeatedly:
  jarDepan = sonar.ping_cm();
  
  if(jarDepan==0) jarDepan=200;
  while(jarDepan>20)
  {
    moveForward();
    delay(100);
    moveStop();
    
    jarDepan = sonar.ping_cm();
    if(jarDepan==0) jarDepan=200;
  }
  
  scanning();
  //Serial.println(jarDepan);
  if(distance[0]>distance[180])
  {
    belok=kanan;
    if(distance[45]>distance[0])
    {
      turnRight();
      delay(165);
      moveStop();
    }
    else
    {
      turnRight();
      delay(330);
      moveStop();
    }
  }
  else if(distance[0]<distance[180])
  {
    belok=kiri;
    if(distance[135]>distance[180])
    {
      turnLeft();
      delay(165);
      moveStop();
    }
    else
    {
      turnLeft();
      Serial.println("kiri");
      delay(330);
      moveStop();
      Serial.println("berhenti");
    }
  }
}

void scanning()
{
  for(i=90;i>=0;i--)
  {
    myservo.write(i);
    delay(10);
    int distance = sonar.ping_cm();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  for(i=0;i<=180;i++)
  {
    myservo.write(i);
    delay(20);
    distance[i] = sonar.ping_cm();
    if(distance[i]==0) distance[i]=250;
    int distance = sonar.ping_cm();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
  for(i=180;i>=90;i--)
  {
    myservo.write(i);
    delay(10);
    int distance = sonar.ping_cm();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}

void moveStop() 
{
  //Serial.println("stop");
  digitalWrite(in1, LOW);
  digitalWrite(in2, LOW);

  digitalWrite(in3, LOW);
  digitalWrite(in4, LOW);
}

void moveForward() 
{

  /*--if(!goesForward)
    {
     goesForward=true;--*/
  analogWrite(enA, mSpeed*kompenKi);
  analogWrite(enB, mSpeed*kompenKa);
  //Serial.println("maju");
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);

  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);
}

void moveBackward() 
{
  //goesForward=false;
  analogWrite(enA, mSpeed*kompenKi);
  analogWrite(enB, mSpeed*kompenKa);
  //Serial.println("mundur");
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);

  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);
}

void turnRight() 
{
  analogWrite(enA, bspeed);
  analogWrite(enB, bspeed);
  //Serial.println("kanan");
  digitalWrite(in1, HIGH);
  digitalWrite(in2, LOW);

  digitalWrite(in3, LOW);
  digitalWrite(in4, HIGH);
}

void turnLeft() 
{
  analogWrite(enA, bspeed);
  analogWrite(enB, bspeed);
  //Serial.println("kiri");
  digitalWrite(in1, LOW);
  digitalWrite(in2, HIGH);

  digitalWrite(in3, HIGH);
  digitalWrite(in4, LOW);
}
