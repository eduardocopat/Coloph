part of coloph;

class CanvasActionsController extends BaseController{
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  TableController tableController;
  RelationshipController relationshipController;
  SpecializationController specializationController;
  BorderInteractionController borderInteractionController;
  DiagramController diagramController;
  
  Element relationshipText;
  Element relationCreationIdentifierRelationship;
  Element relationCreationTernary;
  Element relationCreationNonIdentifierRelationship;
  Element relationCreationSelf;
  Element specializationCreation;
  Element relationCreationManyToMany;
  
  CanvasInteractionStrategy canvasInteractionStrategy;

  SelectionRectangle selectionRectangle;

  CanvasActionsController(CanvasRenderingContext2D ctx){
    this.ctx = ctx;
    this.canvas = ctx.canvas;
    
    canvas.onMouseDown.listen((MouseEvent evt) => _registerMouseDown(evt));
    canvas.onMouseMove.listen((MouseEvent evt) => _registerMouseMove(evt));
    canvas.onMouseUp.listen((MouseEvent evt) => _registerMouseUp(evt));
    canvas.onDoubleClick.listen((MouseEvent evt) => _registerDoubleClick(evt));
    window.onKeyDown.listen((KeyboardEvent evt) => _registerKeyDown(evt));
    
    relationshipText = querySelector("#relationshipText");
    relationCreationIdentifierRelationship = querySelector("#relationCreationIdentifierRelationship");
    relationCreationNonIdentifierRelationship = querySelector("#relationCreationNonIdentifierRelationship");
    relationCreationTernary = querySelector("#relationCreationTernary");
    relationCreationSelf = querySelector("#relationCreationSelf");
    specializationCreation = querySelector("#specializationCreation");
    relationCreationManyToMany = querySelector("#relationCreationManyToMany");
    
    _registerRelationshipCreation();
    _registerTableButton();
  }
  
  void setRequiredControllers(){
    tableController = controllerFactory.getTableController();
    relationshipController = controllerFactory.getRelationshipController();
    borderInteractionController = controllerFactory.getBorderInteractionController();
    specializationController = controllerFactory.getSpecializationController();
    diagramController = controllerFactory.getDiagramController();
  }
  
  void _registerMouseDown(MouseEvent evt){
    Point canvasMousePosition = _getCanvasMousePosition(evt);
    
    tableController.untoggleTables();
    relationshipController.untoggleRelationships();
    specializationController.untoggleSpecializations();
    
    Table clickedTable = tableController.getClickedTable(canvasMousePosition);
    Relationship clickedRelationship = relationshipController.getClickedRelationship(canvasMousePosition);
    TableField clickedTableField = tableController.getClickedTableField(canvasMousePosition);
    RelationshipField clickedRelationshipField = relationshipController.getClickedRelationshipField(canvasMousePosition);
    Specialization clickedSpecialization = specializationController.getClickedSpecialization(canvasMousePosition);
    
    if(evt.which == CanvasInteractionStrategy.LEFT_CLICK){     
      /* Chrome and some others browsers:
       * when you try to drag it changes the cursor to the Selection Cursor
       * this prevents this default action. */
      evt.preventDefault();
      
      /* If the context is the default strategy, clicking on a table may result in a 
       * Table Select and Drag Strategy. */
      if(canvasInteractionStrategy.runtimeType == DefaultStrategy){
        if(clickedTable != null)
          canvasInteractionStrategy = new CanvasModelSelectAndDragStrategy(ctx, clickedTable, tableController, this,  borderInteractionController, diagramController);
        else if(clickedRelationship != null)
          canvasInteractionStrategy = new CanvasModelSelectAndDragStrategy(ctx, clickedRelationship, relationshipController, this,  borderInteractionController, diagramController);
        else if(clickedTableField != null)
          canvasInteractionStrategy = new CanvasModelSelectAndDragStrategy(ctx, clickedTableField, tableController, this,  borderInteractionController, diagramController);
        else if(clickedRelationshipField != null)
          canvasInteractionStrategy = new CanvasModelSelectAndDragStrategy(ctx, clickedRelationshipField, relationshipController, this,  borderInteractionController, diagramController);
        else if(clickedSpecialization != null)
          canvasInteractionStrategy = new CanvasModelSelectAndDragStrategy(ctx, clickedSpecialization, specializationController, this,  borderInteractionController, diagramController);
        else{
          
        }
      }
    } else if(evt.which == CanvasInteractionStrategy.RIGHT_CLICK) {
      if(clickedTable != null){
        canvasInteractionStrategy = new TableCanvasMenuStrategy(ctx, tableController, this, clickedTable);
      } else if(clickedRelationship != null) {
        canvasInteractionStrategy = new RelationCanvasMenuStrategy(ctx, relationshipController, this, clickedRelationship);
      } else if(clickedSpecialization != null) {
        canvasInteractionStrategy = new SpecializationCanvasMenuStrategy(ctx, specializationController, tableController, this, clickedSpecialization);
      } else {
        //defaultStrategy
      }
    } else {
        
    }
    canvasInteractionStrategy.executeMouseDown(canvasMousePosition, evt.which); 
    
  }
  
