Cell[][] grid;
float l;
int Winner= 0;
final int YOU= 1;
final int AI= -YOU;
final int AIlevel= 10, yourLevel= 1;
final int firstTurn= YOU;

int turn= firstTurn;
boolean gameOver= false;
void setup() {
  size(500, 500); 
  grid= new Cell[3][3];
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  l= width/3;
  for (int x=0; x<3; x++) {
    for (int y=0; y<3; y++) {
      grid[x][y]= new Cell(x, y);
    }
  }
}
void draw() {
  background(0);
  stroke(255);
  strokeWeight(10);
  strokeCap(ROUND);
  noFill();
  for (int n=1; n<=2; n++) {
    line(l*n, 0, l*n, height);
    line(0, l*n, width, l*n);
  }
  if (Winner!=0) gameOver= true;
  if (!gameOver && turn==AI) runAImove();
  for (Cell[] ca : grid) {
    for (Cell c : ca) {
      c.show();
    }
  }
  if (tie()) gameOver= true;
  if (gameOver) {
    noStroke();
    if (Winner==1) fill(0, 255, 0, 150);
    else if (Winner==-1) fill(255, 0, 0, 150);
    else fill(0, 0, 255, 150);
    rect(width/2, height/2, width, height);
    textSize(l/2);
    fill(#FCFF55);
    String s= "";
    if (Winner==1) s= "You Wins";
    else if (Winner==-1) s= "AI Wins";
    else s= "! Tie !";
    text(s, width/2, height-l*1.5, width, l);
  }
}
ArrayList<Cell> choices() {
  ArrayList<Cell> choices= new ArrayList<Cell>();
  for (Cell[] ca : grid) {
    for (Cell c : ca) { 
      if (c.val==0) choices.add(int(random(0, choices.size()-1)), c);
    }
  }
  return choices;
}
int evaluateBoard() {
  for (int x=0; x<3; x++) {
    if (sum(grid[x][0], grid[x][1], grid[x][2])==3) return grid[x][0].val;
  }
  for (int y=0; y<3; y++) {
    if (sum(grid[0][y], grid[1][y], grid[2][y])==3) return grid[0][y].val;
  }
  if (sum(grid[0][0], grid[1][1], grid[2][2])==3) return grid[1][1].val;
  if (sum(grid[0][2], grid[1][1], grid[2][0])==3) return grid[1][1].val;

  return 0;
}
Cell randomMove(ArrayList<Cell> cells) {
  return cells.get(int(random(cells.size())));
}
Cell bestMoveByAI() {
  int bestScore= +10;
  int newScore;
  Cell currentMove= null;
  for (Cell c : choices()) {
    c.val= AI;
    newScore= minimax(AIlevel, true);
    c.val= 0;
    if (newScore < bestScore) {
      currentMove= c;
      bestScore= newScore;
    }
  }
  return currentMove;
}
Cell bestMoveByMe() {
  int bestScore= -10;
  int newScore;
  Cell currentMove= null;
  for (Cell c : choices()) {
    c.val= YOU;
    newScore= minimax(yourLevel, false);
    c.val= 0;
    if (newScore > bestScore) {
      currentMove= c;
      bestScore= newScore;
    }
  }
  return currentMove;
}
boolean tie() {
  for (Cell[] ca : grid) {
    for (Cell c : ca) {
      if (c.val==0) return false;
    }
  }
  return true;
}
int minimax(int depth, boolean isMaximizer) {
  int result= evaluateBoard();
  if (depth==0 || tie() || result!=0) {
    return result;
  }
  int bestScore= 0;
  if (isMaximizer) {
    bestScore= -100;
    for (Cell c : choices()) {
      c.val= YOU;
      bestScore= max(bestScore, minimax(depth-1, false));
      c.val= 0;
    }
  } else {
    bestScore= +100;
    for (Cell c : choices()) {
      c.val= AI;
      bestScore= min(bestScore, minimax(depth-1, true));
      c.val= 0;
    }
  }
  return bestScore;
}
void runAImove() {
  if (tie()) {
    gameOver= true;
    return;
  }
  Cell c= bestMoveByAI();
  c.val= AI;
  Winner= evaluateBoard();
  turn*=-1;
}

void mousePressed() {
  if (!gameOver) {
    if (turn==YOU) {
      int x= int(mouseX/l);
      int y= int(mouseY/l);
      Cell c= grid[x][y];
      //c= bestMoveByMe();
      if (c.val==0) {
        c.val= YOU;
        Winner= evaluateBoard();
        turn*=-1;
      }
    }
  } else {
    for (Cell[] ca : grid) {
      for (Cell c : ca) {
        c.val= 0;
      }
    }
    turn= Winner==0 ? firstTurn : Winner;
    Winner= 0;
    gameOver= false;
  }
}
