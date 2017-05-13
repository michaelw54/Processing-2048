public class Grid {
  Block[][] block;
  private final int COLS;
  private final int ROWS;
  private int score;
  
  public Grid(int cols, int rows) {
    COLS = cols;
    ROWS = rows;
    block = new Block[COLS][ROWS];
    initBlocks();  // initializes all blocks to empty blocks
  }
    
  public Block getBlock(int col, int row) {
    return block[col][row];
  }
  
  public void setBlock(int col, int row, int value, boolean changed) {
    block[col][row] = new Block(value, changed);
  }
  
  public void setBlock(int col, int row, int value) {
    setBlock(col, row, value, false);
  }
  
  public void setBlock(int col, int row) {
    setBlock(col, row, 0, false);
  }
  
  public void setBlock(int col, int row, Block b) {
    block[col][row] = b;
  }
  
  public void initBlocks() {
    for (int col = 0; col < COLS; col++){
      for (int row = 0; row < ROWS; row++){
          block[col][row] = new Block();
      }
    }
  }
  
  public boolean isValid(int col, int row) {
    if (col >= 0 && col < COLS && row >= 0 && row < ROWS){
      return true;  
    }
    return false; // stub
  }
  
  public void swap(int col1, int row1, int col2, int row2) {
    int b2Value = getBlock(col2, row2).getValue();
    getBlock(col2, row2).setValue(getBlock(col1, row1).getValue());
    getBlock(col1, row1).setValue(b2Value);
  }
  
  public boolean canMerge(int col1, int row1, int col2, int row2) {
    if (getBlock(col1, row1).getValue() == getBlock(col2, row2).getValue()){
      return true;
    }
    return false; // stub
  }
  
  public void clearChangedFlags() {
    for(int col = 0; col < COLS; col++) {
      for(int row = 0; row < ROWS; row++) {
        block[col][row].setChanged(false);
      }
    }
  }
 
  // Is there an open space on the grid to place a new block?
  public boolean canPlaceBlock() {
    if (getEmptyLocations().size() > 0){
      return true;
    }
    return false; // stub
  }
  
  public ArrayList<Location> getEmptyLocations() {
    ArrayList<Location> locs = new ArrayList<Location>();
    for (int col = 0; col < COLS; col++){
      for (int row = 0; row < ROWS; row++){
        if (getBlock(col, row).getValue() ==  0) locs.add(new Location(col, row));
      }
    }
    return locs;
  }
  
  public Location selectLocation(ArrayList<Location> locs) {
    int randSelect = (int) (Math.random() * locs.size());
    return locs.get(randSelect); // stub
  }
  
  // Randomly select an open location to place a block.
  public void placeBlock() {
    Location whereToPlace = selectLocation(getEmptyLocations());
    int value;
    int valuePicker = (int) (Math.random() * 8);
    
    if (valuePicker < 2) {
      value = 4;
    }
    else value = 2;
    
    setBlock(whereToPlace.getCol(), whereToPlace.getRow(), value, true);
  }
  
  // Are there any adjacent blocks that contain the same value?

  public boolean hasCombinableNeighbors() {
    for(int col = 0; col < COLS-1; col++){
      for (int row = 0; row < ROWS-1; row++){
        if (canMerge(col, row, col, row + 1) || canMerge(col , row, col + 1, row)) return true; //check to the right and to the bottom of each block -- covers the whole board
      }
    }
    return false; 
  }
   
  // Notice how an enum can be used as a data type
  //
  // This is called ) method  the KeyEvents tab
  public boolean someBlockCanMoveInDirection(DIR dir) {
    int upOrDown = 0;
    int direction = 0;
    
      if (dir == DIR.WEST) {
        direction = -1; //left
        upOrDown = 0;
      }
      else if (dir == DIR.EAST) {
        direction = 1; //right
        upOrDown = 0;
      }
      else if (dir == DIR.NORTH) {
        direction = 1; //up
        upOrDown = 1;
      }
      else if (dir == DIR.SOUTH) {
        direction = -1; //down
        upOrDown = -1;
      }
    
    for (int col=0; col < COLS; col++){
      for (int row=0; row < ROWS; row++){
          if (upOrDown != 0){
            if (col + direction >= 0 && col + direction < COLS){
              if (getBlock(col, row).getValue() != 0 && ((getBlock(col + direction, row).getValue() == 0 || getBlock(col + direction, row).getValue() == getBlock(col, row).getValue()))) return true;
            }
          }
          else if (upOrDown == 0){
            if (row + direction >= 0 && row + direction < ROWS){
              if (getBlock(col, row).getValue() != 0 && ((getBlock(col, row + direction).getValue() == 0 || getBlock(col, row + direction).getValue() == getBlock(col, row).getValue()))) return true;
            }
          }
      }
    }
    return false; // stub
  }
  
  // Computes the number of points that the player has scored
  public void computeScore() {
    int thisMoveScore = 0;
    for (int col=0; col < COLS; col++){
      for (int row=0; row < ROWS; row++){
        thisMoveScore += getBlock(col, row).getValue();
      }
    }
    score = thisMoveScore;
  }
  
  public int getScore() {
    return score;
  }
  
  public void showScore() {
      textFont(scoreFont);
      fill(#000000);
      text("Score: " + getScore(), width/2, SCORE_Y_OFFSET);
      textFont(blockFont);
  }
  
  public void showBlocks() {
    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        Block b = block[col][row];
        if (!b.isEmpty()) {
          float adjustment = (log(b.getValue()) / log(2)) - 1;
          fill(color(242 , 241 - 8*adjustment, 239 - 8*adjustment));
          rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
          fill(color(108, 122, 137));
          text(str(b.getValue()), GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col + BLOCK_SIZE/2, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row + BLOCK_SIZE/2 - Y_TEXT_OFFSET);
        } else {
          fill(BLANK_COLOR);
          rect(GRID_X_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*col, GRID_Y_OFFSET + (BLOCK_SIZE + BLOCK_MARGIN)*row, BLOCK_SIZE, BLOCK_SIZE, BLOCK_RADIUS);
        }
      }
    }
  }
  
  // Copy the contents of another grid to this one
  public void gridCopy(Grid other) {
    for (int col = 0; col < COLS; col++){
      for (int row = 0; row < ROWS; row++){
        setBlock(col, row, other.getBlock(col, row));
      }
    }
  }
  
  public boolean isGameOver() {
    //if (someBlockCanMoveInDirection(DIR.NORTH) || someBlockCanMoveInDirection(DIR.SOUTH) || someBlockCanMoveInDirection(DIR.EAST) || someBlockCanMoveInDirection(DIR.WEST)){
    //  return false;
    //}
    //return true; // stub
    if (!(hasCombinableNeighbors() || canPlaceBlock())) return true;
    return false;
  }
  
  public void showGameOver() {
    fill(#0000BB);
    text("GAME OVER", GRID_X_OFFSET + 2*BLOCK_SIZE + 15, GRID_Y_OFFSET + 2*BLOCK_SIZE + 15);
  }
  
  //public String toString() {
  //  String str = "";
  //  for (int row = 0; row < ROWS; row++) {
  //    for (int col = 0; col < COLS; col++) {
  //      str += block[col][row].getValue() + " ";
  //    }
  //    str += "\n";   // "\n" is a newline character
  //  }
  //  return str;
  //}
}