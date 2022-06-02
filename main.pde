ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Pipe> pipes = new ArrayList<Pipe>();
ArrayList<Brain> brains = new ArrayList<Brain>();
ArrayList<Bird> Savedbirds = new ArrayList<Bird>();
ArrayList<Brain> Savedbrains = new ArrayList<Brain>();
float rate = 60; // frame rate

float weight[] = new float[6];
float biass[] = new float[6];
int birdSize = 300;          // population bird size
int score = 1;              // score
int gen = 1;                 // genertion
int maxScore = 0;          // max score
float mutateRate = 0.2;    // mutation rate

PImage backgroundImg;
PImage groundImg;
PImage wallImg;
PImage wallTopImg;
PImage wallBottomImg;
PImage birdImg;

void setup(){
  frameRate(rate);
  size(800,800);
  // setting images
  backgroundImg = loadImage("background.png");
  groundImg = loadImage("ground.png");
  wallImg = loadImage("wall.png");
  birdImg = loadImage("bird.png");
  
  pipes.add(new Pipe());
  for(int i=0;i<birdSize;i++){ // creating birds 
    birds.add(new Bird());
    Brain b;
    b = new Brain();
    b.initial();
    brains.add(b);
  }
}

void draw(){
  background(backgroundImg);
  translate(width/2,height/2);
  image(groundImg,-width/2, height/2-75);

  if(score % rate == 0){                                                      // Pipe appeares every score % rate(60) times
    if(pipes.size() >= 1)
      pipes.add(new Pipe());
  }
  
  for(int i=pipes.size()-1;i>=0;i--){ // move pipes
    pipes.get(i).show();
    pipes.get(i).update();
    if(pipes.get(i).offscreen()){
      pipes.remove(i);
    }
    
    for(Pipe p : pipes){
      for(int j=0;j<birds.size();j++){
        if(p.hit(birds.get(j)) || birds.get(j).y >= height/2 - 75 -16 || birds.get(j).y <= -height/2 - 16){      //Check bird boundary condition
          Savedbirds.add(birds.get(j));
          Savedbrains.add(brains.get(j));
          birds.remove(j);
          brains.remove(j); 
        }
      }
    }
  }
  
  for(int j = 0;j<birds.size();j++){
    float envStatus[] = new float[6];
    envStatus[0] = birds.get(j).retY() / height;                               //distance of bird to ground
    envStatus[1] = birds.get(j).vel;                                           //bird's velocity
    envStatus[2] = (237.5-birds.get(j).retY())/ height;                        //distance of bird to center
    
    Pipe p = returnNearestPipe(pipes,birds.get(j));                            //Find nearest pipe 
    envStatus[3] = p.x / width;                                                //pipe's x position
    envStatus[4] = (birds.get(j).retY() - ( -p.h + p.spacing)) / height;       //distance of bird to top pipe
    envStatus[5] = (birds.get(j).retY() - ( height/2 - p.h)) / height;         //distance of bird to bottom pipe

    float result = brains.get(j).predict(brains.get(j).coeffs,envStatus);       //Calculate the result of the neural network
    if(result > 0.5)
      birds.get(j).jump();
    
    birds.get(j).update();
    birds.get(j).score++;
    birds.get(j).show();
  }
  score++;
  if(birds.size() == 0){ // if all birds die
    Brain first = Savedbrains.get(Savedbrains.size()-1);                      //Best bird
    printArray(first.coeffs); // print weigths
    Brain second = Savedbrains.get(Savedbrains.size()-2);                     //Second best bird
    if(score > maxScore){
      maxScore = score; // check best score
    }
    score = 1;
    Savedbrains.clear();
    Savedbirds.clear();
    
    for(int i=0;i<birdSize;i++){
      Brain b = crossOver(first,second);                                  //crossOver
      b = mutate(b);                                                      //mutate 20% of the coeffs
      brains.add(b);
      birds.add(new Bird());
    }
    pipes.clear();
    pipes.add(new Pipe());
    
    gen++;
  } 
    PFont f = createFont("Arial", 16, true); // display of variables on the screen
    textFont(f, 40);
    fill(100, 100, 100);
    text("Gen: "+gen, -320, height/2-15);
    text("BestScore: "+(maxScore-60)/60, -120, height/2-15);
    text("Pop: "+birds.size(),180, height/2-15);
    text("Score: "+ (score-60)/60, -110, -height/2+50);
}

Pipe returnNearestPipe(ArrayList<Pipe> pipes,Bird birds){
  float dist = 999;
  float d = 0;
  Pipe closest = null;
    closest = pipes.get(0);
    for(Pipe p : pipes){
      d = p.x + 60 - birds.x; // distance value of the nearest pipe
      if(d < dist && d > 0){
        closest = p;
        dist = d;
      }
    }
  return closest;
}

Brain crossOver(Brain one, Brain two){
  float newWeight[] = new float[one.coeffs.length];
  int rand = (int) random(0,one.coeffs.length);                                           //Calculate a random number
    for(int i=0;i<one.coeffs.length;i++){
      if(rand < i){                                                                       //less than i
          newWeight[i] = two.coeffs[i];                                                  //Take weight 2    
      }
      else{
        newWeight[i] = one.coeffs[i];                                                     //Else weight 1
      }
    }
    Brain b = new Brain();
    b.coeffs = newWeight;
    
    return b;
}

Brain mutate(Brain b){
    for(int i=0;i<b.coeffs.length;i++){
      float rand = random(0,1);                                                     //Calculate random
      if(rand < mutateRate){  
        b.coeffs[i]*=random(1);                                                    //mutate by a random number
    }
  }
  return b;
}
