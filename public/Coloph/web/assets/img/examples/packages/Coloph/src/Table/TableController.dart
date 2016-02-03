part of coloph;

class TableController extends BaseCanvasModelController{
  CanvasRenderingContext2D ctx;
  List<TableView> tableViews;
  TableViewFactory tableViewFactory;
  
  RelationshipController relationshipController;
  CanvasActionsController canvasActionsController;
  CommandController commandController;
  PreferencesController preferencesController;
  SpecializationController specializationController;
  HTTPRequestController _HTTPRequestController;
  DiagramController diagramController;
  
  TableModalFactory tableModalFactory;
  TableModal tableModal;

  TableController(CanvasRenderingContext2D ctx, TableViewFactory tableViewFactory, TableModalFactory tableModalFactory){
    this.ctx = ctx;
    this.tableViewFactory = tableViewFactory;
    this.tableModalFactory = tableModalFactory;
    tableViews = tableViewFactory.tableViews;
  }
  
  void createTablesFromJsonMap(Map map){
    int i = 0;
    while(i < map.length){
      Table table = new Table.fromJsonMap(map[i]); 
      _createTable(table, false);
      i++;
    }
  }

  void setRequiredControllers(){
    relationshipController = controllerFactory.getRelationshipController();
    borderInteractionController = controllerFactory.getBorderInteractionController();
    canvasActionsController = controllerFactory.getCanvasActionsController();
    commandController = controllerFactory.getCommandController();
    preferencesController =  controllerFactory.getPreferencesController();
    specializationController = controllerFactory.getSpecializationController();
    diagramController = controllerFactory.getDiagramController();
    _HTTPRequestController = controllerFactory.getHTTPRequestController();
  }
  
  void newTable(){
    int diagramId = diagramController.getDiagramId();
    Table newTable = new Table(diagramId, null, 50, 50, null);
    showModal(newTable);
  }
  
  void validate(Table table, TableModal tableModal){
    ValidateTableRequest validateTableRequest = new ValidateTableRequest();
    validateTableRequest.setBaseCanvasModel(table);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(validateTableRequest);
    
    Map errors = table.validate();
    if(errors.length != 0){
      tableModal.receiveErrorsFromTableValidation(table, errors);
      return;
    }
    
    // add an event handler that is called when the request finishes
    req.onReadyStateChange.listen((Event e) {
      if(req.readyState == HttpRequest.DONE)
      {
        if(req.status == 200 || req.status == 0 || req.status == 204) {
          //send no errors
          tableModal.receiveErrorsFromTableValidation(table, new Map());
        }
        else if(req.status == 422){
          Map errors = JSON.decode(req.responseText);
          tableModal.receiveErrorsFromTableValidation(table, errors);
        }
      }
    });
    
    //_validateTableFields(table.tableFields, tableModal);
  }
  
