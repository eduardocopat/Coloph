part of coloph;

/** When there is no special action being executed over the canvas, this is its default behaviour **/
class DefaultStrategy extends CanvasInteractionStrategy{
  CanvasRenderingContext2D ctx;
  TableController tableController;
  RelationshipController relationshipController;
  
  DefaultStrategy(CanvasRenderingContext2D ctx, TableController tableController, RelationshipController relationshipController){
    this.ctx = ctx;
    this.tableController = tableController;
    this.relationshipController = relationshipController;
    ctx.canvas.style.cursor = 'default';
  }
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){
    if(clickOrigin == CanvasInteractionStrategy.RIGHT_CLICK){
      Element canvasMenu = querySelector("#canvas_menu");
      canvasMenu.nodes.clear();
      //canvasMenu.style.visibility = "hidden";
    }
  }
  
  executeMouseMove(Point canvasMousePosition){
    
   if(tableController.getClickedTable(canvasMousePosition) == null &&
      relationshipController.getClickedRelationship(canvasMousePosition) == null)
     ctx.canvas.style.cursor = 'default';
   else
     ctx.canvas.style.cursor = 'pointer';
    
     
  }
  
  
}