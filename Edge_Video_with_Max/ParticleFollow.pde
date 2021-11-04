class ParticleFollow{
  
  PVector prevPos;
  PVector pos;
  PVector vel;
  
  float exponent=random(-1,1);
  float factor=random(0.3, 1.5);
  
  color col;
  
  ParticleFollow(){
    
    pos=new PVector(random(width),random(height));
    prevPos=pos.copy();
    
    vel=new PVector(0,0);
   
    //col=color(44*(exponent+1),117*(exponent+1),255,30);
    if(random(1)>0.5){
    col=color(random(20,88),random(100,200),200,random(30,50));}
    else{
      col = color(random(0,20),random(20,40),30,random(30,50));}
  }
  
  void update(){
    
    float d2m = PVector.dist(pos,mouse);
    d2m*=0.01;
    
    PVector dist_acc=PVector.sub(mouse,pos);
    //acc.mult(pow(d2m,exponent)*factor*0.001);
    dist_acc.mult(factor*0.001);    
    vel.add(dist_acc);
    
    float ns=0.03;
    float noise_x=noise(pos.x*ns,pos.y*ns,frameCount*0.01)-0.5;
    float noise_y=noise(pos.x*ns,pos.y*ns+9999,frameCount*0.01)-0.5;
    PVector noise_acc=new PVector(noise_x,noise_y);    
    noise_acc.mult(2);
    vel.add(noise_acc);
    
    
    //float friction=noise(pos.x*0.05+999,pos.y*0.05+999,frameCount*0.01)-0.5;
    //friction*=0.0033;
    //friction+=0.95;
    
    //vel.mult(friction);
    vel.mult(0.95);
  
    
    prevPos=pos.copy();
    prevPos.add(PVector.div(vel,3));
    pos.add(vel);
 
    
    stroke(col);
 
    line(pos.x,pos.y,prevPos.x,prevPos.y);
    
  }
}
    
  
