part of coloph;

class ConceptualSpecializationView extends SpecializationView{
  
  ConceptualSpecializationView(CanvasRenderingContext2D ctx, Specialization specialization, BorderInteractionController borderInteractionController)
      :super(ctx, specialization, borderInteractionController){
  }
  
  void draw(){
    ctx.lineWidth = 1;
    
    _drawConnections(); 
    for(BorderConnection bcn in borderConnections){
      if(bcn.canvasModelB != specialization.parentTable)
        _drawUShape(bcn);
    }
    
    _drawCircle();
    
    if(toggled)
      _toggle();
    
    ctx.lineWidth = 1;
  }
  
  void _drawUShape(BorderConnection bcn){
    Point middlePoint = calculateMiddlePoint(bcn.borderPointA.point, bcn.borderPointB.point);
    switch(bcn.borderPointA.borderCode){
    case 'NORTH':
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x-10, middlePoint.y, middlePoint.x-10, middlePoint.y, middlePoint.x-10, middlePoint.y-15);
      ctx.stroke();
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x+10, middlePoint.y, middlePoint.x+10, middlePoint.y, middlePoint.x+10, middlePoint.y-15);
      ctx.stroke();
      break;
    case 'SOUTH':
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x+10, middlePoint.y, middlePoint.x+10, middlePoint.y, middlePoint.x+10, middlePoint.y+15);
      ctx.stroke();
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x-10, middlePoint.y, middlePoint.x-10, middlePoint.y, middlePoint.x-10, middlePoint.y+15);
      ctx.stroke();
      break;
    case 'WEST':
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x, middlePoint.y-10, middlePoint.x, middlePoint.y-10, middlePoint.x-15, middlePoint.y-10);        
      ctx.stroke();
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x, middlePoint.y+10, middlePoint.x, middlePoint.y+10, middlePoint.x-15, middlePoint.y+10);
      ctx.stroke();
      break;
    case 'EAST':
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x, middlePoint.y-10, middlePoint.x, middlePoint.y-10, middlePoint.x+15, middlePoint.y-10);
      ctx.stroke();
      ctx.moveTo(middlePoint.x, middlePoint.y);
      ctx.bezierCurveTo(middlePoint.x, middlePoint.y+10, middlePoint.x, middlePoint.y+10, middlePoint.x+15, middlePoint.y+10);
      ctx.stroke();
      break;
    }
  }
  
  void _drawCircle(){
    Point centerPoint = new Point((specialization.x+specialization.width/2),(specialization.y+specialization.height/2));
    num radius =  distance2D(centerPoint, new Point(specialization.x,specialization.y));
    ctx.beginPath();
    ctx.arc(centerPoint.x, centerPoint.y, radius, 0, 2 * Math.PI, false);
    updateFillingColorGradient();
    ctx.fillStyle = specializationGradient; 
    ctx.fill();
    ctx.lineWidth = GOLDEN_RATIO;
    if(highlighted)
      ctx.strokeStyle = 'grey';
    else
      ctx.strokeStyle = 'black';
    ctx.stroke();
    
    ctx.lineWidth = 1;
    ctx.strokeStyle = 'black';
  }
  
  void updateFillingColorGradient(){
    specializationGradient = null;
    specializationGradient = ctx.createLinearGradient(specialization.x, specialization.y, specialization.x + specialization.width, specialization.y + specialization.height);
    specializationGradient.addColorStop(0, FILLING_SPECIALIZATION_COLOR);
    specializationGradient.addColorStop(1, FILLING_SPECIALIZATION_COLOR_HEAVY); // \,,/
  }
  
  void _toggle(){
    List<Point> togglingPoints = new List<Point>();
    togglingPoints.add(new Point(specialization.x-2,specialization.y-2));
    togglingPoints.add(new Point(specialization.x+specialization.width-2,specialization.y-2));
    togglingPoints.add(new Point(specialization.x-2,specialization.y+specialization.height-2));
    togglingPoints.add(new Point(specialization.x+specialization.width-2,specialization.y+specialization.height-2));
    
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