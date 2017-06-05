import java.lang.*;
import java.util.*;
import processing.video.*;
import processing.sound.*;
int framenumber;
PImage monkey, background, scratch, stickNote, luckyCoin;
ArrayList<Integer []> redPixels = new ArrayList<Integer []>();  
ArrayList<Integer []> leftArmPixels = new ArrayList<Integer []>(); 
ArrayList<Integer []> rightArmPixels = new ArrayList<Integer []>(); 
ArrayList<Integer []> leftLegPixels = new ArrayList<Integer []>(); 
ArrayList<Integer []> rightLegPixels = new ArrayList<Integer []>(); 
ArrayList<Mouse> allMouses;
ArrayList<Balloon> allBalloons;

int [] chest = new int[2];
int [] leftArm = new int[2];
int [] rightArm = new int[2];
int [] leftLeg = new int[2];
int [] rightLeg = new int[2];

SoundFile meow;
SoundFile coin;

int minX;
int maxX;
int maxY;
int minY;

int deadMice = 0;
public class Mouse {
  
  public int xPos;
  public int yPos;
  public float xSpeed;
  public float ySpeed;
  public int xDirection;
  public int yDirection;
  
  Random rand = new Random();
  PImage Image = loadImage(sketchPath("mouse.png"));
  
    public Mouse(int X, int Y) {
    this.xPos = X;
    this.yPos = Y;
    
    this.xSpeed = 0.5;
    this.ySpeed = 0.5;
    
    this.xDirection = rand.nextInt(5) + 1;
    this.yDirection = rand.nextInt(5) + 1;
  }
}

public class Balloon { 
  public int xPos;
  public int yPos;
  public float xSpeed;
  public float ySpeed;
  public int xDirection;
  public int yDirection;
  
  Random rand = new Random();
  PImage Image = loadImage(sketchPath("balloon.png"));
  
    public Balloon(int X, int Y) {
    this.xPos = X;
    this.yPos = Y;
    
    this.xSpeed = 0.5;
    this.ySpeed = 0.5;
    
    this.xDirection = 1;
    this.yDirection = 1;
  }
}

void setup() {
  size(1280, 720);
  allMouses = new ArrayList<Mouse>();
  allBalloons = new ArrayList<Balloon>();
  scratch = loadImage(sketchPath("scratch.png"));
  stickNote = loadImage(sketchPath("stickNote.png"));
  luckyCoin= loadImage(sketchPath("luckyCoin.png"));
  meow = new SoundFile(this, sketchPath("meow.mp3"));
  coin = new SoundFile(this, sketchPath("coin.mp3"));
  frameRate(60);
  framenumber = 1;
}

void draw() {
    if (frameCount < 953){
      background = loadImage(sketchPath("") + "BGNew/" + nf(framenumber, 4) + ".tif");
      monkey = loadImage(sketchPath("") + "MonkeyNew/" + nf(framenumber, 4) + ".tif");
      image(background, 0, 0);
    }
    
    extractRedPixels(monkey);
    int [] mainCenter = getCenter(redPixels); // Which is basically the chest.
    separateBlobs(mainCenter); // The chest at each frame.
    framenumber++;
   
    // Draw Left Arm
    pushMatrix();
    translate(leftArm[0], leftArm[1]);
    PImage catLeftArm = loadImage(sketchPath("cat-arm-left-long.png"));
    image(catLeftArm, 290, 130);
    popMatrix();
    
    // Draw Right Arm
    pushMatrix();
    translate(rightArm[0], rightArm[1]);
    PImage catRightArm = loadImage(sketchPath("cat-arm-right-long.png"));
    image(catRightArm, 320, 110);
    popMatrix();
    
    // Draw Left Leg
    pushMatrix();
    translate(leftLeg[0], leftLeg[1]);
    PImage catLeftLeg = loadImage(sketchPath("cat-legs-long.png"));
    image(catLeftLeg, 390, 130);
    popMatrix();
    
    // Draw Right Leg
    pushMatrix();
    translate(rightLeg[0], rightLeg[1]);
    PImage catRightLeg = loadImage(sketchPath("cat-legs-long.png"));
    image(catRightLeg, 390, 130);
    popMatrix();
    
    // Draw Chest
    pushMatrix();
    translate(chest[0], chest[1]);
    PImage catBody = loadImage(sketchPath("cat-body.png"));
    image(catBody, 300, 50);
    popMatrix();
   
    // Draw Mouses
    if(allMouses.size() != 0) {      
      for (int i = 0; i < allMouses.size(); i++) {
        boolean collided = collisionDetection(allMouses.get(i));
        if(!collided){
          pushMatrix();
          translate(allMouses.get(i).xPos, allMouses.get(i).yPos);
          image(allMouses.get(i).Image,0, 0);
          // Change x and y based on speed.        
          allMouses.get(i).xPos = allMouses.get(i).xPos + (int)(allMouses.get(i).xSpeed * allMouses.get(i).xDirection);  
          allMouses.get(i).yPos = allMouses.get(i).yPos + (int)(allMouses.get(i).ySpeed * allMouses.get(i).yDirection);
          popMatrix();
        } 
        else {
          deadMice += 1;
          meow.play();
          coin.play();
          image(scratch, allMouses.get(i).xPos, allMouses.get(i).yPos);
          allMouses.remove(allMouses.get(i));
        }
      }
    }
    
    if(allBalloons.size() != 0) {      
      for (int i = 0; i < allBalloons.size(); i++) {
          pushMatrix();
          translate(allBalloons.get(i).xPos, allBalloons.get(i).yPos);
          image(allBalloons.get(i).Image,chest[0] + 300, chest[1] + 50);
          // Change x and y based on speed.        
          allBalloons.get(i).xPos = allBalloons.get(i).xPos + (int)(allBalloons.get(i).xSpeed * allBalloons.get(i).xDirection);  
          allBalloons.get(i).yPos = allBalloons.get(i).yPos + (int)(allBalloons.get(i).ySpeed * allBalloons.get(i).yDirection);
          popMatrix();     
      }
    }
    
    stroke(0);
    image(stickNote, 100, 0);
    textSize(28);
    text("Score: ", 150, 200, deadMice);
    text(deadMice, 240, 200);
    int j = 50;
     for(int i = 0; i < deadMice; i++){
      image(luckyCoin, j, 10);
      j += 50;
    }
    
    redPixels.clear();
    leftArmPixels.clear();
    rightArmPixels.clear();
    leftLegPixels.clear();
    rightLegPixels.clear();

}

