class Brain{
  float w1 = 0;
  float w2 = 0;
  int inputNodes = 6;                                 //Number of nodes for the input 
  float coeffs[] = new float[inputNodes];
  float bias[] = new float[inputNodes];

  void initial(){                                     //Set the coeffs to random initially
    for(int i=0;i<inputNodes;i++){  
       coeffs[i] = random(-1,1);  
       bias[i] = random(-0.5,0.5);
    }  
  }
  
  float predict(float coeffs[],float envStatus[]){      //Prediction function based on the NN coeffs
    float result = 0;
    
    for(int i=0;i<inputNodes;i++){
      result += envStatus[i] * coeffs[i] + bias[i];
    }
    return activator(result);
  }
  
  float activator(float x){                             //sigmoid activation function
    return pow(1 + exp(-x),-1);
  }
}
