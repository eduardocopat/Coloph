part of coloph;

class SpecializationController extends BaseCanvasModelController{
  RelationshipDefinitionView specializationDefinition;
  CanvasRenderingContext2D ctx;
  
  List<SpecializationView> specializationViews;
  SpecializationViewFactory specializationViewFactory;
  
  TableController tableController;
  PreferencesController preferencesController;
  DiagramController diagramController;
  HTTPRequestController _HTTPRequestController;
  
  SpecializationController(CanvasRenderingContext2D ctx, SpecializationViewFactory specializationViewFactory){
    this.ctx = ctx;
    this.specializationViews = specializationViewFactory.specializationViews;
    this.specializationViewFactory = specializationViewFactory;
  }
  
  void createSpecializationFromJsonMap(Map map){
    int i = 0;
    while(i < map.length){
        //Table parentTable = tableController.getTable(map[i]["parent_table"]);
        //Table childTable = tableController.getTable(map[i]["child_table"]);
        //Table ternaryTable = tableController.getTable(map[i]["ternary_table"]);
        //Relationship relationship = new Relationship.fromJsonMap(map[i], parentTable, childTable, ternaryTable);
        //_createRelationship(relationship, true);
      
       Table parentTable = tableController.getTable(map[i]["parent_table"]);
       List<Table> specializedTables = [];
       //map specialized tables
       for(int j = 1; j < 10 ; j++){
         String specializedTableIdMapName = "specialized_table_${j}";
         Table specializedTable = tableController.getTable(map[i][specializedTableIdMapName]);
         if(specializedTable != null)
          specializedTables.add(specializedTable);
       }
       Specialization specialization = new Specialization.fromJsonMap(map[i], parentTable, specializedTables);
       _createSpecialization(specialization);
       i++;
      }
  }
  
  void setRequiredControllers(){
    borderInteractionController = this.controllerFactory.getBorderInteractionController();
    tableController = this.controllerFactory.getTableController();
    preferencesController = this.controllerFactory.getPreferencesController();
    diagramController = this.controllerFactory.getDiagramController();
    _HTTPRequestController = this.controllerFactory.getHTTPRequestController();
  }
  
  void newSpecialization(Specialization specialization){
    createSpecializationRequest(specialization);
  }
  
