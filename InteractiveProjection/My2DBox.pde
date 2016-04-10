class My2DBox {
  My2DPoint[] s;
  
  My2DBox(My2DPoint[] s) {
    this.s = s; 
  }
  
  void render(){
    strokeWeight(4);
    stroke(0, 255, 0);
    for (int i = 0 ; i < 4 ; ++i)
      line(s[i+4].x, s[i+4].y, s[(i+1)%4+4].x, s[(i+1)%4+4].y);
    stroke(0, 0, 255);
    for (int i = 0 ; i < 4 ; ++i)
      line(s[i].x, s[i].y, s[i+4].x, s[i+4].y);
    stroke(255, 0, 0);
    for (int i = 0 ; i < 4 ; ++i)
      line(s[i].x, s[i].y, s[(i+1)%4].x, s[(i+1)%4].y);
  } 
}