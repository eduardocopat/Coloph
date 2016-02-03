part of coloph;

abstract class Connector {

  String connectorType;
  BorderPoint borderPoint;
  Point centralPoint;
  Point gluePoint;
  CanvasRenderingContext2D ctx;
  num RADIUS;
  bool circled;
  
  static const NORTH = "NORTH";
  static const SOUTH = "SOUTH";
  static const EAST = "EAST";
  static const WEST = "WEST";
  
  Connector(BorderPoint borderPoint, CanvasRenderingContext2D ctx){
    this.borderPoint = borderPoint;
    this.ctx = ctx;
    this.RADIUS = 4;
    setCircled(false);
  }
  
  void setCircled(bool circled){
    if(circled)
      this.circled = true;
    else
      this.circled = false;
  }

  Point getGluePoint(){
    return gluePoint;
  }

  /** Draws the connector **/
  void draw(){
    ctx.lineWidth = 1;
    switch (this.borderPoint.borderCode) 
    {
      case BorderPoint.NORTH:
        centralPoint = new Point(borderPoint.point.x, borderPoint.point.y-15);
        
        if(circled)
          gluePoint = new Point(borderPoint.point.x, borderPoint.point.y - 15 - RADIUS);
        else
          gluePoint = new Point(borderPoint.point.x, borderPoint.point.y - 15 + RADIUS);
        
        _drawNorthOriented();
      break;
      case BorderPoint.SOUTH:
        centralPoint = new Point(borderPoint.point.x, borderPoint.point.y+15);
        
        if(circled)
          gluePoint = new Point(borderPoint.point.x, borderPoint.point.y + 15 + RADIUS );
        else
          gluePoint = new Point(borderPoint.point.x, borderPoint.point.y + 15 - RADIUS);
        
        _drawSouthOriented();
      break;
      case BorderPoint.EAST:
        centralPoint = new Point(borderPoint.point.x+15, borderPoint.point.y );
        
        if(circled)
          gluePoint = new Point(borderPoint.point.x + 15 + RADIUS, borderPoint.point.y);
        else
          gluePoint = new Point(borderPoint.point.x + 15 - RADIUS, borderPoint.point.y);
        
        _drawEastOriented();
      break;
      case BorderPoint.WEST:
        centralPoint = new Point(borderPoint.point.x-15, borderPoint.point.y);
        
        if(circled)
          gluePoint = new Point(borderPoint.point.x-15-RADIUS , borderPoint.point.y);
        else
          gluePoint = new Point(borderPoint.point.x-15 + RADIUS, borderPoint.point.y);

        _drawWestOriented();
      break;
    }
  }
  
  _drawNorthOriented();
  _drawSouthOriented();
  _drawEastOriented();
  _drawWestOriented();
  
  _drawTopLeg(String orientation){
    switch(orientation)
    {
      case BorderPoint.NORTH:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x , centralPoint.y + RADIUS);
        ctx.lineTo(centralPoint.x + 10,centralPoint.y+15);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.SOUTH:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x, centralPoint.y - RADIUS);
        ctx.lineTo(centralPoint.x + 10,centralPoint.y-15);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.EAST:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x - RADIUS, centralPoint.y);
        ctx.lineTo(centralPoint.x - 15,centralPoint.y-10);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.WEST:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x + RADIUS, centralPoint.y);
        ctx.lineTo(centralPoint.x + 15,centralPoint.y-10);
        ctx.stroke();
        ctx.closePath();
      break;
    }
  }
  
  _drawMidLeg(String orientation){
    switch(orientation)
    {
      
      case "NORTH":
        ctx.beginPath();
        ctx.moveTo(centralPoint.x , centralPoint.y + RADIUS);
        ctx.lineTo(centralPoint.x ,centralPoint.y  +15 );
        ctx.stroke();
        ctx.closePath();
      break;
      case "SOUTH":
        ctx.beginPath();
        ctx.moveTo(centralPoint.x, centralPoint.y - RADIUS);
        ctx.lineTo(centralPoint.x,centralPoint.y  -15 );
        ctx.stroke();
        ctx.closePath();
      break;
      case "EAST":
        ctx.beginPath();
        ctx.moveTo(centralPoint.x - RADIUS, centralPoint.y);
        ctx.lineTo(centralPoint.x - 15,centralPoint.y);
        ctx.stroke();
        ctx.closePath();
      break;
      case "WEST":
        ctx.beginPath();
        ctx.moveTo(centralPoint.x + RADIUS, centralPoint.y);
        ctx.lineTo(centralPoint.x + 15,centralPoint.y);
        ctx.stroke();
        ctx.closePath();
      break;
    }
  }
  
  _drawBotLeg(String orientation){
    switch(orientation)
    {
      case BorderPoint.NORTH:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x  , centralPoint.y + RADIUS);
        ctx.lineTo(centralPoint.x - 10,centralPoint.y +15);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.SOUTH:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x, centralPoint.y - RADIUS);
        ctx.lineTo(centralPoint.x - 10,centralPoint.y - 15);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.EAST:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x - RADIUS, centralPoint.y );
        ctx.lineTo(centralPoint.x - 15,centralPoint.y+10);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.WEST:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x + RADIUS, centralPoint.y);
        ctx.lineTo(centralPoint.x + 15,centralPoint.y+10);
        ctx.stroke();
        ctx.closePath();
      break;
    }
  }
  
  _drawBar(String orientation){
    switch(orientation)
    {
      case BorderPoint.NORTH:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x - (RADIUS*2) , centralPoint.y + RADIUS);
        ctx.lineTo(centralPoint.x + (RADIUS*2) , centralPoint.y + RADIUS);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.SOUTH:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x - (RADIUS*2) , centralPoint.y - RADIUS);
        ctx.lineTo(centralPoint.x + (RADIUS*2) , centralPoint.y - RADIUS);
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.EAST:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x - RADIUS , centralPoint.y - (RADIUS*2));
        ctx.lineTo(centralPoint.x - RADIUS , centralPoint.y + (RADIUS*2));
        ctx.stroke();
        ctx.closePath();
      break;
      case BorderPoint.WEST:
        ctx.beginPath();
        ctx.moveTo(centralPoint.x + RADIUS , centralPoint.y - (RADIUS*2));
        ctx.lineTo(centralPoint.x + RADIUS , centralPoint.y + (RADIUS*2));
        ctx.stroke();
        ctx.closePath();
      break;
    }
  }
 
  _drawCircle(){
    ctx.beginPath();
    ctx.lineWidth = 0;
    ctx.arc(centralPoint.x, centralPoint.y, RADIUS, 0 , 2 * Math.PI, false);
    ctx.fillStyle = FILLING_TABLE_COLOR;
    ctx.fill();
    ctx.strokeStyle = "black";
    ctx.stroke();
    ctx.closePath();
  }
 

}
