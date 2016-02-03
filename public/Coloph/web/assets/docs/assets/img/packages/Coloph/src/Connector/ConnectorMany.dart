part of coloph;

class ConnectorMany extends Connector  {
  
  ConnectorMany(BorderPoint borderPoint, CanvasRenderingContext2D ctx) : super(borderPoint, ctx);
  
  _drawNorthOriented(){
    _drawTopLeg(Connector.NORTH);
    _drawMidLeg(Connector.NORTH);
    _drawBotLeg(Connector.NORTH);
  }
  _drawSouthOriented(){
    _drawTopLeg(Connector.SOUTH);
    _drawMidLeg(Connector.SOUTH);
    _drawBotLeg(Connector.SOUTH);
  }
  _drawEastOriented(){
    _drawTopLeg(Connector.EAST);
    _drawMidLeg(Connector.EAST);
    _drawBotLeg(Connector.EAST);
  }
  _drawWestOriented(){
    _drawTopLeg(Connector.WEST);
    _drawMidLeg(Connector.WEST);
    _drawBotLeg(Connector.WEST);
  }
  
}