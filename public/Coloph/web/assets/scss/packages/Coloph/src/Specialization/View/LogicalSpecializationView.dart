part of coloph;

class LogicalSpecializationView extends SpecializationView{
  
  LogicalSpecializationView(CanvasRenderingContext2D ctx, Specialization specialization, BorderInteractionController borderInteractionController)
      :super(ctx, specialization, borderInteractionController){
  }
  
  void updateFillingColorGradient(){
    
  }
  
  void draw(){
    ctx.lineWidth = 1;
    
    _drawConnections();
    
    ctx.beginPath();
    Point squareDownMidPoint = new Point(specialization.x + specialization.height/2, specialization.y + specialization.width);
    ctx.arc(squareDownMidPoint.x, squareDownMidPoint.y, 30, 0, Math.PI, true);
    ctx.fillStyle = 'white';
    ctx.fill();
    ctx.closePath();
    ctx.lineWidth = 2;
    ctx.stroke();
    
    if(toggled)
      _toggle();
    
    ctx.lineWidth = 1;
  }
  void _toggle(){
    List<Point> togglingPoints = new List<Point>();
    //togglingPoints.add(new Point(specialization.x-2,specialization.y-2));
    //togglingPoints.add(new Point(specialization.x+specialization.width-2,specialization.y-2));
    togglingPoints.add(new Point(specialization.x-2,specialization.y+specialization.height-2));
    togglingPoints.add(new Point(specialization.x+specialization.width-2,specialization.y+specialization.height-2));
    togglingPoints.add(new Point(specialization.x+specialization.width/2-2,specialization.y-2));
    
    for(Point p in togglingPoints){
      ctx.beginPath();
      ctx.lineWidth = 2;
      ctx.rect(p.x, p.y, 5 , 5);
      ctx.fillStyle = TOGGLE_COLOR;
      ctx.fillRect(p.x, p.y, 5 , 5);
      ctx.closePath();
      ctx.stroke();
      ctx.lineWidth = 1;
    }
  }
}