int[][][] arr=new int[3][100][70];
int curr=0,run=0,next=0;
int[] B={3},S={2,3};
void setup(){
   size(1000,700);
   frameRate(10);
   for(int i=0;i<70;i++)for(int j=0;j<100;j++){
     arr[0][j][i]=0;
     arr[1][j][i]=0;
     arr[2][j][i]=0;
   }
     for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(arr[curr][j][i]==1)fill(#FFFFFF);
      else fill(#030000);
      rect(j*10,i*10,10,10);
    }
}
void update(int curr){
  int i,j,k,vec,x,y,vool=0;
  int[][] exp={{-1,-1},{0,-1},{1,-1},{-1,0},{1,0},{-1,1},{0,1},{1,1}}; 
  for(i=0;i<70;i++)for(j=0;j<100;j++){
    vec=0;
    for(k=0;k<8;k++){
      x=j+exp[k][0];y=i+exp[k][1];
      if(x<100&&x>=0&&y<70&&y>=0)vec+=arr[curr][x][y];
    }
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
  }
}
void mousePressed(){
  if(mouseButton == LEFT){
    if(arr[curr][mouseX/10][mouseY/10]==1){
      arr[curr][mouseX/10][mouseY/10]=0;
      fill(#030202);
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
        fill(#030000);
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
       arr[0][j][i]=0;
       arr[1][j][i]=0;
       rect(j*10,i*10,10,10);
     }
     run=0;
  }
} 
void draw(){
  if(run==1||next==1){
    clear();
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(arr[curr][j][i]==0)fill(#030000);
      else fill(#FFFFFF);
      rect(j*10,i*10,10,10);
    }
    update(curr);
    curr=(curr+1)%2;
    next=0;
  }
}