  void createSpecializationRequest(Specialization specialization){
    CreateSpecializationRequest createSpecializationRequest = new CreateSpecializationRequest();
    createSpecializationRequest.setBaseCanvasModel(specialization);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(createSpecializationRequest);
    
    req.onReadyStateChange.listen((Event e) {
      const CREATED = 201;
      if(req.readyState == HttpRequest.DONE){
        if(req.status == CREATED) {
          Map specializationMapped = JSON.decode(req.responseText);
          specialization.id = specializationMapped["id"];
          _createSpecialization(specialization);
          
        }
        else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }
  
  void _createSpecialization(Specialization specialization){
    SpecializationView sv = specializationViewFactory.newSpecializationView(specialization, borderInteractionController);
    
    borderInteractionController.addCanvasModel(specialization);
    sv.setBorderConnections(_createConnections(specialization));
    borderInteractionController.calculateConnectionsLocation();
    
    if(diagramController.isLogical()){
      for(Table table in specialization.specializedTables)
        tableController.createPrimaryKeyForeignKey(specialization.parentTable, table);
    }
  }
  
  void forceUpdateDueToNewPosition(BaseCanvasModel baseCanvasModel){
    UpdateSpecializationRequest updateSpecializationRequest = new UpdateSpecializationRequest();
    updateSpecializationRequest.setBaseCanvasModel(baseCanvasModel);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(updateSpecializationRequest);       
  }

  void updateSpecialization(Specialization specialization, Table specializedTable){
    if(specializedTable != null)
      specialization.addSpecializedTable(specializedTable); //Yes, this is called first, so we can update the database aswell
    UpdateSpecializationRequest updateSpecializationRequest = new UpdateSpecializationRequest();
    updateSpecializationRequest.setBaseCanvasModel(specialization);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(updateSpecializationRequest);    
    
    req.onReadyStateChange.listen((Event e) {
      const CREATED = 201;
      if(req.readyState == HttpRequest.DONE){
        if(req.status == 200 || req.status == 0 || req.status == 204) {
          
          SpecializationView sv = _getSpecializationView(specialization);
          BorderConnection bcn = borderInteractionController.createBorderConnection(specialization, specializedTable);
          sv.addBorderConnection(bcn);
          borderInteractionController.calculateConnectionsLocation();
          
          if(diagramController.isLogical()){
            tableController.createPrimaryKeyForeignKey(specialization.parentTable, specializedTable);
          }
        }          
        else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }
  
  void deleteSpecialization(Specialization specialization){
    DeleteSpecializationRequest deleteSpecializationRequest = new DeleteSpecializationRequest();
    deleteSpecializationRequest.setBaseCanvasModel(specialization);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(deleteSpecializationRequest);    
    
    req.onReadyStateChange.listen((Event e) {
      if(req.readyState == HttpRequest.DONE){
        if(req.status == 200 || req.status == 0 || req.status == 204) {
            SpecializationView sv = _getSpecializationView(specialization);
            specializationViews.remove(sv);
            borderInteractionController.deleteCanvasModel(specialization);
            
            if(diagramController.isLogical()){
              deleteSubsequentForeignKeys(specialization);
            }
            
          }
       else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }
  
  void deleteSubsequentForeignKeys(Specialization specialization){
    //First, we delete all foreign keys from the parent table.
    tableController.deleteAllForeignKeys(specialization.parentTable);
    //But then, because I'm lazy, we update the table to force the creation of foreign keys again.
    //Why is that? Because a table may have more than one relationship
    if(specialization.parentTable != null){
      for(Table table in specialization.specializedTables)
        tableController.updateTable(table, table.name);
    }
  }
  
  void deleteSpecializationFromTable(Table table){
    List<Specialization> specializationsToBeDeleted = [];
    Table tableToBeDisconnected;
    
    for(SpecializationView sv in specializationViews){
      if(sv.specialization.parentTable == table)
        specializationsToBeDeleted.add(sv.specialization);
      else{
        for(Table specializedTable in sv.specialization.specializedTables)
          if(specializedTable == table)
            tableToBeDisconnected = specializedTable;
       
        if(tableToBeDisconnected != null){
          BorderConnection bcn = borderInteractionController.deleteBorderConnection(
            sv.specialization, tableToBeDisconnected
          );
          sv.removeBorderConnection(bcn);
        }
      }
    }
    
    for(Specialization specialization in specializationsToBeDeleted)
      this.deleteSpecialization(specialization);
  }
  
  void highlightSpecialization(Specialization clickedSpecialization, [bool status]){
    SpecializationView sv = _getSpecializationView(clickedSpecialization);
    if(status == true)
      sv.highlighted = true;
    else
      sv.highlighted = false;
  }
  
  List<Table> getSpecializedTables(Table parentTable){
    List<Table> tables = new List<Table>();
    for(SpecializationView specializationView in specializationViews) {
      if(specializationView.specialization.parentTable.id == parentTable.id)
        tables.addAll(specializationView.specialization.specializedTables); 
    }
      
    return tables;
  }
  
  SpecializationView _getSpecializationView(Specialization specialization){
      for(SpecializationView specializationView in specializationViews) {
        if(specializationView.specialization == specialization)
          return specializationView;
      }
  }
  
  List<BorderConnection> _createConnections(Specialization specialization){
    List<BorderConnection> connectionsSpecToTable = new List<BorderConnection>();
    
    BorderConnection bcn = borderInteractionController.createBorderConnection(specialization, specialization.parentTable);
    connectionsSpecToTable.add(bcn);
    
    for(Table table in specialization.specializedTables){
      BorderConnection bcn = borderInteractionController.createBorderConnection(specialization, table);
      connectionsSpecToTable.add(bcn);
    }
    
    return connectionsSpecToTable;
  }
  void drag(BaseCanvasModel baseCanvasModel, Point initialCanvasModelPosition, Point initialClientCord, Point newClientCord){
    num newX = initialCanvasModelPosition.x + (newClientCord.x - initialClientCord.x)  ;
    num newY = initialCanvasModelPosition.y + (newClientCord.y - initialClientCord.y) ;
    
    //If the new X is lower than 5, then it's trying to tresspass the canvas border. 
    //The same apply for Y
    if(newX < 5)
      newX = 5;
    if(newY < 5)
      newY = 5;
    
    // If I have a grid, the table has to be aligned with it
    if(preferencesController.preferences.grid){
      // Rounds to the nearest 10 
      // http://stackoverflow.com/questions/3463920/round-money-to-nearest-10-dollars-in-javascript
      newX = (newX / GRID_SQUARE_SIZE).round() * GRID_SQUARE_SIZE;
      newY = (newY / GRID_SQUARE_SIZE).round() * GRID_SQUARE_SIZE;
    }
    
    Point newXYPoint = new Point(newX.abs()+0.5,newY.abs()+0.5);
    baseCanvasModel.updateLocation(newXYPoint);
    SpecializationView sv = _getSpecializationView(baseCanvasModel);
    if(sv != null)
      sv.updateFillingColorGradient();

    /*When I drag a table, the connections must be recalculated*/
    borderInteractionController.calculateConnectionsLocation();
  
  }
  
  void toggle(BaseCanvasModel baseCanvasModel){
    SpecializationView sv = _getSpecializationView(baseCanvasModel);
    sv.toggled = true;
  }
  
  void untoggleSpecializations(){
    for(SpecializationView sv in specializationViews)
      sv.toggled = false;
  }
  
  void resetModelLocation(BaseCanvasModel baseCanvasModel, Map baseFieldsPosition, Point initialCanvasModelPosition){
    baseCanvasModel.x = initialCanvasModelPosition.x;
    baseCanvasModel.y = initialCanvasModelPosition.y;
  }
  
  Specialization getClickedSpecialization(Point canvasMousePosition){
    for(SpecializationView sv in specializationViews){
      if(canvasMousePosition.x > sv.specialization.x                           &&
          canvasMousePosition.x < sv.specialization.x + sv.specialization.width   &&
          canvasMousePosition.y > sv.specialization.y                           &&
          canvasMousePosition.y < sv.specialization.y + sv.specialization.height){
        return sv.specialization;
      }
    }
    return null;
 }
  
  void drawAllSpecializations(){
    if(this.specializationDefinition != null)
      specializationDefinition.draw();

    for(SpecializationView sv in specializationViews){
      sv.draw();
    }
  }
  
  void createSpecializationDefinition(Point startRel){
    this.specializationDefinition = new RelationshipDefinitionView(startRel,startRel, ctx);
  }
  void deleteSpecializationDefinition(){
    this.specializationDefinition = null;
  }
  void setSpecializationDefinitionEndPoint(Point endRel){
    this.specializationDefinition.endRel = endRel;
  }

  
}