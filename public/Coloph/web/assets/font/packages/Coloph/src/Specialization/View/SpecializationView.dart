part of coloph;

abstract class SpecializationView extends BaseView{
  
  Specialization specialization;
  BorderInteractionController borderInteractionController;
  List<BorderConnection> borderConnections;
  CanvasGradient specializationGradient;
  
  bool highlighted;
  
  SpecializationView(CanvasRenderingContext2D ctx, Specialization specialization, BorderInteractionController borderInteractionController){
    this.specialization = specialization;
    this.ctx = ctx;
    this.borderInteractionController = borderInteractionController;
  }
  
  setBorderConnections(List<BorderConnection> borderConnections){
    this.borderConnections = borderConnections;
  }
  
  void addBorderConnection(BorderConnection borderConnection){
    borderConnections.add(borderConnection);
  }
  
  void removeBorderConnection(BorderConnection borderConnection){
    borderConnections.remove(borderConnection);
  }
  
  void _drawConnections(){
    for(BorderConnection bcn in borderConnections){
      ctx.beginPath();
      ctx.moveTo(bcn.borderPointA.point.x, bcn.borderPointA.point.y);
      ctx.lineTo(bcn.borderPointB.point.x, bcn.borderPointB.point.y);
      

      ctx.closePath();
      ctx.stroke();
      
      ctx.strokeStyle = 'black';
    }
  }
  
}