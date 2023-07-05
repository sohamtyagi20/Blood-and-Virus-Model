void mouseClicked() {  
  int col = int((mouseX - padding)/cellSize);  
  int row = int((mouseY - padding)/cellSize);  
  virus[row][col] = true;
}

void virusControl() {
  for (int i=0; i<n; i++) {    
    for (int j=0; j<n; j++) {
      if (virus[i][j]) {
        moveVirus(i, j);
      }
    }
  }
}

void moveVirus(int i, int j) {
  int [] nearestBloddCoord = new int[2];  
  nearestBloddCoord = findNearestBloodCell(i, j);
  if (nearestBloddCoord != null) {
    if (abs(nearestBloddCoord[0] - i) <= 1 && abs(nearestBloddCoord[1] - j) <= 1) {       
      int iValue = 0;      
      int jValue = 0;      
      if (i > nearestBloddCoord[0] && j > nearestBloddCoord[1]) {        
        iValue = i - 1;        
        jValue = j - 1;         
        infectVirus(iValue, jValue, i, j);
      } else if (i > nearestBloddCoord[0] && j < nearestBloddCoord[1]) {        
        iValue = i - 1;        
        jValue = j + 1;         
        infectVirus(iValue, jValue, i, j);
      } else if (i < nearestBloddCoord[0] && j > nearestBloddCoord[1]) {        
        iValue = i + 1;        
        jValue = j - 1;         
        infectVirus(iValue, jValue, i, j);
      } else if (i < nearestBloddCoord[0] && j < nearestBloddCoord[1]) {        
        iValue = i + 1;        
        jValue = j + 1;         
        infectVirus(iValue, jValue, i, j);
      } else if (i > nearestBloddCoord[0]) {        
        iValue = i - 1;        
        jValue = j;         
        infectVirus(iValue, jValue, i, j);
      } else if (i < nearestBloddCoord[0]) {        
        iValue = i + 1;        
        jValue = j;         
        infectVirus(iValue, jValue, i, j);
      } else if (j > nearestBloddCoord[1]) {        
        iValue = i;        
        jValue = j - 1;         
        infectVirus(iValue, jValue, i, j);
      } else if (j < nearestBloddCoord[1]) {        
        iValue = i;        
        jValue = j + 1;         
        infectVirus(iValue, jValue, i, j);
      }
    } else {
      int iValue = 0;      
      int jValue = 0;      
      if (i > nearestBloddCoord[0] && j > nearestBloddCoord[1]) {          
        iValue = i - 1;        
        jValue = j - 1;        
        headTowardsBloodCell(iValue, jValue, i, j);
      } else if (i > nearestBloddCoord[0] && j < nearestBloddCoord[1]) {         
        iValue = i - 1;        
        jValue = j + 1;        
        headTowardsBloodCell(iValue, jValue, i, j);
      } else if (i < nearestBloddCoord[0] && j > nearestBloddCoord[1]) {         
        iValue = i + 1;        
        jValue = j - 1;        
        headTowardsBloodCell(iValue, jValue, i, j);
      } else if (i < nearestBloddCoord[0] && j < nearestBloddCoord[1]) {         
        iValue = i + 1;        
        jValue = j + 1;        
        headTowardsBloodCell(iValue, jValue, i, j);
      } else if (i > nearestBloddCoord[0]) {         
        iValue = i - 1;        
        jValue = j;        
        headTowardsBloodCell(iValue, jValue, i, j);
      } else if (i < nearestBloddCoord[0]) {        
        iValue = i + 1;        
        jValue = j;        
        headTowardsBloodCell(iValue, jValue, i, j);
      } else if (j > nearestBloddCoord[1]) {         
        iValue = i;        
        jValue = j - 1;        
        headTowardsBloodCell(iValue, jValue, i, j);
      } else if (j < nearestBloddCoord[1]) {         
        iValue = i;        
        jValue = j + 1;        
        headTowardsBloodCell(iValue, jValue, i, j);
      }
    }
  } else {
    moveRand(i, j);
  }
}

void moveRand(int i, int j) {

  int nextRandI = round(random(-2, 2));   
  int nextRandJ = round(random(-2, 2));
  try {
    if (virus[i][j] && !virus[i+nextRandI][j+nextRandJ] && !blood[i+nextRandI][j+nextRandJ]) {
      virus[i][j] = false;
      virus[i+nextRandI][j+nextRandJ] = true;
    } else 
    virus[i][j] = true;
  }
  catch(Exception e) {
    virus[i][j] = true;
  }
}


int[] findNearestBloodCell(int row, int col) {
  int[] nearestBloodCell = new int [2];
  int minDist = 11;
  int dist = 11;
  for (int a = -sightRadius; a < sightRadius; a++) {
    for (int b = -sightRadius; b < sightRadius; b++) {
      try {
        if (blood[row + a][col + b] && (a != 0 || b != 0)) {
          if (a == 0 && b != 0)
            dist = abs(b) - 1;
          else if ( a != 0 && b == 0) { 
            dist = abs(a) - 1;
          } else {       
            dist = abs(a);
          }
          if (dist < minDist) {             
            minDist = dist;     
            nearestBloodCell[0] = row + a;            
            nearestBloodCell[1] = col + b;
          }
        }
      }
      catch (Exception e) {
      }
    }
  }
  if (minDist > 10)   
    return null;
  return nearestBloodCell;
}

void headTowardsBloodCell(int iValue, int jValue, int i, int j) {  
  if (!virus[iValue][jValue]) {
    virus[i][j] = false;    
    virus[iValue][jValue] = true;
  } else
    moveRand(i, j);
}

void infectVirus(int iValue, int jValue, int i, int j) {
  if (blood[iValue][jValue]) {

    int mult = int(random(0, numOfProtein[iValue][jValue])); // randomly determines how many copies of the virus are made
    float chanceOfDying = random(0, 1);
    float chanceOfMult = random(0, 1);
    if (numOfProtein[iValue][jValue] == 0 ) {
      virus[i][j] = false;
    } else if (numOfProtein[iValue][jValue] == 1) {
      if ( chanceOfDying < probOfDyingOne) {
        virus[i][j] = false;
      } else {

        for (int s = 0; s < 5; s++) {            
          for (int t = 0; t < 5; t++) {
            protein[iValue*5+t][jValue*5+s] = false;
          }
        }
        cellMembrane[iValue][jValue] -= 4;
        for (int f = 0; f < mult; f++) {
          virus[iValue+f][jValue+f] = true;
        }
        blood[iValue][jValue] = false;
        deadBlood[iValue][jValue] = true;
        if (chanceOfMult < probOfMultOne) {
          for (int f = 0; f < 1; f++) {
            virus[iValue+f][jValue+f] = true;
          }
        }
      }
    } else if (numOfProtein[iValue][jValue] > 1) {
      for (int s = 0; s < 5; s++) {            
        for (int t = 0; t < 5; t++) {
          protein[iValue*5+t][jValue*5+s] = false;
        }
      }       
      cellMembrane[iValue][jValue] -= 4;
      for (int f = 0; f < mult; f++) {
        virus[iValue+f][jValue+f] = true;
      }
      blood[iValue][jValue] = false;
      deadBlood[iValue][jValue] = true;
      redraw();
    }
  }
}
