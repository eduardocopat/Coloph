part of coloph;

/** This strategy is used when the user is setting a relationship between two tables **/
class RelationshipDefinitionStrategy extends CanvasInteractionStrategy{
  
  CanvasRenderingContext2D ctx;
  TableController tableController;
  RelationshipController relationshipController;
  CanvasActionsController canvasActionsContorller;
  DiagramController diagramController;
  
  RelationshipCreationStatus relationshipCreationStatus;
  
  String relationshipType;
  
  Table parentTable;
  Table childTable;
  Table movedOverTable; //Table which the user is passingby the mouse
  
  
  RelationshipDefinitionStrategy(CanvasRenderingContext2D ctx, 
                                 TableController tableController, 
                                 RelationshipController relationshipController,
                                 DiagramController diagramController,
                                 CanvasActionsController canvasActionsContorller,
                                 String relationshipType){
    this.ctx = ctx;
    this.tableController = tableController;
    this.relationshipController = relationshipController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.diagramController = diagramController;
    this.relationshipType = relationshipType;
    this.relationshipCreationStatus =  new RelationshipCreationStatus();
    ctx.canvas.style.cursor = 'crosshair';
    
  }
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){
     if(!relationshipCreationStatus.hasStarted()){
        parentTable = tableController.getClickedTable(canvasMousePosition);
        //If it is hitting a table
        if(parentTable != null){
          if(relationshipType == Relationship.SELF_RELATIONSHIP){
            childTable = parentTable;
            Relationship relationship = new Relationship(diagramController.getDiagramId(), parentTable, childTable, relationshipType, new List<RelationshipField>() );
            relationshipController.newRelationship(relationship);
            canvasActionsContorller.setDefaultCanvasInteractionContext();
          }else{
            tableController.highlightTable(parentTable, true);
            relationshipController.createRelationshipDefinition(canvasMousePosition);
            relationshipCreationStatus.setStarted();
          }
        } else {
           canvasActionsContorller.setDefaultCanvasInteractionContext();
        }
     } else {
        childTable = tableController.getClickedTable(canvasMousePosition);
        
        if(parentTable != childTable){
          if(childTable != null){
            //HOUSTON WE HAVE RELATIONSHIP
            Relationship relationship = new Relationship(diagramController.getDiagramId(), parentTable, childTable, relationshipType, new List<RelationshipField>() );
            relationshipController.newRelationship(relationship);
            tableController.highlightTable(childTable, false);
          }
        }
        
        //Unhighlight and set the default stance
        tableController.highlightTable(parentTable, false);
       
        
        relationshipController.deleteRelationshipDefinition();
        canvasActionsContorller.setDefaultCanvasInteractionContext();
      }
  }
    
  executeMouseMove(Point canvasMousePosition){
    if(relationshipCreationStatus.hasStarted()){
      if(movedOverTable != null && !identical(movedOverTable, parentTable))
        tableController.highlightTable(movedOverTable, false);
      
      movedOverTable = tableController.getClickedTable(canvasMousePosition);
      //Am I moving above a table?
      if(movedOverTable != null){
        //Highlight this then!!
        tableController.highlightTable(movedOverTable, true);
      } else {  
        //Have I moved another table before? I need unhighlight it!
       
      }
       relationshipController.setRelationshipDefinitionEndPoint(canvasMousePosition);
    }
  }
  
  executeMouseUp(Point canvasMousePosition){
    //Table clickedTable = tableController.getClickedTable(canvasMousePosition);
    //if(clickedTable != null)
    //  tableController.highlightTable(clickedTable.id, false);
  }
  
}

/** Auxiliary class to define if the relationship is starting or being finished*/
class RelationshipCreationStatus{
  bool status;
  
  RelationshipCreationStatus(){
    status = false;
  }
  
  bool hasStarted(){
    return status;
  }
 
  
  void setStarted(){
    status = true;
  }
}