  void _registerMouseMove(MouseEvent evt){
    Point canvasMousePosition = _getCanvasMousePosition(evt);
    canvasInteractionStrategy.executeCanvasScroll(evt);
    canvasInteractionStrategy.executeMouseMove(canvasMousePosition);
  }

  void _registerMouseUp(MouseEvent evt){
    Point canvasMousePosition = _getCanvasMousePosition(evt);
    canvasInteractionStrategy.executeMouseUp(canvasMousePosition);
  }
  
  void _registerDoubleClick(MouseEvent evt){
    Point canvasMousePosition = _getCanvasMousePosition(evt);
    canvasInteractionStrategy.executeDoubleClick(canvasMousePosition);
  }
  
  void _registerKeyDown(KeyboardEvent evt){
    canvasInteractionStrategy.executeKeyDown(evt);
  }
  
  void _registerRelationshipCreation(){
    
    var popover = js.context["jQuery"]('#relationshipText');
    var options = js.map({
       'placement': 'bottom',
                 'html': 'true',
                 'title' : '<span class="text-info"><strong>Dica</strong></span>'+
                         '<button type="button" id="closepopover" class="close">&times;</button>',
                 'content' : 'Para criar um relacionamento, selecione o tipo a direita, clique na entidade/tabela pai, e depois, na filha.'
      });
     popover.popover(options);
    
    
    relationshipText.onClick.listen((MouseEvent evt){
      js.context["jQuery"]('#relationshipText')["popover"]();
      
      querySelector("#closepopover").onClick.listen((MouseEvent evt2){
        js.context["jQuery"]('#relationshipText')["popover"]("hide");  
      });
    
    
     });
      
      
    
    relationCreationIdentifierRelationship.onClick.listen((MouseEvent evt){
      canvasInteractionStrategy = new RelationshipDefinitionStrategy(
          ctx, tableController, relationshipController, diagramController, this, Relationship.IDENTIFYING_RELATIONSHIP);
    });
    
    relationCreationTernary.onClick.listen((MouseEvent evt){
      canvasInteractionStrategy = new RelationshipTernaryDefinitionStrategy(
          ctx, tableController, relationshipController, this);
    });
    
    relationCreationNonIdentifierRelationship.onClick.listen((MouseEvent evt){
      canvasInteractionStrategy = new RelationshipDefinitionStrategy(
          ctx, tableController, relationshipController, diagramController, this, Relationship.NON_IDENTIFYING_RELATIONSHIP);
    });
    
    relationCreationSelf.onClick.listen((MouseEvent evt){
      canvasInteractionStrategy = new RelationshipDefinitionStrategy(
          ctx, tableController, relationshipController, diagramController, this, Relationship.SELF_RELATIONSHIP);
    });
    
    relationCreationManyToMany.onClick.listen((MouseEvent evt){
      canvasInteractionStrategy = new RelationshipDefinitionStrategy(
          ctx, tableController, relationshipController, diagramController, this, Relationship.MANY_TO_MANY_RELATIONSHIP);
    });
    
    specializationCreation.onClick.listen((MouseEvent evt){
      canvasInteractionStrategy = new SpecializationStrategy(
          ctx, tableController, specializationController, diagramController, this);
    });
    
    //relationCreationManyToMany.onClick.listen((MouseEvent evt){
    //  
    //});
  }
  
  void _registerTableButton(){
    Element createTableButton = querySelector('#openTableModal');
    createTableButton.onClick.listen((MouseEvent evt)  {
      tableController.newTable();
     
    });
  }
  
  void setCanvasInteractionContext(CanvasInteractionStrategy canvasInteractionStrategy){
    this.canvasInteractionStrategy = canvasInteractionStrategy;
  }
  
  void setDefaultCanvasInteractionContext(){
    canvasInteractionStrategy = new DefaultStrategy(ctx, tableController, relationshipController);
  }

  /** Gets the mouse position in the canvas*/
  // Using this: 
  //http://stackoverflow.com/questions/10564350/how-do-you-get-the-x-and-y-from-a-mouse-click-on-an-html5-canvas-in-dart/10564377#10564377 
  Point _getCanvasMousePosition(MouseEvent evt){
    num x;
    num y;
    
    Rectangle rect = ctx.canvas.getBoundingClientRect();
    Point clientBoundingRect = new Point(rect.left, rect.top);
    
    /*Sometimes it doesn't find the clientBoundingRect, so I define it by the offsetLeft and Top.
     * it doesn't work onn the screen is not fullscreen, but this is just a milisecond thing*/
    if(clientBoundingRect == null){
      x = evt.client.x - canvas.offsetLeft;
      y = evt.client.y - canvas.offsetTop;
    } else {
      x = evt.client.x - clientBoundingRect.x;
      y = evt.client.y - clientBoundingRect.y;
   
    }
    return new Point(x, y);
  }
  
  void drawSelectionRectangle(){
    if(selectionRectangle != null)
      selectionRectangle.draw();
  }

}


