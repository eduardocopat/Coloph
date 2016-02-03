part of coloph;

class ConnectorOne extends Connector  {
  
  ConnectorOne(BorderPoint borderPoint, CanvasRenderingContext2D ctx) : super(borderPoint, ctx);
  
  _drawNorthOriented(){
    _drawBar(Connector.NORTH);
    _drawMidLeg(Connector.NORTH);
  }
  _drawSouthOriented(){
    _drawBar(Connector.SOUTH);
    _drawMidLeg(Connector.SOUTH);
  }
  _drawEastOriented(){
    _drawBar(Connector.EAST);
    _drawMidLeg(Connector.EAST);
  }
  _drawWestOriented(){
    _drawBar(Connector.WEST);
    _drawMidLeg(Connector.WEST);
  }
  
}