part of coloph;

/** This strategy is triggered when a relationship is right clicked in the canvas **/
class RelationCanvasMenuStrategy extends CanvasInteractionStrategy{
  CanvasRenderingContext2D ctx;
  RelationshipController relationshipController;
  CanvasActionsController canvasActionsContorller;
  Relationship clickedRelationship;
  Element canvasMenu;
  

  RelationCanvasMenuStrategy(CanvasRenderingContext2D ctx, 
                             RelationshipController relationshipController,
                             CanvasActionsController canvasActionsContorller,
                             Relationship clickedRelationship){
    this.ctx = ctx;
    this.relationshipController = relationshipController;
    this.canvasActionsContorller = canvasActionsContorller;
    this.clickedRelationship = clickedRelationship;
    this.canvasMenu = querySelector("#canvas_menu");
  }
  
  void executeMouseDown(Point canvasMousePosition, int clickOrigin){
    if(clickOrigin == CanvasInteractionStrategy.RIGHT_CLICK){
      canvasMenu.nodes.clear();
      _createCanvasMenuEntries();
      _handleDeleteModelButton();
      _handleEditModelButton();
      relationshipController.toggle(clickedRelationship);
      canvasActionsContorller.setDefaultCanvasInteractionContext();
    }
  }
  
  /* Create canvas menu entries related to the relationship */
  _createCanvasMenuEntries(){
    LIElement editModel = new LIElement();
    AnchorElement editModelAnchor = new AnchorElement();
    editModelAnchor.id = "edit_relationship";
    editModel.nodes.add(editModelAnchor);
    
    LIElement deleteModel = new LIElement();
    AnchorElement deleteModelAnchor = new AnchorElement();
    deleteModelAnchor.id = "delete_relationship";
    deleteModel.nodes.add(deleteModelAnchor);
    
    editModelAnchor.text = "Editar relacionamento";
    deleteModelAnchor.text = "Deletar relacionamento";
    
    canvasMenu.nodes.add(editModel);
    canvasMenu.nodes.add(deleteModel);

  }
  
  void _handleDeleteModelButton(){
    Element deleteModelButton = querySelector('#delete_relationship');
    deleteModelButton.onClick.listen((MouseEvent evt)  {
      relationshipController.deleteRelationship(clickedRelationship);
    });
 }
  
  void _handleEditModelButton(){
    Element editModelButton = querySelector("#edit_relationship");
    editModelButton.onClick.listen((MouseEvent evt) {
      relationshipController.editRelationship(clickedRelationship);
    });
  }
}