void extractRedPixels(PImage frame) {
  
   for (int x = 0; x < frame.width; x++) { 
    for (int y = 0; y < frame.height; y++) {
      int loc = x + y * frame.width;
      color c = frame.pixels[loc]; 
      boolean isRed = red(c) > 160 && green(c) < 140;
      if (isRed) {
      redPixels.add( new Integer [] {x,y});
      }
    }
  }   
}

int[] getCenter(ArrayList<Integer []> listOfReds) {
  
  int N = listOfReds.size();
  int sumX = 0, sumY = 0;
  for(int i = 0; i < N; i++){
    sumX = sumX + listOfReds.get(i)[0];
    sumY = sumY + listOfReds.get(i)[1];
  }
  int centeredX = (int) sumX/N;
  int centeredY = (int) sumY/N;
  int [] center = {centeredX, centeredY};
  return center;
  
}

void separateBlobs(int[] centerCoord){
  
  int centerX = centerCoord[0];
  int centerY = centerCoord[1];
  // Center coordinates are the the Chest coordinates.
   chest[0] = centerX;
   chest[1] = centerY;
      
  for (Integer[] p : redPixels){
    // Red pixel coordinates.
   int redX = p[0];
   int redY = p[1];
    // Left Arm
    if((redX > -1 && redX < centerX) && (redY > -1 && redY < centerY)){
      leftArmPixels.add(new Integer [] {redX, redY});  
    }
    
    // Right Arm
    if((redX > centerX && redX < monkey.width) && (redY > -1 && redY < centerY)){
      rightArmPixels.add(new Integer [] {redX, redY});
    }
    
    // Left Leg
    if((redX > -1 && redX < centerX) && (redY > centerY && redY < monkey.height)){ 
      leftLegPixels.add(new Integer [] {redX, redY});
    }
    
    // Right Leg
    if((redX < monkey.width && redX > centerX) && (redY > centerY && redY < monkey.height)){ 
      rightLegPixels.add(new Integer [] {redX, redY});
    }
  }
  
    // Get the center of the Left Arm
    if(leftArmPixels.size() != 0){  
    int [] center1 = getCenter(leftArmPixels);
        leftArm[0] = center1[0];
        leftArm[1] = center1[1];
    }
    
    // Get the center of the Right Arm
    if(rightArmPixels.size() != 0){
    int [] center2 = getCenter(rightArmPixels);
        rightArm[0] = center2[0];
        rightArm[1] = center2[1];
    }
    
    // Get the center of the Left Leg
    if(leftLegPixels.size() != 0){ 
    int [] center3 = getCenter(leftLegPixels);
        leftLeg[0] = center3[0];
        leftLeg[1] = center3[1];
    }
    
    // Get the center of the Right Leg
    if(rightLegPixels.size() != 0){
    int [] center4 = getCenter(rightLegPixels);
        rightLeg[0] = center4[0];
        rightLeg[1] = center4[1];
    }
   
}

void mouseClicked() {
  Mouse m = new Mouse(mouseX, mouseY); 
  allMouses.add(m);
}

boolean collisionDetection(Mouse mouseMouse){
   
    boolean collided = false;
    int x = mouseMouse.xPos ;
    int y = mouseMouse.yPos;

    minX = leftArm[0] + 270;
    minY = leftArm[1] + 100;
    maxX = rightArm[0] + 520;
    maxY = leftLeg[1] + 320;
    
    if(x > minX && x < maxX && y > minY && y < maxY){
      println("collision");
      collided = true;
    }
   return collided;   
}

void keyPressed() {
  Balloon b1 = new Balloon(400, 140); 
  Balloon b2 = new Balloon(500 , 150); 
  Balloon b3 = new Balloon(-400, 150); 
  Balloon b4 = new Balloon(-300, 140); 
  allBalloons.add(b1);
  allBalloons.add(b2);
  allBalloons.add(b3);
  allBalloons.add(b4);
}


   //if (allMouses.get(i).xPos >background.width || allMouses.get(i).xPos < -1) {
        //   println("deleted");
        //  allMouses.remove(allMouses.get(i));
        //}      
        //if (allMouses.get(i).yPos >background.height || allMouses.get(i).yPos < -1) {
        //   println("deleted");
        //  allMouses.remove(allMouses.get(i));
        //}