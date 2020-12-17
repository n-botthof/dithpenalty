PImage img;

PImage[] dithered = new PImage[4];
// PImage[] mask = new PImage[4];
PGraphics[] masks = new PGraphics[4];

int graphHeight = 320;
int graphWidth = 200;

int factor = 1;

int endWidth = 200;
int endHeight = 320;

int layerCount = 4;

void setup() {
  noSmooth();
  size(200, 320);
  
  for (int j = 0; j < layerCount; j++) { 
    masks[j] = createGraphics((int)(graphWidth), (int)(graphHeight));
    graphHeight = graphHeight/2;
    graphWidth = graphWidth/2;
  }
  
  for (int i = 0; i < layerCount-1; i++) {
    masks[i].beginDraw();
    masks[i].background(0);
    masks[i].noStroke();
    masks[i].fill(255);
    for (int j = 0; j < 5; j++) { 
      float randWidth = random(20, 50);
      float randHeight = random(30, 80);
      float randX = random(masks[i].width/4 - randWidth/2, masks[i].width/4*3 - randWidth/2);
      float randY = random(masks[i].height/4 - randHeight/2, masks[i].height/4*3 - randHeight/2);
      masks[i].rect(randX, randY, randWidth, randHeight);
    }
    masks[i].endDraw();
    //image(masks[i], i*200, 0, 200, 320);
  }
  masks[3].beginDraw();
  masks[3].background(255);
  masks[3].endDraw();
  //image(masks[3], 3*200, 0, 200, 320);
  
  //for (int j = 0; j < 4; j++) {
  //  mask[j] = loadImage("mask" + j + ".png");
  //}

  for (int i = 0; i < layerCount; i++) {
    img = loadImage("Gang 320.png");
    img.resize(0, img.height/factor);
    img.filter(GRAY);
    img.loadPixels();
    for (int y = 0; y < img.height-1; y++) {
      for (int x = 0; x < img.width-1; x++) {
        color pix = img.pixels[index(x, y)];

        float oldR = red(pix);
        float oldG = green(pix);
        float oldB = blue(pix);

        int newR = round(oldR/255) * 255;
        int newG = round(oldG/255) * 255;
        int newB = round(oldB/255) * 255;
        img.pixels[index(x, y)] = color(newR, newG, newB);

        float errR = oldR - newR;
        float errG = oldG - newG;
        float errB = oldB - newB;

        passErr(x+1, y, errR, errG, errB, 7);
        passErr(x-1, y+1, errR, errG, errB, 3);
        passErr(x, y+1, errR, errG, errB, 5);
        passErr(x+1, y+1, errR, errG, errB, 1);
      }
      // sonderbehandlung für die Reihe ganz rechts
      color pix = img.pixels[index(img.width-1, y)];

      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);

      int newR = round(oldR/255) * 255;
      int newG = round(oldG/255) * 255;
      int newB = round(oldB/255) * 255;
      img.pixels[index(img.width-1, y)] = color(newR, newG, newB);

      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;

      passErr(img.width-1-1, y+1, errR, errG, errB, 3);
      passErr(img.width-1, y+1, errR, errG, errB, 5);
    }
    // sonderbehandlung für die Zeile ganz unten
    for (int x = 0; x < img.width-1; x++) {
      color pix = img.pixels[index(x, img.height-1)];

      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);

      int newR = round(oldR/255) * 255;
      int newG = round(oldG/255) * 255;
      int newB = round(oldB/255) * 255;
      img.pixels[index(x, img.height-1)] = color(newR, newG, newB);

      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;

      passErr(x+1, img.height-1, errR, errG, errB, 7);
    }
    color pix = img.pixels[index(img.width-1, img.height-1)];

    float oldR = red(pix);
    float oldG = green(pix);
    float oldB = blue(pix);

    int newR = round(oldR/255) * 255;
    int newG = round(oldG/255) * 255;
    int newB = round(oldB/255) * 255;
    img.pixels[index(img.width-1, img.height-1)] = color(newR, newG, newB);

    img.updatePixels();
    dithered[i] = img;
    dithered[i].mask(masks[i]);
    //image(dithered[i], i*endWidth, 0, endWidth, endHeight);
    factor *= 2;
  }
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

void draw() {
  int distanceFactor = 0;
  for (int i = layerCount-1; i>=0; --i) {
    image(dithered[i], 0, 0, endWidth, endHeight);
    distanceFactor = distanceFactor + 1;
    print(distanceFactor);
  }
  noLoop();
}
