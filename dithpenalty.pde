int layerCount = 4;
PImage img;

PImage[] dithered = new PImage[layerCount];

int graphWidth = 200;
int graphHeight = 320;

int divisor = 1;

int endWidth = 200*2;
int endHeight = 320*2;

////////////////////

int maskCount = 4;
int rectCount = 5;
int visibleRectangles[] = {0, 0, 0, 0};
int expansion = 2;

PGraphics[] masks = new PGraphics[maskCount];

Rectangle[][] maskingRectangles = new Rectangle[maskCount][rectCount];



void setup() {
  noSmooth();
  frameRate(15);
  size(400, 640);

  for (int i = 0; i < maskCount; i++) { 
    masks[i] = createGraphics((int)(graphWidth), (int)(graphHeight));
    
    for (int rects = 0; rects < rectCount; ++rects) {
      int randWidth = round(random(30, 45));
      int randHeight = round(random(25, 65));

      maskingRectangles[i][rects] = new Rectangle(0, 0, randWidth, randHeight);
    }
    graphWidth = graphWidth/2;
    graphHeight = graphHeight/2;
  }

  for (int i = 0; i < layerCount; i++) {
    img = loadImage("Gang 320.png");
    img.resize(0, img.height/divisor);
    img.filter(GRAY);
    img.loadPixels();
    for (int y = 0; y < img.height-1; y++) {
      for (int x = 0; x < img.width-1; x++) {
        color pix = img.pixels[index(x, y)];
        
        color threshold = getThreshold(pix);
        img.pixels[index(x, y)] = threshold;

        Color err = getError(pix, threshold);

        passErr(x+1, y, err.r, err.g, err.b, 7);
        passErr(x-1, y+1, err.r, err.g, err.b, 3);
        passErr(x, y+1, err.r, err.g, err.b, 5);
        passErr(x+1, y+1, err.r, err.g, err.b, 1);
      }
      
      // sonderbehandlung für die Reihe ganz rechts
      int x = img.width-1;
      color pix = img.pixels[index(x, y)];
      
      color threshold = getThreshold(pix);
      img.pixels[index(x, y)] = threshold;

      Color err = getError(pix, threshold);

      passErr(x-1, y+1, err.r, err.g, err.b, 3);
      passErr(x, y+1, err.r, err.g, err.b, 5);
    }
    
    // sonderbehandlung für die Zeile ganz unten
    for (int x = 0, y = img.height-1; x < img.width-1; x++) {
      color pix = img.pixels[index(x, y)];

      color threshold = getThreshold(pix);
      img.pixels[index(x, y)] = threshold;

      Color err = getError(pix, threshold);

      passErr(x+1, y, err.r, err.g, err.b, 7);
    }
    int x = img.width-1;
    int y = img.height-1;
    color pix = img.pixels[index(x, y)];

    color threshold = getThreshold(pix);
    img.pixels[index(x, y)] = threshold;

    img.updatePixels();
    dithered[i] = img;
    divisor *= 2;
  }
}


void draw() {
  
  for (int i = 0; i < maskCount-1; i++) {
    masks[i].beginDraw();
    masks[i].background(0);
    masks[i].noStroke();
    masks[i].fill(255);
    for (int rects = 0; rects < rectCount; rects++) { 
      step(maskingRectangles[i][rects], masks[i].width, masks[i].height, 50*(i+1)*(rects+1));
      maskingRectangles[i][rects].draw(masks[i]);
    }
    masks[i].endDraw();
  }
  masks[3].beginDraw();
  masks[3].background(255);
  masks[3].endDraw();
  
  int distanceFactor = 0;
  for (int i = layerCount-1; i>=0; --i) {
    dithered[i].mask(masks[i]);
    image(dithered[i], 0, 0, endWidth, endHeight);
    distanceFactor = distanceFactor + 1;
  }
  
  //if(frameCount < 150) {
  //  saveFrame("output/dithpenalty_####.png");
  //}
  //else {
  //  exit();
  //}
}


void step(Rectangle rectangle, int maskWidth, int maskHeight, int offset) {
  float px, py, t;
  int nx, ny, currStep;
  int nSteps = 150;
  int radius = 10;
  float myScale = 0.2;
  
  currStep = frameCount%nSteps;
  t = map(currStep, 0, nSteps, 0, TWO_PI); 

  px = offset + radius * cos(t);
  py = offset +50 + radius * sin(t);

  nx = round(map(noise(myScale*px, myScale*py), 0, 1, 0-(rectangle.width/2), maskWidth-(rectangle.width/2)));
  ny = round(map(noise(myScale*px+1000, myScale*py+1000), 0, 1, 0-(rectangle.height/2), maskHeight-(rectangle.height/2)));
  
  
  rectangle.x = nx;
  rectangle.y = ny;
}



int index(int x, int y) {
  return x + y * img.width;
}

void passErr(int x, int y, float errR, float errG, float errB, int fractor) {
  int index = index(x, y);
  color c = img.pixels[index];
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  r = r + errR * fractor/16.0;
  g = g + errG * fractor/16.0;
  b = b + errB * fractor/16.0;
  img.pixels[index] = color(r, g, b);
}

color getThreshold(color pix) {
  return color (
    round(red(pix)/255) * 255, 
    round(green(pix)/255) * 255, 
    round(blue(pix)/255) * 255
    );
}

Color getError(color oldColor, color newColor) {
  return new Color(
    red(oldColor) - red(newColor), 
    green(oldColor) - green(newColor), 
    blue(oldColor) - blue(newColor)
  );
}
