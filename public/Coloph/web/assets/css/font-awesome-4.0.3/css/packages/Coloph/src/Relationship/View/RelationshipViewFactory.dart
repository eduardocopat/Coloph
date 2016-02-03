part of coloph;

class RelationshipViewFactory extends ViewFactory{
  List<RelationshipView> relationshipViews;
    
  RelationshipViewFactory(CanvasRenderingContext2D ctx){
    this.relationshipViews = []; 
    this.ctx = ctx;
    setLogicalViews(); 
  }
  
  setLogicalViews(){
    logicalViews = true;
    conceptualViews = false;
    recreateViews();
  }
  
  setConceptualViews(){
    logicalViews = false;
    conceptualViews = true;
    recreateViews();
  }
  
  RelationshipView newRelationshipView(Relationship relationship, BorderInteractionController borderInteractionController){
    RelationshipView relationshipView;
    if(logicalViews)
      relationshipView = new LogicalRelationshipView(ctx, relationship,borderInteractionController);
    if(conceptualViews)
      relationshipView = new ConceptualRelationshipView(ctx, relationship,borderInteractionController);
    
    relationshipViews.add(relationshipView);
    return relationshipView;
  } 
  
  List<RelationshipView> _copyViews(){
    List<RelationshipView> copiedViews = [];
    for(RelationshipView tv in relationshipViews){
      copiedViews.add(tv);
    }
    
    return copiedViews;
  }
  
  void recreateViews(){
    if(!relationshipViews.isEmpty){
      List<RelationshipView> copiedViews = _copyViews();
      BorderInteractionController borderInteractionController = copiedViews[0].borderInteractionController;
      relationshipViews.clear();
      for(RelationshipView rsv in copiedViews){
        RelationshipView newRsv = newRelationshipView(rsv.relationship, borderInteractionController);
        //newRsv.setBoderPoints(rsv.parentBorderPoint, rsv.childBorderPoint);
      }
    }
  }
  
}
