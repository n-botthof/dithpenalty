PImage background;

PImage[] dithered = new PImage[4];
PImage[] mask = new PImage[4];


int factor = 1;

int endWidth = 200;
int endHeight = 320;

void setup() {
  noSmooth();
  size(200, 320);
  for (int j = 0; j < 4; j++) {
    mask[j] = loadImage("mask" + j + ".png");
  }

  for (int i = 0; i < 4; i++) {
    background = loadImage("Gang 320.png");
    background.resize(0, background.height/factor);
    background.filter(GRAY);
    background.loadPixels();
    for (int y = 0; y < background.height-1; y++) {
      for (int x = 0; x < background.width-1; x++) {
        color pix = background.pixels[index(x, y)];

        float oldR = red(pix);
        float oldG = green(pix);
        float oldB = blue(pix);

        int newR = round(oldR/255) * 255;
        int newG = round(oldG/255) * 255;
        int newB = round(oldB/255) * 255;
        background.pixels[index(x, y)] = color(newR, newG, newB);

        float errR = oldR - newR;
        float errG = oldG - newG;
        float errB = oldB - newB;

        passErr(x+1, y, errR, errG, errB, 7);
        passErr(x-1, y+1, errR, errG, errB, 3);
        passErr(x, y+1, errR, errG, errB, 5);
        passErr(x+1, y+1, errR, errG, errB, 1);
      }
      // sonderbehandlung für die Reihe ganz rechts
      color pix = background.pixels[index(background.width-1, y)];

      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);

      int newR = round(oldR/255) * 255;
      int newG = round(oldG/255) * 255;
      int newB = round(oldB/255) * 255;
      background.pixels[index(background.width-1, y)] = color(newR, newG, newB);

      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;

      passErr(background.width-1-1, y+1, errR, errG, errB, 3);
      passErr(background.width-1, y+1, errR, errG, errB, 5);
    }
    // sonderbehandlung für die Zeile ganz unten
    for (int x = 0; x < background.width-1; x++) {
      color pix = background.pixels[index(x, background.height-1)];

      float oldR = red(pix);
      float oldG = green(pix);
      float oldB = blue(pix);

      int newR = round(oldR/255) * 255;
      int newG = round(oldG/255) * 255;
      int newB = round(oldB/255) * 255;
      background.pixels[index(x, background.height-1)] = color(newR, newG, newB);

      float errR = oldR - newR;
      float errG = oldG - newG;
      float errB = oldB - newB;

      passErr(x+1, background.height-1, errR, errG, errB, 7);
    }
    color pix = background.pixels[index(background.width-1, background.height-1)];

    float oldR = red(pix);
    float oldG = green(pix);
    float oldB = blue(pix);

    int newR = round(oldR/255) * 255;
    int newG = round(oldG/255) * 255;
    int newB = round(oldB/255) * 255;
    background.pixels[index(background.width-1, background.height-1)] = color(newR, newG, newB);

    background.updatePixels();
    dithered[i] = background;
    dithered[i].mask(mask[i]);
    //image(dithered[i], i*endWidth, 0, endWidth, endHeight);
    factor *= 2;
  }
}

int index(int x, int y) {
  return x + y * background.width;
}

void passErr(int x, int y, float errR, float errG, float errB, int fractor) {
  int index = index(x, y);
  color c = background.pixels[index];
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  r = r + errR * fractor/16.0;
  g = g + errG * fractor/16.0;
  b = b + errB * fractor/16.0;
  background.pixels[index] = color(r, g, b);
}

void draw() {
  int distanceFactor = 0;
  for (int i = 3; i>=0; i--) {
    image(dithered[i], 0, 0, endWidth, endHeight);
    distanceFactor = distanceFactor + 1;
    print(distanceFactor);
  }
  noLoop();
}
