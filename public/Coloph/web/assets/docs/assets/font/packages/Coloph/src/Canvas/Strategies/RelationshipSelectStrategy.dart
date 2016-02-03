part of coloph;

class RelationshipSelectStrategy extends CanvasInteractionStrategy{
  CanvasRenderingContext2D ctx;
  RelationshipController relationshipController;
  CanvasActionsController canvasActionsContorller;
  Relationship clickedRelationship;
  
  RelationshipSelectStrategy(CanvasRenderingContext2D ctx, 
                             RelationshipController relationshipController,
                             CanvasActionsController canvasActionsContorller,
                             Relationship clickedRelationship){
    this.ctx = ctx;
    this.relationshipController = relationshipController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.clickedRelationship = clickedRelationship;
  }
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){
    if(clickOrigin == CanvasInteractionStrategy.LEFT_CLICK){
      relationshipController.toggle(clickedRelationship);
    }
    canvasActionsContorller.setDefaultCanvasInteractionContext();
  }
}