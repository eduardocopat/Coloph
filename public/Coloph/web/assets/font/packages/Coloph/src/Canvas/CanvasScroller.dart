part of coloph;

class CanvasScroller {
  
  CanvasElement canvas; 
  MouseEvent evt; //The movement mouse event
  
  CanvasScroller(CanvasElement canvas,[ MouseEvent evt]){
    this.canvas = canvas;
    this.evt = evt;
  }
  
  /**Scroll the object if it reaches a canvas border, increase the canvas size
   * if it reaches a canvas div border, scrolls the div*/
  void scrollIfNeeded(num objectWidth, num objectHeight){
    _IncreaseCanvasIfNeeded(objectWidth.toInt(), objectHeight.toInt());
    
    DivElement canvasDiv = canvas.parent;
    _scrollCanvasDivIfNeeded(canvasDiv, objectWidth.toInt(),objectHeight.toInt() );
    
    /* Note: Changing the width and height of canvas makes it clear the canvas,
     * So I have to reset its presets */   
    canvas.context2D.font = FONT_TYPE_AND_SIZE;
  }
  
  /** Increase the canvas size if the object reaches a border**/ 
  void _IncreaseCanvasIfNeeded(int objectWidth, int objectHeight ){
    Point canvasMousePosition = _getElementRelativeMousePosition(canvas, evt);
    
    /*If the half the object has reached the east side, then the canvas must grow so the object  can fit*/
    if(canvasMousePosition.x > canvas.width - (objectWidth/2)){
      canvas.width  = canvas.width + objectWidth;
    }
    
    /*If the half the object has reached the south side, then the canvas must grow so the object  can fit*/
    if(canvasMousePosition.y > canvas.height - (objectHeight/2)){
      canvas.height = canvas.height + objectHeight;
    }
  }
  
  /**Incrase the canvas size if the object is outside the actual canvas **/
  void increaseCanvasByObject(int objectX, int objectY, int objectWidth, int objectHeight){
    if(canvas.width < objectX + objectWidth)
      canvas.width += objectX + objectWidth;
      
    if(canvas.height < objectY + objectHeight )
      canvas.height += objectY + objectHeight;
    
    canvas.context2D.font = FONT_TYPE_AND_SIZE;
  }
  
  /** Scroll the canvas div if the object has not reached the canvas border, but the canvasDiv border,
   * so there is still more canvas to the user visualize**/
  void _scrollCanvasDivIfNeeded(DivElement canvasDiv, int objectWidth, int objectHeight ){
    Point canvasDivMousePosition = _getElementRelativeMousePosition(canvasDiv, evt);
    Rectangle canvasDivRect = canvasDiv.getBoundingClientRect();
    
    /*Scroll to south if the user is trying to*/
    if(canvasDivMousePosition.y > canvasDivRect.height - (objectHeight/2))
    {
      canvasDiv.scrollTop += objectHeight~/4;
    }
    
    /*Scroll to north if the user is trying to*/
    if(canvasDivMousePosition.y < (objectHeight/2))
    {
      canvasDiv.scrollTop -= objectHeight~/4;
    }
    
    /*Scroll to east if the user is trying to */
    if(canvasDivMousePosition.x > canvasDivRect.width - (objectWidth/2))
    {
      canvasDiv.scrollLeft += objectWidth~/4;
    }
    
    /*Scroll to west if the user is trying to*/
    if(canvasDivMousePosition.x < (objectWidth/2))
    {
      canvasDiv.scrollLeft -= objectWidth~/4;
    }
  }
  
  /** Get the relative mouse position of an Element throught its Bounding Rect**/
  Point _getElementRelativeMousePosition(Element element, MouseEvent evt){
    Rectangle elementRect = element.getBoundingClientRect();
    Point ElementBoundingRect = new Point(elementRect.left, elementRect.top);
    Point canvasDivMousePosition = new Point(evt.client.x - ElementBoundingRect.x, evt.client.y - ElementBoundingRect.y );
    return canvasDivMousePosition;
  }
  
  
  
}
