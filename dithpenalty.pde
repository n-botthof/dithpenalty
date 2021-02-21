int layerCount = 4;
PImage img;

int graphWidth = 2048;
int graphHeight = 1024;

int divisor = 1;

int endWidth = graphWidth;
int endHeight = graphHeight;

////////////////////



void setup() {
  noSmooth();
  size(2048, 1024);
  
  img = loadImage("sample3_2048.png");

  
}

void draw() {
  while (graphHeight / divisor >=1) {
    println(divisor);
    println(graphHeight);
    println(graphHeight / divisor);
    // print(img.height);
    img.resize(0, graphHeight/divisor);
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
    image(img, 0, 0, 2048, 1024);
    save("sample3/" + img.width + ".png");
    
    divisor *= 2;
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
