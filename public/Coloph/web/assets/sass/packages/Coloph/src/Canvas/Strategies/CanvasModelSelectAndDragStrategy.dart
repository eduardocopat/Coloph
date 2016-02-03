part of coloph;


/** This strategy is used when the user is selecting and/or dragging a table*/
class CanvasModelSelectAndDragStrategy extends CanvasInteractionStrategy{
  CanvasRenderingContext2D ctx;
  
  BaseCanvasModel baseCanvasModel;
  Point initialCanvasModelPosition;
  Point initialMousePosition;
  Map canvasModelFieldsPosition;
  
  BaseCanvasModelController baseCanvasController;
  BorderInteractionController borderInteractionController;
  CanvasActionsController canvasActionsController;
  DiagramController diagramController;
  
  CanvasModelSelectAndDragStrategy(
      CanvasRenderingContext2D ctx, 
      BaseCanvasModel baseCanvasModel,
      BaseCanvasModelController baseCanvasController,
      CanvasActionsController canvasActionsContorller,
      BorderInteractionController borderInteractionController,
      DiagramController diagramController){
    this.ctx = ctx;
    this.baseCanvasController = baseCanvasController;
    this.canvasActionsController = canvasActionsContorller;
    this.baseCanvasModel = baseCanvasModel;
    this.borderInteractionController = borderInteractionController;
    this.diagramController = diagramController;
    canvasModelFieldsPosition = new Map();
  }
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){
    if(clickOrigin == CanvasInteractionStrategy.LEFT_CLICK){
      initialCanvasModelPosition = new Point(baseCanvasModel.x,baseCanvasModel.y);
      
      //Populates a list with the coordinates position from table fields
      for(BaseField baseField in baseCanvasModel.getFields()){
        canvasModelFieldsPosition[baseField] = new Point(baseField.x, baseField.y);
        
        for(BaseField baseSubField in baseField.getFields()){
          canvasModelFieldsPosition[baseSubField] = new Point(baseSubField.x, baseSubField.y);
        }
      }
      initialMousePosition = canvasMousePosition;
      ctx.canvas.style.cursor = 'move';
      baseCanvasController.toggle(baseCanvasModel);
    }
  }
  
  executeCanvasScroll(MouseEvent evt){
    /*The Canvas Scroller may scroll, if needed, the canvas div and increase the size of the canvas too*/
    CanvasScroller canvasScroller = new CanvasScroller(ctx.canvas, evt);
    canvasScroller.scrollIfNeeded(baseCanvasModel.width, baseCanvasModel.height);
  }
  
  executeMouseMove(Point canvasMousePosition){
    baseCanvasController.drag(baseCanvasModel, initialCanvasModelPosition, initialMousePosition, canvasMousePosition);
    
    for(BaseField baseField in baseCanvasModel.getFields()){
      baseCanvasController.drag(baseField, canvasModelFieldsPosition[baseField], initialMousePosition, canvasMousePosition);

       for(BaseField baseSubField in baseField.getFields()){
         baseCanvasController.drag(baseSubField, canvasModelFieldsPosition[baseSubField], initialMousePosition, canvasMousePosition);
        }
      }
  }
  
  executeMouseUp(Point canvasMousePosition){
    if(borderInteractionController.isIntersecting(baseCanvasModel))
      baseCanvasController.resetModelLocation(baseCanvasModel, canvasModelFieldsPosition, initialCanvasModelPosition);
    
    if(diagramController.isConceptual()){
      for(BaseField baseField in baseCanvasModel.getFields()){
          if(borderInteractionController.isIntersecting(baseField)){
            baseCanvasController.resetModelLocation(baseCanvasModel, canvasModelFieldsPosition, initialCanvasModelPosition);
            break;
          }  
  
          for(BaseField baseSubField in baseField.getFields()){
            if(borderInteractionController.isIntersecting(baseSubField))
              baseCanvasController.resetModelLocation(baseCanvasModel, canvasModelFieldsPosition, initialCanvasModelPosition);
        }
      }  
    }
  
    canvasActionsController.setDefaultCanvasInteractionContext(); 
    baseCanvasController.forceUpdateDueToNewPosition(baseCanvasModel);
  }
  
  executeDoubleClick(Point canvasMousePosition){
    //Table doubleClickedTable = tableController.getClickedTable(canvasMousePosition); 
    //if(doubleClickedTable != null)
    
    
    // To DO---> Quando estiver fazendo o double click, pensar se precisa realmente obter o model...
    //baseCanvasController.edit();
  }
  
  executeKeyDown(KeyboardEvent evt){
    /*
  switch (evt.keyCode) {
    case KeyCode.DELETE:
        tableController.deleteTable(clickedTable);
        break;
    }
    */
  }
  

  
}