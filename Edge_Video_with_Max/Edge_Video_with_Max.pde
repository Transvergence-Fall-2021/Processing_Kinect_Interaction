import oscP5.*;
import netP5.*;


OscP5 oscP5;

/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myBroadcastLocation; 
OscMessage myOscMessage;

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;
import blobDetection.*;

PImage img;
int[] depth;
int threshold = 800;
BlobDetection theBlobDetection;

// A reference to our box2d world
Box2DProcessing box2d;

Kinect2 kinect;

float deg;

boolean ir = false;
boolean colorDepth = false;
boolean mirror = true;

// An ArrayList of particles that will fall on the surface
ArrayList<Particle> particles;

// An object to store information about the uneven surface
Surface surface;

int position_x = 100;
int position_y = -15;
int kinect_width;
int kinect_height;


PVector mouse;
ParticleFollow[]pts;

void setup() {
  size(640, 520);
  kinect = new Kinect2(this);
  kinect_width = kinect.depthWidth;
  kinect_height = kinect.depthHeight;
  kinect.initDepth();
  kinect.initDevice();

  //deg = kinect.getTilt();
  // kinect.tilt(deg);
  //size(383,200);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -4);
  box2d.listenForCollisions();
  particles = new ArrayList<Particle>();
  theBlobDetection = new BlobDetection(kinect_width, kinect_height);
  theBlobDetection.setThreshold(0.1f);

  pts=new ParticleFollow[3000];
  for(int i=0;i<pts.length;i++){
    pts[i]=new ParticleFollow();
  }
  mouse=new PVector(0,0);
  oscP5 = new OscP5(this,7401);
  myBroadcastLocation = new NetAddress("127.0.0.1",7400);
}



void draw() {
  myOscMessage = new OscMessage("/test");
  //frameRate(20);
  background(#DCE0E0);
    strokeWeight(3);
    /*
  for (int i=0; i<boats.length; i++) {
    boats[i].update();
    boats[i].display();
  }
  */

  depth = kinect.getRawDepth();
  println(2*kinect_width, 2*kinect_height);
  img = createImage(kinect_width, kinect_height, RGB);
    img.loadPixels();
    
    for (int x = 0; x < kinect_width; x++) {
      for (int y = 0; y < kinect_height; y++) {

        int offset = x + y * kinect_width;
        // Raw depth
        int rawDepth = depth[offset];
        int pix = x + y * kinect_width;
        if (rawDepth > 0 && rawDepth < threshold) {
          // A red color instead
          img.pixels[pix] = color(255);
        } else {
          img.pixels[pix] = color(0);
        }
      }
    }
    
    /*
img.updatePixels(); 
    int offset=0;
    int pix;
    for (int x = 0; x < 2*kinect_width-2; x+=2) {
      for (int y = 0; y < 2*kinect_height-2; y+=2) {
        pix = x + y * width;
        println(pix);
        int rawDepth = depth[offset];
        if (rawDepth > 0 && rawDepth < threshold) {
          // A red color instead
          img.pixels[pix] = color(255);
          
        }
       offset++; 
      }      
    } */ 
    
    
    img.updatePixels(); 
    //img.resize(width, height);

    //println(img.pixels.length);
        
  theBlobDetection.computeBlobs(img.pixels);
  
  noFill();
  int max_value = 0;
  int max_index = 0;
  Blob b;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if(b.getEdgeNb()>max_value){
      max_value = b.getEdgeNb();
      max_index = n;}
  }
    b=theBlobDetection.getBlob(max_index);
    surface = new Surface(b);
  // If the mouse is pressed, we make new particles
    if(frameCount%(100)==0){
      position_x = int(random(200,800));
      position_y = int(random(-50,0));}
    float sz = random(2,20);
    //println("position",position_x,position_y,sz);
    try {
     if(frameCount%(35)==0){
    particles.add(new Particle(position_x,position_y,sz));}
    }
    catch (NullPointerException e) {
    print("errpr");
  }
  

  // We must always step through time!
  box2d.step();
/*
  for(int i=0;i<pts.length;i++){
    pts[i].update();
  }*/

  // Draw the surface
  surface.display();
    try {  
      for (Particle p: particles) {
    p.display();
  }
    for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.done()) {
      particles.remove(i);
    }
  }
  surface.destroyBody();

    }
    catch (NullPointerException e) {
    print("errpr");
  }
}

void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();

  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
if (o1==null || o2==null){
  println("null");
     return;}
  // If object 1 is a Box, then object 2 must be a particle
  // Note we are ignoring particle on particle collisions
  if (o1.getClass() == Surface.class) {  
    Particle p = (Particle) o2;
    p.change();
  } 
  // If object 2 is a Box, then object 1 must be a particle
  else if (o2.getClass() == Surface.class) {
    Particle p = (Particle) o1;
    p.change();
  }
}


// Objects stop touching each other
void endContact(Contact cp) {
}
