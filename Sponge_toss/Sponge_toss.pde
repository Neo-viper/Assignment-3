import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
AudioPlayer player;
Minim minim;

PFont myFont;

PImage[] polImages = new PImage[4]; //created array that has four spaces
PImage Sponge;
PImage Dail;
float r = random(0, 4);
int headcount= 13;
int Spongecount = 10;
Head [] newHead;
Sponge [] mySponge;
int score, scoreLevel1, scoreLevel2, scoreLevel3, mode1, mode2, mode3, sightWeight, usedSponge;
color sightColor;

boolean Win, noSponge;

int CurrentFrameCount; //Timer

 
void setup() 
{
  minim = new Minim(this);
  player = minim.loadFile("Diddly.mp3", 2048);
  player.play();
  loop();
  
  myFont = createFont("CartoonBlocks.ttf",64);
  
  
  size(800 , 800);
  
  //loading images into array spots
  polImages[0] = loadImage("Enda.png"); 
  polImages[1] = loadImage("Eamon.png");
  polImages[2] = loadImage("Cowen.png");
  polImages[3] = loadImage("Joan.png");
  
  Sponge = loadImage("Sponge.png");
  Dail = loadImage("Dail.png");
  
  //smooth(); //Draws all geometry with smooth (anti-aliased) edges.
  background(0);
  
  sightColor = #FF0818;
  sightWeight = 2;
  
  newHead = new Head[headcount];
  
  
    for (int i =0; i < headcount;i++) 
    {
      newHead[i] = new Head (random(40, width-20), random(40, height-20), random(1, 3), random(1, 3));
    }
}
 
void draw() 
{
  background(0);
  image(Dail, 0, 0);
  winScore();
  sight();
  Win=true;
  
  mySponge = new Sponge[Spongecount - usedSponge]; //amount of sponges used
  
  for (int i =0; i < Spongecount - usedSponge; i++) 
    {
      mySponge[i] = new Sponge(width-50, i*15+230);
    }
     
     for (int i =0; i < headcount;i++) 
      {
        if ( !newHead[i].hit) 
      {
        newHead[i].move();
        newHead[i].display();
        Win= false;
      }
  }
  
  for (int i =0; i < Spongecount- usedSponge;i++) 
    {
      mySponge[i].display();
    }
      if (Win) 
     {
      textFont(myFont);
      textAlign(CENTER, CENTER);
      fill(0);
      rect(0, 0, width, height);
      fill(#FA7900);
      textSize(72);
      text("YOU WIN !", width/2, height/2-50);
      text("your score is "+score, width/2, height/2);
    }
}
 
void mousePressed() 
{
  sightColor = #FFD603;
  sightWeight = 3;
  
  for (int i = 0; i < headcount;i++) //number of points depending on how many sponges the player has used
    {
      if (dist(mouseX, mouseY, newHead[i].x, newHead[i].y)<20 && dist(mouseX, mouseY, newHead[i].x, newHead[i].y)>15 &&  mouseButton==LEFT && usedSponge>=0 && usedSponge<10 ) 
        {
          scoreLevel1 = 6;
          mode1++;
        } 
    
     else if (dist(mouseX, mouseY, newHead[i].x, newHead[i].y)<=15 && dist(mouseX, mouseY, newHead[i].x, newHead[i].y)>10 && mouseButton==LEFT && usedSponge>=0 && usedSponge<10 ) 
        {
          scoreLevel2 = 8;
          mode2++;
        }
      
    else if (dist(mouseX, mouseY, newHead[i].x, newHead[i].y)<=10 &&  mouseButton==LEFT && usedSponge>=0 && usedSponge<10) 
        {
          scoreLevel3 = 10;
          mode3++;
        }
  }
  
  if (mouseButton==LEFT && usedSponge>9 ) 
  {
    noSponge=true;
    CurrentFrameCount=frameCount;
  }
  
  checkHit();
  if (mouseButton == LEFT ) 
  {
    usedSponge++;
    if ( usedSponge>10) 
    {
      Spongecount=usedSponge;
    }
  }
  
  if (mouseButton == RIGHT && usedSponge>=10) 
  {
    Spongecount=10;
    usedSponge=0;
  }
}
 
 
 
void winScore() 
{
  score = scoreLevel1 * mode1 + scoreLevel2 * mode2 + scoreLevel3 * mode3;
  textFont(myFont);
  textAlign(LEFT, CENTER);
  textSize(64);
  fill(#0004fa);
  text("Your score is : "+score, 15, 15);
  text("Your score is : "+score, 15, 15);
  textSize(30);
  fill(#0004fa);
  
  if (frameCount<160)//Text times out after 160 frames 
  {
    text("Press left mouse button to throw. Press right mouse button for new sponge.", 15, 60);
  }
  
  if (usedSponge>9) 
  {
    if (frameCount-CurrentFrameCount<160) 
    {
      text("Press right mouse button tfor new sponge.", 15, 60);
    }
  }
}
 
void checkHit() //Issue that if the player hits two targets at the same time scoring becomes broken. 
{
  for (int i = 0; i < headcount;i++) 
  {
    if (dist(mouseX, mouseY, newHead[i].x, newHead[i].y) <50 && mouseButton==LEFT && usedSponge>=0 && usedSponge<10 ) 
    {
      newHead[i].hit=true;
    }
  }
}
 
void sight() 
  {
    pushStyle();
    noCursor();
    noFill();
    strokeWeight(sightWeight);
    stroke(sightColor);
    ellipse(mouseX, mouseY, 30, 30);
    line(mouseX-30, mouseY, mouseX+30, mouseY);
    line(mouseX, mouseY-30, mouseX, mouseY+30);
    popStyle();
  }
 
void mouseReleased() 
  {
    sightColor = #FF0818;
    sightWeight=2;
  }
 
class Head 
{
  float x, y;
  float velX, velY;
  boolean hit;
  
  Head(float posX, float posY, float temp_velX, float temp_velY)
  
  {
    x = posX;
    y = posY;
    velX = temp_velX;
    velY = temp_velY;
    noStroke();
}
 
void move()

  {
    x+=velX;
    y+=velY;
    
    if (x>width-20 ) 
    {
      velX*=-1;
      x=width-20;
    } 
    
    else if (x<20) 
    {
      velX*=-1;
      x=20;
    }
    
    if (y>height-20 )
    {
      velY*=-1;
      y=height-20;
    } 
    
    else if (y<20) 
    {
      velY*=-1;
      y=20;
    }
  }
 
void display() 
  {
      //image(polImages[int(random(0, 4))], x, y, 40, 40);
      //image(polImages[0], x, y, 80, 80);
      //image(polImages[1], x, y, 60, 60);
      //image(polImages[2], x, y, 40, 40);
      image(polImages[3], x, y, 60, 60);
   
  }
}
 
class Sponge //Sponge ammo 
{
  int x, y;
 
  Sponge(int posx, int posy) 
  {
    x = posx;
    y = posy;
  }
 
  void display() 
  {
    image(Sponge, 700, y, 100 , 50); 
  }
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}

