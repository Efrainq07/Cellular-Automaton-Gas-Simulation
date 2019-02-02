int[][] arr=new int[100][72];
int count=0,w;
int curr=0,run=0,next=0;
int[] vb={1,2,4,8};
void setup(){
   size(1000,700);
   frameRate(20);
   for(int i=0;i<70;i++)for(int j=0;j<100;j++)arr[j][i]=0;
     for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(arr[j][i]==1)fill(#FFFFFF);
      else fill(#030202);
      rect(j*10,i*10,10,10);
    }
}
void update(){
  int i,j,x,y,k,c=0,n=0;
  int[][] mov={{0,1},{1,1},{1,0},{0,0}};
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
       rect(j*10,i*10,10,10);
     }
     run=0;
  }
} 
void draw(){
  if(run==1||next==1){
    clear();
    for(int i=0;i<70;i++)for(int j=0;j<100;j++){
      if(arr[j][i]==1)fill(#FFFFFF);
      else fill(#030202);
      rect(j*10,i*10,10,10);
    }
    update();
    next=0;
    count++;
  }
}