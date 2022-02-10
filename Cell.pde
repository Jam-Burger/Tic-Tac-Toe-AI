class Cell {
  int x, y, val;
  PVector pos;
  Cell(int x_, int y_) {
    x= x_;
    y= y_;
    val= 0;
    pos= indexToPos(x, y);
  }
  void show() {
    if(val==0) return;
    pushMatrix();
    translate(pos.x, pos.y);
    noFill();
    if(val<0){
      line(-l/3, -l/3, l/3, l/3);
      line(-l/3, l/3, l/3, -l/3);
    }else ellipse(0, 0, l*.66, l*.66);
    
    popMatrix();
  }
}
int sum(Cell c1, Cell c2, Cell c3) {
  return abs(c1.val + c2.val + c3.val);
}
PVector indexToPos(int x, int y) {
  return new PVector(map(x, 0, 2, l/2, width-l/2), map(y, 0, 2, l/2, height-l/2));
}
