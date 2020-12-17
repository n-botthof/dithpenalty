class Color
{
  float r, g, b;
  
  Color(color c) {
    r = red(c);
    g = green(c);
    b = blue(c);
  }
  
  Color(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  color composeColor(){
    return color(r, g, b);
  }
}
