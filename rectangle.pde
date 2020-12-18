class Rectangle {
 int x, y, width, height;
 
 Rectangle(int x, int y, int width, int height) {
   this.x = x;
   this.y = y;
   this.width = width;
   this.height = height;
 }
 
 void draw(PGraphics graphic)
 {
   graphic.rect(x, y, width, height);
 }
}
