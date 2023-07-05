import g4p_controls.*;
int n = 70;
int cellMembrane[][];
boolean blood[][];
boolean protein[][];
boolean virus[][];
boolean deadBlood[][];
int numOfProtein[][];
float cellSize;
float virusSize;
int sightRadius = 2;
int m = 5*n;  //how many proteins can fit across one blood cell
float proteinSize;
float padding = 50;
float probOfCell = 0.2; // chance of blood cell being made 
float probOfDyingOne = 0.3; // chance of a virus dying when it finds only one protein
float probOfMultOne = 0.3; // chance of a virus replicating when it finds one protein
boolean pauseSim = true;


void setup() {
  size(800, 800);
  frameRate(1);
  createGUI();
  //rectMode(CENTER);
  cellSize =  (width + 30 * padding)/n;
  proteinSize = cellSize/6.25;
  virusSize = cellSize/2.5;
  blood = new boolean[n][n];
  protein = new boolean[m][m];
  virus = new boolean[n][n];
  numOfProtein = new int [n][n];
  deadBlood = new boolean[n][n];
  cellMembrane = new int[n][n];
  setCellValuesRandomly();
}


void draw() {
  //noLoop();
  background(139, 0, 0);
  for (int i=0; i<n; i++) {
    float y =  i*(cellSize) + padding;
    if (y < 0) {
      y += padding;
    }
    if (y > height) {
      y -= padding;
    }
    for (int j=0; j<n; j++) {
      float x = padding + j*cellSize;
      if (x < 0) {
        x += padding;
      }

      if (blood[i][j]) {
        stroke(0, 0, 255);
        strokeWeight(cellMembrane[i][j]);
        fill(255, 0, 0);
        rect(x, y, cellSize, cellSize);

        for (int s = 0; s < 5; s++) {    
          for (int t = 0; t < 5; t++) {      
            if (protein[i*5+t][j*5+s]) {
              float a = random(x+8, x+cellSize-8);                                
              float b = random(y+8, y+cellSize-8); 
              fill(255, 255, 0);
              strokeWeight(0.8);
              rect(a, b, proteinSize, proteinSize);
            }
          }
        }
      } else if (deadBlood[i][j]) {
        stroke(0, 0, 255);
        strokeWeight(cellMembrane[i][j]);          
        fill(128, 128, 128);          
        rect(x, y, cellSize, cellSize);
      } else if (virus[i][j]) { 

        fill(0, 255, 0);   
        strokeWeight(1);
        rect(x, y, virusSize, virusSize);
      }
    }
  }

  virusControl();
}



void setCellValuesRandomly() {
  for (int i=0; i<n; i++) {

    for (int j=0; j<n; j++) {      
      float x = random(0, 1);


      if (x < probOfCell) {
        blood[i][j] = true;
        cellMembrane[i][j] = 5;
        for (int s = 0; s < 5; s++) {
          for (int t = 0; t < 5; t++) {
            if (blood[i][j]) {
              int e = round(random(0, 6));
              if (e==0) {
                protein[i*5+t][j*5+s] = true;
                numOfProtein[i][j] ++;
              } else 
              protein[i*5+t][j*5+s] = false;
            }
          }
        }
      } else
        blood[i][j] = false;
    }
  }
} 
