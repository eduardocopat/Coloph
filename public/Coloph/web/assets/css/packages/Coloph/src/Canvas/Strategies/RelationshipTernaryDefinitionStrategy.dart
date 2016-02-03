part of coloph;


class RelationshipTernaryDefinitionStrategy extends CanvasInteractionStrategy{
  
  CanvasRenderingContext2D ctx;
  TableController tableController;
  RelationshipController relationshipController;
  CanvasActionsController canvasActionsContorller;
  RelationshipCreationStatus relationshipCreationStatus;
  
  Table ternaryTable;
  Relationship ternaryRelationship; 
  Table movedOverTable; //Table which the user is passingby the mouse
  Relationship movedOverRelationship;
  
  RelationshipTernaryDefinitionStrategy(
    CanvasRenderingContext2D ctx, 
    TableController tableController, 
    RelationshipController relationshipController,
    CanvasActionsController canvasActionsContorller){
    this.ctx = ctx;
    this.tableController = tableController;
    this.relationshipController = relationshipController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.relationshipCreationStatus =  new RelationshipCreationStatus();
    ctx.canvas.style.cursor = 'crosshair';
  }
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){
    if(!relationshipCreationStatus.hasStarted()){
      ternaryTable = tableController.getClickedTable(canvasMousePosition);
      ternaryRelationship = relationshipController.getClickedRelationship(canvasMousePosition);
      if(ternaryTable != null)
        tableController.highlightTable(ternaryTable, true);
      else if(ternaryRelationship != null)
        relationshipController.highlightRelationship(ternaryRelationship, true);
      else
        canvasActionsContorller.setDefaultCanvasInteractionContext();
      
      relationshipController.createRelationshipDefinition(canvasMousePosition);
      relationshipCreationStatus.setStarted();
    }else{
      if(_ternaryStartedFromTable())
       ternaryRelationship = relationshipController.getClickedRelationship(canvasMousePosition);
      else
       ternaryTable = tableController.getClickedTable(canvasMousePosition);
      
      if(ternaryTable != null && ternaryRelationship != null){
          if(ternaryRelationship.dataType != Relationship.SELF_RELATIONSHIP)
            relationshipController.convertIntoTernary(ternaryTable, ternaryRelationship);
      }
      
      if(ternaryTable != null)
        tableController.highlightTable(ternaryTable, false);
      if(ternaryRelationship != null)
        relationshipController.highlightRelationship(ternaryRelationship, false);
     
      
      relationshipController.deleteRelationshipDefinition();
      canvasActionsContorller.setDefaultCanvasInteractionContext();
    }
  }
    
  executeMouseMove(Point canvasMousePosition){
    if(relationshipCreationStatus.hasStarted()){
      if(_ternaryStartedFromRelationship()){
        if(!identical(movedOverTable, ternaryTable))
          tableController.highlightTable(movedOverTable, false);
        
        movedOverTable = tableController.getClickedTable(canvasMousePosition);
        if(movedOverTable != null)
          tableController.highlightTable(movedOverTable, true);
       
      }
      if(_ternaryStartedFromTable()){
        if(!identical(movedOverRelationship, ternaryRelationship))
           relationshipController.highlightRelationship(movedOverRelationship, false);
        
        movedOverRelationship = relationshipController.getClickedRelationship(canvasMousePosition);
        if(movedOverRelationship != null)
          relationshipController.highlightRelationship(movedOverRelationship, true);
      }
      relationshipController.setRelationshipDefinitionEndPoint(canvasMousePosition);
    }

  }
  
  executeMouseUp(Point canvasMousePosition){
    //Table clickedTable = tableController.getClickedTable(canvasMousePosition);
    //if(clickedTable != null)
    //  tableController.highlightTable(clickedTable.id, false);
  }
  
  bool _ternaryStartedFromTable(){
    if(ternaryTable != null)
      return true;
    else
      return false;
  }
  bool _ternaryStartedFromRelationship(){
    if(ternaryRelationship != null)
      return true;
    else
      return false;
  }
  
  
}

