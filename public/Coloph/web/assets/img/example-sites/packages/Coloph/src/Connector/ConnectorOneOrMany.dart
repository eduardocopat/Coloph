part of coloph;

class ConnectorOneOrMany extends Connector  {
  
  ConnectorOneOrMany(BorderPoint borderPoint, CanvasRenderingContext2D ctx) : super(borderPoint, ctx);
  
  _drawNorthOriented(){
    _drawBar(Connector.NORTH);
    _drawTopLeg(Connector.NORTH);
    _drawMidLeg(Connector.NORTH);
    _drawBotLeg(Connector.NORTH);
  }
  _drawSouthOriented(){
    _drawBar(Connector.SOUTH);
    _drawTopLeg(Connector.SOUTH);
    _drawMidLeg(Connector.SOUTH);
    _drawBotLeg(Connector.SOUTH);
  }
  _drawEastOriented(){
    _drawBar(Connector.EAST);
    _drawTopLeg(Connector.EAST);
    _drawMidLeg(Connector.EAST);
    _drawBotLeg(Connector.EAST);
  }
  _drawWestOriented(){
    _drawBar(Connector.WEST);
    _drawTopLeg(Connector.WEST);
    _drawMidLeg(Connector.WEST);
    _drawBotLeg(Connector.WEST);
  }
  
}