  void createTableRequest(Table table, bool userCreated){
    CreateTableRequest createTableHTTPRequest = new CreateTableRequest();
    createTableHTTPRequest.setBaseCanvasModel(table);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(createTableHTTPRequest);
    
    req.onReadyStateChange.listen((Event e) {
      const CREATED = 201;
      if(req.readyState == HttpRequest.DONE)
      {
        if(req.status == CREATED) {
          //Get the created table's id
          Map tableMapped = JSON.decode(req.responseText);
          table.id = tableMapped["id"];
          //Map tableField Ids
          _mapFieldsIds(table, tableMapped, "table_fields", "table_sub_fields");
          
          _createTable(table, userCreated);
        }
        else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }
  
  void _createTable(Table table, bool userCreated){
    borderInteractionController.addCanvasModel(table);
    for(TableField tableField in table.tableFields){
      if(tableField.isForeignKey()){
        continue;
      }
      borderInteractionController.addCanvasModel(tableField);
      
      for(TableField subTableField in tableField.baseSubFields){
        borderInteractionController.addCanvasModel(subTableField);
      }
    }
    
    TableView tableView = tableViewFactory.newTableView(table, borderInteractionController, this);
    
    //If the user is creating the table, then he/she needs to define its place in the canvas :)
    if(userCreated){
      canvasActionsController.setCanvasInteractionContext(new TableCreationStrategy(ctx, this, canvasActionsController, table));
    }
    CanvasScroller canvasScroller = new CanvasScroller(ctx.canvas);
    canvasScroller.increaseCanvasByObject(tableView.table.x, tableView.table.y, tableView.table.width, tableView.table.height);
    
    borderInteractionController.calculateConnectionsLocation();
  }
    
  void editTable(Table table){
    //Sends a cloned table in order to not alter the original table
    Table clonedTable = table.clone();
    showModal(clonedTable);
  }
  
  void updateTable(Table table, [String oldTableName]){
    Table originalTable = getTable(oldTableName);
    updateTableRequest(originalTable, table);
  }
  
  void forceUpdateDueToNewPosition(BaseCanvasModel baseCanvasModel){
    Table table;
    for(TableView tv in tableViews){
      table = _getParentModel(baseCanvasModel, tv.table);
      if(table != null)
        break;
    }
    
    updateTable(table, table.name);
  }
  
  // The reason behind the original Table and Table is the fact we need them to
  // the Commands (Redo/Undo)
  void updateTableRequest(Table originalTable, Table table){
    if(originalTable == null || table == null){
      return;
    }
    
    UpdateTableRequest updateTableRequest = new UpdateTableRequest();
    updateTableRequest.setOldBaseCanvasModel(originalTable);
    updateTableRequest.setBaseCanvasModel(table);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(updateTableRequest);
    
    req.onReadyStateChange.listen((Event e){
      if(req.readyState == HttpRequest.DONE){
        if(req.status == 200 || req.status == 0 || req.status == 204) {
          //The table I receive is a cloned table( @editTable )
          //So I substitute the original one to the cloned one.
          Map tableMapped = JSON.decode(req.responseText);
          table.id = tableMapped["id"];
          _mapFieldsIds(table, tableMapped, "table_fields", "table_sub_fields");
          
          updateCanvasModel(originalTable, table);
                    
          TableView tableView = _getTableView(originalTable);
          tableView.updateTable(table);
          
          tableView.calcSizeProperties();
          borderInteractionController.calculateConnectionsLocation();
          
          relationshipController.updateRelationshipsWithTable(table);
          _recreateForeignKeys(table);
          req.abort();
        }
        else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }
  
  void deleteTable(Table table){
    DeleteTableRequest deleteTableRequest = new DeleteTableRequest();
    deleteTableRequest.setBaseCanvasModel(table);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(deleteTableRequest);
    
    req.onReadyStateChange.listen((Event e) {
      if(req.readyState == HttpRequest.DONE){
        if(req.status == 200 || req.status == 0 || req.status == 204) {
          
          TableView tableView = _getTableView(table);
          tableViews.remove(tableView);
          relationshipController.deleteRelationshipsFromTable(table);
          specializationController.deleteSpecializationFromTable(table);
          
          borderInteractionController.deleteCanvasModel(table);
          borderInteractionController.calculateConnectionsLocation();
          
          for(TableField tableField in table.getFields()){
            borderInteractionController.deleteCanvasModel(tableField);
            for(TableField subTableField in tableField.getFields()){
              borderInteractionController.deleteCanvasModel(subTableField);  
            }
          }
          
          req.abort();
        }
        else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }
  
  void _recreateForeignKeys(Table table){
    for(Table weakTable in relationshipController.getTablesWeakedByRelationshipFrom(table)){
      List<TableField> deletedForeignKeys = weakTable.deleteForeignKey(table);
      for(TableField tableField in deletedForeignKeys){
        borderInteractionController.deleteCanvasModel(tableField);
        for(TableField subTableField in tableField.getFields())
          borderInteractionController.deleteCanvasModel(subTableField);
      }
      createPrimaryKeyForeignKey(table, weakTable);
    }
    
    if(diagramController.isLogical()){
      for(Table weakTable in relationshipController.getTablesNotWeakedByRelationshipFrom(table)){
        List<TableField> deletedForeignKeys = weakTable.deleteForeignKey(table);
        for(TableField tableField in deletedForeignKeys){
          borderInteractionController.deleteCanvasModel(tableField);
          for(TableField subTableField in tableField.getFields())
            borderInteractionController.deleteCanvasModel(subTableField);
        }
        createNonPrimaryKeyForeignKey(table, weakTable);
      }
    }
    
    for(Table specializedTable in specializationController.getSpecializedTables(table)){
      List<TableField> deletedForeignKeys = specializedTable.deleteForeignKey(table);   
      for(TableField tableField in deletedForeignKeys){
        borderInteractionController.deleteCanvasModel(tableField);
        for(TableField subTableField in tableField.getFields())
          borderInteractionController.deleteCanvasModel(subTableField);
      }
      createPrimaryKeyForeignKey(table, specializedTable);
    }
  }
  
  void createPrimaryKeyForeignKey(Table parentTable, Table childTable){
    _copyPrimaryKeyToForeignKey(parentTable, childTable);    
    updateTable(childTable, childTable.name);
  }
  
  void createNonPrimaryKeyForeignKey(Table parentTable, Table childTable){
    _copyNonPrimaryKeyToForeignKey(parentTable, childTable);    
    updateTable(childTable, childTable.name);
  }
  
  void createForeignKeyForTernary(Table parentTable, Table ternaryTable){
    _copyPrimaryKeyToForeignKey(parentTable, ternaryTable);
    updateTable(ternaryTable, ternaryTable.name);
  }
  
  void _copyPrimaryKeyToForeignKey(Table parentTable, Table childTable){
    parentTable.deletePrimaryKeyFieldsWithSameName(childTable);
    //Cloning parent table so we actually create different fields
    Table clonedParentTable = parentTable.clone();
    List<TableField> parentPrimaryKeys = new List<TableField>();
    for(TableField tableField in clonedParentTable.getFields()){
      if(tableField.primaryKey){  
           tableField.foreignKey = new ForeignKey(true, parentTable.id);
        
        
        for(TableField subTableField in tableField.getFields()){
          subTableField.foreignKey = new ForeignKey(true, parentTable.id);
          subTableField.id = null;
        }
        tableField.id = null;
        parentPrimaryKeys.add(tableField);
      }
    }
    
    int i = 0;
    for(TableField tableField in parentPrimaryKeys){
      childTable.getFields().insert(i, tableField);
      i++;
    }
  }
  
  void _copyNonPrimaryKeyToForeignKey(Table parentTable, Table childTable){
    parentTable.deleteNonPrimaryKeyFieldsWithSameName(childTable);
    //Cloning parent table so we actually create different fields
    Table clonedParentTable = parentTable.clone();
    List<TableField> parentPrimaryKeys = new List<TableField>();
    for(TableField tableField in clonedParentTable.getFields()){
      if(tableField.primaryKey){    
           tableField.foreignKey = new ForeignKey(true, parentTable.id);
        for(TableField subTableField in tableField.getFields()){
          subTableField.foreignKey = new ForeignKey(true, parentTable.id);
          subTableField.id = null;
        }
        tableField.id = null;
        parentPrimaryKeys.add(tableField);
      }
    }
    
    int i = 0;
    for(TableField tableField in parentPrimaryKeys){
      tableField.primaryKey = false; //!
      childTable.getFields().insert(i, tableField);
      i++;
    }
  }
  

  
  void deleteAllForeignKeys(Table table){
    for(TableView tv in tableViews){
      List<TableField> deletedForeignKeys = tv.table.deleteForeignKey(table);
      for(TableField tableField in deletedForeignKeys){
        borderInteractionController.deleteCanvasModel(tableField);
        for(TableField subTableField in tableField.getFields())
          borderInteractionController.deleteCanvasModel(subTableField);
      }
      updateTable(tv.table, tv.table.name);
    }
    
    borderInteractionController.calculateConnectionsLocation();
  }
  
  void resetModelLocation(BaseCanvasModel baseCanvasModel, Map baseFieldsPosition, Point initialCanvasModelPosition){
    baseCanvasModel.x = initialCanvasModelPosition.x;
    baseCanvasModel.y = initialCanvasModelPosition.y;
    
    for(BaseCanvasModel baseField in baseCanvasModel.getFields()){
      baseField.x = baseFieldsPosition[baseField].x;
      baseField.y = baseFieldsPosition[baseField].y;
      
      for(BaseField baseSubField in baseField.getFields()){
        baseSubField.x = baseFieldsPosition[baseSubField].x;
        baseSubField.y = baseFieldsPosition[baseSubField].y;
          
      }
    }
    borderInteractionController.calculateConnectionsLocation();
  }
    
  void showModal(Table table){
    if(tableModal != null)
      tableModal.cancelSubmitListener();
    
    tableModal = tableModalFactory.newTableModal(table, this, diagramController.isPhysical());
  }


  void drawAllTables(){
    for(TableView tv in tableViews){
      if(diagramController.isPhysical())
        tv.setPhysical(true);
      else
        tv.setPhysical(false);
      
        tv.draw();
    }
  }
  
  void drawToggledOptimization(){
    for(TableView tv in tableViews){
      tv.drawToggled();
    }
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
    TableView draggedTableView = _getTableView(baseCanvasModel);
    if(draggedTableView != null)
      draggedTableView.updateFillingColorGradient();

    /*When I drag a table, the connections must be recalculated*/
    borderInteractionController.calculateConnectionsLocation();
  }
  

 
  /** Method to highlight a table. In our case, change the borders to gray*/
  void highlightTable(Table table, [bool status]){
    TableView tableView = _getTableView(table);
    if(status == true)
      tableView.highlighted = true;
    else
      tableView.highlighted = false;
  }

  /** Method to toggle a table and make it the active one**/
  void toggle(BaseCanvasModel baseCanvasModel){
    TableView tableView = _getTableView(baseCanvasModel);
    if(tableView != null){
      tableView.toggled = true;
      return; 
    }
    
    for(TableView tv in tableViews){
      for(TableField tf in tv.table.tableFields){
        if(tf == baseCanvasModel){
          tv.toggledTableField = baseCanvasModel;
          return;
        }
        for(TableField subTf in tf.baseSubFields){
          tv.toggledTableField = baseCanvasModel;
          return;
        }
      }
    }
  }
    
  void untoggleTables(){
    for(TableView tableView in tableViews){
      tableView.toggled = false;
      tableView.toggledTableField = null; //pau?
    }
  }

 TableView _getTableView(Table table) {
   for(TableView tableView in tableViews)   {
     if(tableView.table == table)
       return tableView;
   }
 }

 Table getTable(String tableName)
 {
   for(TableView tableView in tableViews)
   {
     if(tableView.table.name == tableName)
       return tableView.table;
   }
 }

 /** Get the the clicked table **/
 Table getClickedTable(Point canvasMousePosition){
  for(TableView tableView in tableViews){
    if(canvasMousePosition.x > tableView.table.x                           &&
       canvasMousePosition.x < tableView.table.x + tableView.table.width   &&
       canvasMousePosition.y > tableView.table.y                           &&
       canvasMousePosition.y < tableView.table.y + tableView.table.height){
          return tableView.table;
       }
    }
    return null;
 }
 
 TableField getClickedTableField(Point canvasMousePosition){
   for(TableView tableView in tableViews){
     for(TableField tableField in tableView.table.tableFields){
       if(canvasMousePosition.x > tableField.x                       &&
           canvasMousePosition.x < tableField.x + tableField.width   &&
           canvasMousePosition.y > tableField.y                      &&
           canvasMousePosition.y < tableField.y + tableField.height){
         return tableField;
       } 
       for(TableField subTableField in tableField.baseSubFields){
         if(canvasMousePosition.x > subTableField.x                       &&
             canvasMousePosition.x < subTableField.x + subTableField.width   &&
             canvasMousePosition.y > subTableField.y                      &&
             canvasMousePosition.y < subTableField.y + subTableField.height){
           return subTableField;
         } 
       }
     }
   }
   return null;
 }

 String getViewType(){
   return tableViewFactory.getViewType();
 }
/*
  void createFakeTables(){
    
    Math.Random rng = new Math.Random();
    
    List<TableField> tabela0SubFields = [];
    tabela0SubFields.add(new TableField("Rua", false, new ForeignKey(false,-1), false, false, false, false,null));
    tabela0SubFields.add(new TableField("Número", false, new ForeignKey(false,-1), false, false, false, false,null));
    
    List<TableField> tabela0Fields = [];
    tabela0Fields.add(new TableField("Nome", true, new ForeignKey(false,-1), false, false, false, false, null));
    tabela0Fields.add(new TableField("Endereço", true, new ForeignKey(false,-1), false, true, false, false, tabela0SubFields));
    tabela0Fields.add(new TableField("Salário", false, new ForeignKey(false,-1), false, false, false, false,null));
    Table table0 = new Table(diagramController.getDiagramId(), "Funcionário${rng.nextInt(999999)}" , 250 ,250 , tabela0Fields); 
    
    
    //TableView tabela0  = tableViewFactory.newTableView(table0);
  
    List<TableField> tabela1Fields = [];
    tabela1Fields.add(new TableField("Id", true, new ForeignKey(false,-1), false, false, false, false,null));
    tabela1Fields.add(new TableField("Nome projeto", true, new ForeignKey(false,-1), false, false, false, false,null));
    tabela1Fields.add(new TableField("Budget", false, new ForeignKey(false,-1), true, false, false, true,null));
    tabela1Fields.add(new TableField("Numero de pessoas",  false, new ForeignKey(false,-1), false, false, false, false,null));
    tabela1Fields.add(new TableField("Campo 1", false, new ForeignKey(false,-1), false, false, true, false,null));
    tabela1Fields.add(new TableField("Campo 2 também chave",  false, new ForeignKey(false,-1), false, false, false, false,null));
    tabela1Fields.add(new TableField("Número 3",  false, new ForeignKey(false,-1), false, false, false, false,null));
    Table table1 = new Table(diagramController.getDiagramId(),"P${rng.nextInt(999999)}", 1000, 500, tabela1Fields);
    //TableView tabela1 = tableViewFactory.newTableView(table1);
    
    List<TableField> tabela2Fields = [];
    tabela2Fields.add(new TableField("Campo1", true, new ForeignKey(false,-1), false, false, false, false,null));
    tabela2Fields.add(new TableField("Campo2", true, new ForeignKey(false,-1), false, false, false, false,null));
    tabela2Fields.add(new TableField("Outro campo", false, new ForeignKey(false,-1), false, false, false, false,null));
    Table table2 = new Table(diagramController.getDiagramId(),"Outra${rng.nextInt(999999)}" , 1200 ,250 , tabela2Fields);
    
    List<TableField> tabela3Fields = [];
    tabela3Fields.add(new TableField("Nome", true, new ForeignKey(false,-1), false, false, false, false,null));
    tabela3Fields.add(new TableField("numeroPessoas", true, new ForeignKey(false,-1), false, false, false, false,null));
    tabela3Fields.add(new TableField("gerenteDeProjetos", false, new ForeignKey(false,-1), false, false, false, false,null));
    Table table3 = new Table(diagramController.getDiagramId(),"Projeto${rng.nextInt(999999)}" , 150 ,650 , tabela3Fields);
    
    createTableRequest(table0, false);
    createTableRequest(table1, false);
    createTableRequest(table2, false);
    createTableRequest(table3, false);
    
    Relationship relationship = new Relationship(diagramController.getDiagramId(), table0, table1, Relationship.IDENTIFYING_RELATIONSHIP, new List<BaseField>());
    relationship.name = 'relaci';
    relationship.childCardinality = "(0,1)";
    relationship.parentCardinality = "(0,1)";
    //relationshipController.createRelationship(relationship);
    
    
    //relationshipController.createRelationship(new Relationship(table0, table1, "whatever"));
    
    for(TableView tv in tableViews){
      tv.toggled = false;
    }
    
  }
  */
}