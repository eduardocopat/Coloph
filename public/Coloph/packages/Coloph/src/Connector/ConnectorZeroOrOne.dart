part of coloph;

class ConnectorZeroOrOne extends Connector  {
  
  ConnectorZeroOrOne(BorderPoint borderPoint, CanvasRenderingContext2D ctx) : super(borderPoint, ctx) {
    setCircled(true);
  }
  
  _drawNorthOriented(){
    _drawCircle();
    _drawMidLeg("NORTH");
  }
  _drawSouthOriented(){
    _drawCircle();
    _drawMidLeg("SOUTH");
  }
  _drawEastOriented(){
    _drawCircle();
    _drawMidLeg("EAST");
  }
  _drawWestOriented(){
    _drawCircle();
    _drawMidLeg("WEST");
  }
  
}
