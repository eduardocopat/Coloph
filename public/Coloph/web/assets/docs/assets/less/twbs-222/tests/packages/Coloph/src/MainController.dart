part of coloph;

// In order to quick debug this, you can remove the authorization in the rails diagram controller
class MainController {
  CanvasElement               canvas;
  CanvasRenderingContext2D    ctx;
  ControllerFactory           controllerFactory;
  TableController             tableController;
  CanvasActionsController     canvasActionsController;
  RelationshipController      relationshipController;
  PreferencesController       preferencesController;
  SpecializationController    specializationController;
  DiagramController           diagramController;
  
  MainController(CanvasElement canvas){
    js.context["jQuery"].noConflict();
    js.context["jQuery"]('#canvas')["contextmenu"]();
    
    this.canvas = canvas;
    
    //Define the canvas div size and the canvas size based on the browser window size
    this.defineCanvasDivSize();
    
    int canvasDivStyleHeight = _stringNumberInPixelsToInt(canvas.parent.style.height);
    int canvasStyleDivWidth = _stringNumberInPixelsToInt(canvas.parent.style.width);
    this.defineCanvasSize(canvasDivStyleHeight, canvasStyleDivWidth);
    
    this.ctx = this.canvas.getContext("2d");
    this.ctx.font = FONT_TYPE_AND_SIZE;
    int diagramId = int.parse(querySelector("#diagram_id").title); //title is a dummy var
   
        
    this.controllerFactory = new ControllerFactory(this.ctx, diagramId);
    this.tableController = this.controllerFactory.getTableController();
    this.relationshipController = this.controllerFactory.getRelationshipController();
    this.canvasActionsController = this.controllerFactory.getCanvasActionsController();
    this.preferencesController = this.controllerFactory.getPreferencesController();
    this.specializationController = this.controllerFactory.getSpecializationController(); 
    this.diagramController = this.controllerFactory.getDiagramController();
    
    this.canvasActionsController.setDefaultCanvasInteractionContext();
    
    _setDiagramType();
    diagramController.loadBaseCanvasModels();
    diagramController.setNavBar();
    
    //If the user changes the browser window size, it recalculates the canvasDivSize
    window.onResize.listen((Event evt) => _handleWindowResize());
    
    //Open the Preferences modal when the option is clicked
    querySelector("#preferences").onClick.listen((Event evt) => preferencesController.showModal());
    
    //Canvas anti-alising
    //ctx.translate(0.5, 0.5);
    this.startRendering();
  }

  void _setDiagramType(){
    diagramController.readDiagramData();
    
    if(diagramController.isConceptual())
      controllerFactory.setConceptual();
    if(diagramController.isLogical())
      controllerFactory.setLogical();
    
  }
  
  void _handleConceptualModelChoice(){
    controllerFactory.setConceptual();
  }
  
  void _handleLogicalModelChoice(){
    controllerFactory.setLogical();
  }

  void startRendering(){
    window.requestAnimationFrame(redraw);
  }

  void redraw(num time){
    this.drawEVERYONE();
    window.requestAnimationFrame(redraw);
  }

  void drawEVERYONE(){
    ctx.clearRect(0,0, ctx.canvas.width, ctx.canvas.height);
    
    canvasActionsController.drawSelectionRectangle();
    relationshipController.drawAllRelations();
    specializationController.drawAllSpecializations();
    tableController.drawAllTables();
    
    //Toggled Table or Table Fields must be drawn in the last or they are not rendered correctly
    tableController.drawToggledOptimization();
  }

  /** Define canvas div size based on the browser resolution*/
  void defineCanvasDivSize(){
    int navbarSize = 38;
    int scrollAndFooterSize = 6;
    int _canvasDivHeight = window.innerHeight - (navbarSize * 2) - scrollAndFooterSize;
    int _canvasDivWidth = window.innerWidth;
    
    DivElement canvasDiv = canvas.parent;
    canvasDiv.style.overflow = "scroll";
    canvasDiv.style.backgroundColor = "#F8F8F8";
    
    canvasDiv.style.height = "${_canvasDivHeight}px";
    canvasDiv.style.width = "${_canvasDivWidth}px";
  }
  
  /* @TODO e se antes tiver uma tabela que ocupe mais, preciso buscar o maior x,y do table controller né...*/
  void defineCanvasSize(int canvasDivStyleHeight, int canvasDivStyleWidth){
    this.canvas.width = canvasDivStyleWidth - 21;
    this.canvas.height = canvasDivStyleHeight  - 25;
    
    /* Note: Changing the width and height of canvas makes it clear the canvas,
     * So I have to reset its presets */   
    canvas.context2D.font = '10pt Helvetica';
  }
  
  void _handleWindowResize(){
    int canvasDivStyleHeight = _stringNumberInPixelsToInt(canvas.parent.style.height);
    int canvasStyleDivWidth = _stringNumberInPixelsToInt(canvas.parent.style.width);
    this.defineCanvasDivSize();
    
    /*This was thought if the following occur: The user stats with the window no maximize
     * and then maximize it, the canvas has to complete all div again*/
    if(canvasDivStyleHeight > canvas.height || canvasStyleDivWidth > canvas.width)
      defineCanvasSize(canvasDivStyleHeight, canvasStyleDivWidth );
  }
  
  int _stringNumberInPixelsToInt(String numberInPixels){
    return int.parse(numberInPixels.replaceAll("px", ""));
  }
  
}
