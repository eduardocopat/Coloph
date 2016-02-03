part of coloph;

class SelectionRectangle{
  
  CanvasRenderingContext2D ctx;
  Rectangle rectangle;
  
  SelectionRectangle(CanvasRenderingContext2D ctx){
    this.ctx = ctx;
  }
  
  setRectanglePoints(Point fixedPoint, Point variablePoint){
    num minX = Math.min(fixedPoint.x, variablePoint.x);
    num minY = Math.min(fixedPoint.y, variablePoint.y);
    num width = Math.max(fixedPoint.x, variablePoint.x)-minX;
    num height = Math.max(fixedPoint.y, variablePoint.y)-minY;
    
     
    rectangle = new Rectangle(fixedPoint.x,fixedPoint.y,width,height); 
  }
  
  draw(){
    ctx.beginPath();
    ctx.rect(rectangle.top, rectangle.left, rectangle.width, rectangle.height);
    ctx.closePath();
    ctx.stroke();
  }
  
    //contains
  
  
}