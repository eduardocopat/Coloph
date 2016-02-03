part of coloph;

class ConnectorZeroOrMany extends Connector  {
  
  ConnectorZeroOrMany(BorderPoint borderPoint, CanvasRenderingContext2D ctx) : super(borderPoint, ctx) {
    setCircled(true);
  }
  
  _drawNorthOriented(){
    _drawCircle();
    _drawTopLeg(Connector.NORTH);
    _drawMidLeg(Connector.NORTH);
    _drawBotLeg(Connector.NORTH);
  }
  _drawSouthOriented(){
    _drawCircle();
    _drawTopLeg(Connector.SOUTH);
    _drawMidLeg(Connector.SOUTH);
    _drawBotLeg(Connector.SOUTH);
  }
  _drawEastOriented(){
    _drawCircle();
    _drawTopLeg(Connector.EAST);
    _drawMidLeg(Connector.EAST);
    _drawBotLeg(Connector.EAST);
  }
  _drawWestOriented(){
    _drawCircle();
    _drawTopLeg(Connector.WEST);
    _drawMidLeg(Connector.WEST);
    _drawBotLeg(Connector.WEST);
  }
  
}
