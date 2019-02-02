int[][][] arr=new int[5][100][70];
int curr=0,run=0,next=0,colori=1;
int[] B={3,4,6,7,8},S={3,6,7,8};        //CA Rule in B/S format
                              //Game of life B3/S23;  Morley B368/245; 34 Life B34/S34
                              
//colorization matrix
float[] colormatrix={8.7,  0,      0,
                     0,    94.0,  -15.7,
                     0,    0,      68.0  };
//k value and gamma value
float kgb=0.99,gamma=0.2;

//filter variables for every cell
float[][][] xg=new float[2][100][70],yg=new float[2][100][70];
float[][][][] zg=new float[2][2][100][70];
int[] colorFreq={0,0,0,0,0,0,0,0,0};
//aux vector
float[] rgb={0,0,0};

void setup(){
   size(1000,700);
   frameRate(10);
   //initialization
   for(int i=0;i<70;i++)for(int j=0;j<100;j++){
     arr[0][j][i]=0;
     arr[1][j][i]=0;
     arr[2][j][i]=0;
     arr[3][j][i]=0;
     arr[4][j][i]=0;
     
     xg[0][j][i]=0;
     xg[1][j][i]=0;
     yg[0][j][i]=0;
     yg[1][j][i]=0;
     zg[0][0][j][i]=0;
     zg[1][0][j][i]=0;
     zg[0][1][j][i]=0;
     zg[1][1][j][i]=0;
   }
   
   //initial drawing
     for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(arr[curr][j][i]==1)fill(#FFFFFF);
      else fill(#000000);
      rect(j*10,i*10,10,10);
    }
}

//color filters
float xev(float x, int s){
  return kgb*x+(float)s;
}
float yev(float y,int s){
  return -kgb*y+(float)s;
}
float zevr(float zr,float zi, int s){
  return -zi*kgb+(float)s;
}
float zevi(float zr,float zi, int s){
  return zr*kgb;
}

//update function
void update(int curr){
  int i,j,k,vec,x,y,vool=0;  //counters
  int[][] exp={{-1,-1},{0,-1},{1,-1},{-1,0},{1,0},{-1,1},{0,1},{1,1}}; //neighbors
  
  //iteration through the whole lattice
  for(i=0;i<70;i++)for(j=0;j<100;j++){
    
    //alive neighbor counter
    vec=0;
    for(k=0;k<8;k++){
      x=j+exp[k][0];y=i+exp[k][1];
      if(x<100&&x>=0&&y<70&&y>=0)vec+=arr[curr][x][y];
    }
    
    //rule applier
    vool=0;
    if(arr[curr][j][i]==0){
      for(k=0;k<B.length;k++)if(vec==B[k])vool=1;
      if(vool==1)arr[(curr+1)%2][j][i]=1;
      else arr[(curr+1)%2][j][i]=0;
    }else{
      for(k=0;k<S.length;k++)if(vec==S[k])vool=1;
      if(vool==1)arr[(curr+1)%2][j][i]=1;
      else arr[(curr+1)%2][j][i]=0;
    }
    
   //color filter
   float zmag,ymag,xmag,correction;
    
   xg[(curr+1)%2][j][i]     =    xev(    xg[curr][j][i],  arr[curr][j][i]);
   yg[(curr+1)%2][j][i]     =    yev(    yg[curr][j][i],  arr[curr][j][i]);
   zg[(curr+1)%2][0][j][i]  =    zevr(   zg[curr][0][j][i],  zg[curr][1][j][i],  arr[curr][j][i]);
   zg[(curr+1)%2][1][j][i]  =    zevi(   zg[curr][0][j][i],  zg[curr][1][j][i],  arr[curr][j][i]);
   
   zmag    =    sqrt(   zg[(curr+1)%2][0][j][i]*zg[(curr+1)%2][0][j][i]  +  zg[(curr+1)%2][1][j][i]*zg[(curr+1)%2][1][j][i]  );
   ymag    =    abs(yg[(curr+1)%2][j][i]);
   xmag    =    xg[(curr+1)%2][j][i];
   rgb[0]  =  xmag*colormatrix[0]  +  ymag*colormatrix[1]  +  zmag*colormatrix[2];
   rgb[1]  =  xmag*colormatrix[3]  +  ymag*colormatrix[4]  +  zmag*colormatrix[5];
   rgb[2]  =  xmag*colormatrix[6]  +  ymag*colormatrix[7]  +  zmag*colormatrix[8];
   
   correction  =  max(rgb[0],rgb[1],rgb[2]);
   if(correction<=0.0)         correction  =  0.0;
   else if(correction<=255.0)  correction  =  pow(correction*1.0/255.0,gamma-1.0);
   else                        correction  =  255.0/correction;
   
   for(int vb=0;vb<3;vb++){
     rgb[vb]   =  correction*rgb[vb];
     if(rgb[vb]<0.0)          rgb[vb]   =  0.0;
     else if (rgb[vb]>255.0)  rgb[vb]   =  255.0;
   }
   arr[(curr+1)%2+3][j][i]  =  color(rgb[2],rgb[1],rgb[0]);
   
  }
}
void mousePressed(){
  if(mouseButton == LEFT){
    if(arr[curr][mouseX/10][mouseY/10]==1){
      arr[curr][mouseX/10][mouseY/10]=0;
      fill(#000000);
    }else{
      arr[curr][mouseX/10][mouseY/10]=1;
      fill(#FFFFFF);
    }
    rect((mouseX/10)*10,(mouseY/10)*10,10,10);
  }
}
void mouseDragged(){
    if(mouseButton == LEFT){
      if(mouseX/10<100&&mouseX/10>=0&&mouseY/10<70&&mouseY/10>=0){
        arr[curr][mouseX/10][mouseY/10]=1;
        fill(#FFFFFF);
        rect((mouseX/10)*10,(mouseY/10)*10,10,10);
      }
    }else if(mouseButton==RIGHT){
      if(mouseX/10<100&&mouseX/10>=0&&mouseY/10<70&&mouseY/10>=0){
        arr[curr][mouseX/10][mouseY/10]=0;
        fill(#000000);
        rect((mouseX/10)*10,(mouseY/10)*10,10,10);
      }
    }
}
void keyPressed(){
  if(key=='r'){
    if(run==0)run=1;
    else run=0;
  }
  if(key=='n'){
    next=1;
  }
  if(key=='\n'){
    fill(#000000);
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
       arr[0][j][i]=0;
       arr[1][j][i]=0;
       arr[4][j][i]=0;
       arr[3][j][i]=0;
       xg[0][j][i]=0;
       xg[1][j][i]=0;
       yg[0][j][i]=0;
       yg[1][j][i]=0;
       zg[0][0][j][i]=0;
       zg[1][0][j][i]=0;
       zg[0][1][j][i]=0;
       zg[1][1][j][i]=0;
       rect(j*10,i*10,10,10);
     }
     run=0;
  }
  if(key=='c'){
    if(colori==0)colori=1;
    else colori=0;
  }
} 

//main loop
void draw(){
  if(run==1||next==1){
    clear();
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(colori==0){
      if(arr[curr][j][i]==0)fill(#000000);
      else fill(#FFFFFF);
      }else{
        if(arr[curr][j][i]==0)fill(#000000);
        else fill(arr[curr+3][j][i]);
      };
      rect(j*10,i*10,10,10);
    }
    
     //Shannon entropy calculation
    for(int i=0;i<9;i++)colorFreq[i]=0;
    int vari=0;
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      vari=0;
      if(arr[curr][j][i]==0)colorFreq[8]++;
      else{
        if(red(arr[curr+3][j][i])>255/2)vari+=1;
        if(blue(arr[curr+3][j][i])>255/2)vari+=2;
        if(green(arr[curr+3][j][i])>255/2)vari+=4;
        colorFreq[vari]+=1;
      }
    }
    float entropy=0.0;
    for(int i=0;i<9;i++)if(colorFreq[i]!=0)entropy-=(float)colorFreq[i]/(100.0*70.0)*log((float)colorFreq[i]/(100.0*70.0))/log(2.0);
    println(entropy*100);
    
    
    update(curr);
    curr=(curr+1)%2;
    next=0;
  }
}