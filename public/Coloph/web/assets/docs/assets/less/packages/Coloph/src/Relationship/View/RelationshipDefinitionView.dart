part of coloph;

class RelationshipDefinitionView {

  Point startRel;
  Point endRel;
  CanvasRenderingContext2D ctx;

  RelationshipDefinitionView(Point startRel, Point endRel,  CanvasRenderingContext2D ctx)
  {
    this.startRel = startRel;
    this.endRel   = endRel;
    this.ctx      = ctx;
  }

  void draw()
  {
     ctx.beginPath();
     ctx.lineWidth = 1;
     ctx.strokeStyle = 'black';
     ctx.moveTo(startRel.x, startRel.y);
     ctx.lineTo(endRel.x, endRel.y);
     ctx.stroke();
     ctx.closePath();
  }



}
