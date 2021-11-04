void play_music(int type){
  println("play");
  if(type==0){
    myOscMessage.add(100);}
  else if(type==5){
    myOscMessage.add(200);}
  else if(((type<5)&(type>1))|((type<8)&(type>5))){
    myOscMessage.add(300);}
  else if((type<10)&(type>7)){
    myOscMessage.add(400);}
    oscP5.send(myOscMessage, myBroadcastLocation);
}
