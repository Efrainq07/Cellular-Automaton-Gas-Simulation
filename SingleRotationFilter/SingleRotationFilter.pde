int[][] arr=new int[100][72];
int count=0,w,colori=0;
int curr=0,run=0,next=0;
int[] vb={1,2,4,8};
int[] colorFreq={0,0,0,0,0,0,0,0,0};
//colorization matrix
float[] colormatrix={8.7,  0,      0,
                     0,    94.0,  -15.7,
                     0,    0,      68.0  };
//k value and gamma value
float kgb=0.99,gamma=0.2;

//filter variables for every cell
float[][][] xg=new float[2][100][72],yg=new float[2][100][72];
float[][][][] zg=new float[2][2][100][72];
int[][][] colorArr= new int[2][100][72];
//aux vector
float[] rgb={0,0,0};

void setup(){
   size(1000,700);
   frameRate(10);
   
   //array initialization
   for(int i=0;i<70;i++)for(int j=0;j<100;j++){
       arr[j][i]=0;
     
       colorArr[0][j][i]=0;
       colorArr[1][j][i]=0;
       xg[0][j][i]=0;
       xg[1][j][i]=0;
       yg[0][j][i]=0;
       yg[1][j][i]=0;
       zg[0][0][j][i]=0;
       zg[1][0][j][i]=0;
       zg[0][1][j][i]=0;
       zg[1][1][j][i]=0;
   }
   
   for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(arr[j][i]==1)fill(#FFFFFF);
      else fill(#030202);
      rect(j*10,i*10,10,10);
   }
   
}

//color filter evolution functions
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



void update(){
  int i,j,x,y,k,c=0,n=0;
  int[][] mov={{0,1},{1,1},{1,0},{0,0}};
  //update function for the Single Rotation rule (Margolus neighborhood included)
  for(y=0;y<70;y+=2)for(x=0;x<100;x+=2){
    j=x+count%2;
    i=y+count%2;
    c=0;
    c+=arr[j][i]*8;
    c+=arr[(j+1)%100][i]*4;
    c+=arr[(j+1)%100][(i+1)%70]*2;
    c+=arr[j][(i+1)%70];
    n=0;
    for(k=0;k<vb.length;k++)if(c==vb[k]){
      n=1;
      break;  
  }
    if(n==1){
      c=(c>>1)+((c%2)<<3);    
      arr[j][i]=0;
      arr[j][(i+1)%70]=0;
      arr[(j+1)%100][(i+1)%70]=0;
      arr[(j+1)%100][i]=0;
      for(k=0;k<4;k++){
        arr[(j+mov[k][0])%100][(i+mov[k][1])%70]=c%2;
        c/=2;
      }
    }
  }
  
  //iteration throught the whole array of cells
  for(y=0;y<70;y++)for(x=0;x<100;x++){
     //color filter
   float zmag,ymag,xmag,correction;
    
   //update the values of the vector rgb'=(x,y,z)
   xg[(curr+1)%2][x][y]     =    xev(    xg[curr][x][y],  arr[x][y]);
   yg[(curr+1)%2][x][y]     =    yev(    yg[curr][x][y],  arr[x][y]);
   zg[(curr+1)%2][0][x][y]  =    zevr(   zg[curr][0][x][y],  zg[curr][1][x][y],  arr[x][y]);
   zg[(curr+1)%2][1][x][y]  =    zevi(   zg[curr][0][x][y],  zg[curr][1][x][y],  arr[x][y]);
   
   //magnitudes of the components of the vector rgb'=(x,y,z)
   zmag    =    sqrt(   zg[(curr+1)%2][0][x][y]*zg[(curr+1)%2][0][x][y]  +  zg[(curr+1)%2][1][x][y]*zg[(curr+1)%2][1][x][y]  );
   ymag    =    abs(yg[(curr+1)%2][x][y]);
   xmag    =    xg[(curr+1)%2][x][y];
   
   //colorization matrix multiplication
   rgb[0]  =  xmag*colormatrix[0]  +  ymag*colormatrix[1]  +  zmag*colormatrix[2];
   rgb[1]  =  xmag*colormatrix[3]  +  ymag*colormatrix[4]  +  zmag*colormatrix[5];
   rgb[2]  =  xmag*colormatrix[6]  +  ymag*colormatrix[7]  +  zmag*colormatrix[8];
   
   //correction factor k_gamma calculation 
   correction  =  max(rgb[0],rgb[1],rgb[2]);
   if(correction<=0.0)         correction  =  0.0;
   else if(correction<=255.0)  correction  =  pow(correction*1.0/255.0,gamma-1.0);
   else                        correction  =  255.0/correction;
   
   //multiplication times the correction factor
   for(int ax=0;ax<3;ax++){
     rgb[ax]   =  correction*rgb[ax];
     if(rgb[ax]<0.0)          rgb[ax]   =  0.0;
     else if (rgb[ax]>255.0)  rgb[ax]   =  255.0;
   }
   
   //resulting color saved to colorArr
   colorArr[(curr+1)%2][x][y]  =  color(rgb[2],rgb[1],rgb[0]);
  }
  
}
void mousePressed(){
  if(mouseButton == LEFT){
    if(arr[mouseX/10][mouseY/10]==1){
      arr[mouseX/10][mouseY/10]=0;
      fill(#030202);
    }else{
      arr[mouseX/10][mouseY/10]=1;
      fill(#FFFFFF);
    }
    rect((mouseX/10)*10,(mouseY/10)*10,10,10);
  }
}
void mouseDragged(){
    if(mouseButton == LEFT){
      if(mouseX/10<100&&mouseX/10>=0&&mouseY/10<70&&mouseY/10>=0){
        arr[mouseX/10][mouseY/10]=1;
        fill(#FFFFFF);
        rect((mouseX/10)*10,(mouseY/10)*10,10,10);
      }
    }else if(mouseButton== RIGHT){
      if(mouseX/10<100&&mouseX/10>=0&&mouseY/10<70&&mouseY/10>=0){
        arr[mouseX/10][mouseY/10]=0;
        fill(#030202);
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
    fill(#030202);
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
       arr[j][i]=0;
       
       colorArr[0][j][i]=0;
       colorArr[1][j][i]=0;
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
void draw(){
  if(run==1||next==1){
    clear();
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(colori==0){
      if(arr[j][i]==1) fill(#FFFFFF);
      else fill(#000000);
      }else{
        if(arr[j][i]==1)fill(colorArr[curr][j][i]);
        else fill(#000000);
      }
      rect(j*10,i*10,10,10);
    }
    
    //Shannon entropy calculation
    for(int i=0;i<9;i++)colorFreq[i]=0;
    int vari=0;
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      vari=0;
      if(arr[j][i]==0)colorFreq[8]++;
      else{
        if(red(colorArr[curr][j][i])>255/2)vari+=1;
        if(blue(colorArr[curr][j][i])>255/2)vari+=2;
        if(green(colorArr[curr][j][i])>255/2)vari+=4;
        colorFreq[vari]+=1;
      }
    }
    float entropy=0.0;
    for(int i=0;i<9;i++)if(colorFreq[i]!=0)entropy-=(float)colorFreq[i]/(100.0*70.0)*log((float)colorFreq[i]/(100.0*70.0))/log(2.0);
    println(entropy*100);
    
    
    update();
    next=0;
    curr=(curr+1)%2;
    count++;
  }
}