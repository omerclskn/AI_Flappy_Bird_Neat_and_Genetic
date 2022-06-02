class Pipe{
  float spacing = 150;                                            //spacing between the pipes
  float h = random(60, height/2);                                 // random h for random pipe spacing
  float x = width/2;
  float y = 0;
  float speed = 5;
  int birdWidth = 32;
  int birdHeight = 32;
  int recWidth = 60;
  
  void show(){
    image(wallImg,x,height/2-75,recWidth,-h);                                    //Draw bottom pipe
    image(wallImg,x,-height/2,recWidth,height/2 - h + spacing);                  //Draw top pipe
  }
  void update(){   
    x -= speed;                                                   //Change the speed every frame
  }
  boolean offscreen(){
    if(x < -width/2)                                              //Check if the pipe has gone offscreen
      return true;
    else
      return false;
  }
  boolean hit(Bird birds){
    float birdRight = birds.x + birdWidth/2; // bird and pipe position controls
    float birdLeft = birds.x - birdWidth/2;
    float pipeRight = x + recWidth;
    float pipeLeft = x;

    if((birdLeft <= pipeRight && birdRight >= pipeLeft ) || (pipeLeft <= birdRight && pipeRight >= birdLeft)){ 
      float birdUp = birds.y + birdHeight/2;
      float birdDown = birds.y - birdHeight/2;
      float pipeUp = - h + spacing;
      float pipeDown = height/2 - 75 - h;
      
      if(birdDown <= pipeUp || birdUp >= pipeDown){ // check if bird touch pipe
        return true;
      }
    }
    return false;
    
  }
}
