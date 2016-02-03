part of coloph;

class RelationshipController extends BaseCanvasModelController{
  CanvasRenderingContext2D ctx;

  List<RelationshipView> relationshipViews;
  RelationshipViewFactory relationshipViewFactory;
  
  RelationshipDefinitionView relationshipDefinition;
  
  TableController tableController;
  PreferencesController preferencesController;
  HTTPRequestController _HTTPRequestController;
  DiagramController diagramController;
  
  RelationshipModalFactory relationshipModalFactory;
  RelationshipModal relationshipModal;
  
  Relationship oldRelationship;
  
  RelationshipController(CanvasRenderingContext2D ctx, RelationshipViewFactory relationshipViewFactory,  RelationshipModalFactory relationshipModalFactory ){
    this.ctx = ctx;
    this.relationshipViewFactory = relationshipViewFactory;
    this.relationshipModalFactory = relationshipModalFactory;
    this.relationshipViews = relationshipViewFactory.relationshipViews;
  }
  
  void setRequiredControllers(){
    this.tableController = this.controllerFactory.getTableController();
    this.borderInteractionController = this.controllerFactory.getBorderInteractionController();
    this.preferencesController =  this.controllerFactory.getPreferencesController();
    this._HTTPRequestController = this.controllerFactory.getHTTPRequestController();
    this.diagramController = this.controllerFactory.getDiagramController();
  }
  
  void createRelationshipsFromJsonMap(Map map){
    int i = 0;
    while(i < map.length){
        Table parentTable = tableController.getTable(map[i]["parent_table"]);
        Table childTable = tableController.getTable(map[i]["child_table"]);
        Table ternaryTable = tableController.getTable(map[i]["ternary_table"]);
        Relationship relationship = new Relationship.fromJsonMap(map[i], parentTable, childTable, ternaryTable);
        _createRelationship(relationship, true);
        i++;
      }
  }
  
  void newRelationship(Relationship relationship){
    relationship.name = "";
    relationship.nullAllowed = Relationship.NOT_ALLOW_NULLS;
    relationship.parentCardinality = Relationship.ZERO_OR_ONE;
    showModal(relationship, BaseModal.CREATE);
  }
  
  Map validate(Relationship relationship, RelationshipModal relationshipModal){
    ValidateRelationshipRequest validateRelationshipRequest = new ValidateRelationshipRequest();
    validateRelationshipRequest.setBaseCanvasModel(relationship);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(validateRelationshipRequest);
    
    req.onReadyStateChange.listen((Event e) {
      if(req.readyState == HttpRequest.DONE) {
        if(req.status == 200 || req.status == 0 || req.status == 204) {
          //send no errors
          relationshipModal.receiveErrorsFromValidation(new Map());
        }
        else if(req.status == 422)
        {
          Map errors = JSON.decode(req.responseText);
          relationshipModal.receiveErrorsFromValidation(errors);
        }
      }
    });
  }
  
  void createRelationship(Relationship relationship){
    CreateRelationshipRequest createRelationshipRequest = new CreateRelationshipRequest();
    createRelationshipRequest.setBaseCanvasModel(relationship);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(createRelationshipRequest);
    
    req.onReadyStateChange.listen((Event e) {
      const CREATED = 201;
      if(req.readyState == HttpRequest.DONE){
        if(req.status == CREATED) {
          Map relationshipMapped = JSON.decode(req.responseText);
          relationship.id = relationshipMapped["id"];
          _mapFieldsIds(relationship, relationshipMapped, "relationship_fields", "relationship_sub_fields");
          
          _createRelationship(relationship, false);
          
          //_registerConnectionsUpdated(relationship, bcn);
          
        }
        else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }

  void _createRelationship(Relationship relationship, bool fromDatabase){
    RelationshipView rsv = relationshipViewFactory.newRelationshipView(relationship, borderInteractionController);
    if(relationshipViewFactory.getViewType() == ViewFactory.CONCEPTUAL){
      _createConceptual(relationship, rsv);
      if(relationship.identifying){
         tableController.createPrimaryKeyForeignKey(relationship.parentTable, relationship.childTable);
      }
    }
    else{
      _createLogical(relationship, rsv);
      if(relationship.identifying){
         tableController.createPrimaryKeyForeignKey(relationship.parentTable, relationship.childTable);
      }
      if(relationship.dataType == Relationship.NON_IDENTIFYING_RELATIONSHIP){
        tableController.createNonPrimaryKeyForeignKey(relationship.parentTable, relationship.childTable);
      }
    }
    
    if(fromDatabase == false){
      oldRelationship = relationship; 
      updateRelationship(relationship);
    }

  }
  
  void _createConceptual(Relationship relationship, RelationshipView rsv){
    _createRelationshipNameDiamond(relationship);
    borderInteractionController.addCanvasModel(relationship);
    BorderConnection bcnParentTableAndRelationship = borderInteractionController.createBorderConnection(relationship.parentTable, relationship);
    BorderConnection bcnChildTableAndRelationship = borderInteractionController.createBorderConnection(relationship.childTable, relationship);
    
    for(RelationshipField relationshipField in relationship.relationshipFields){
      borderInteractionController.addCanvasModel(relationshipField);
      for(RelationshipField subRelationshipField in relationshipField.baseSubFields){
        borderInteractionController.addCanvasModel(subRelationshipField);
      }
    }
    
    _createTernary(relationship, rsv);
    rsv.glueRelationshipFields();
    borderInteractionController.calculateConnectionsLocation();
    _updateRelationshipBorderConnections(relationship, bcnParentTableAndRelationship, bcnChildTableAndRelationship);
  }
  
  void _createLogical(Relationship relationship, RelationshipView rsv){
    BorderConnection bcnParentTableAndRelationship = borderInteractionController.createBorderConnection(relationship.parentTable, relationship.childTable);
    rsv.setBorderConnection(bcnParentTableAndRelationship);
  }
  
  void _createRelationshipNameDiamond(Relationship relationship){
    num nameWidth = ctx.measureText(relationship.name).width;
    if(relationship.width == 0 && relationship.height == 0) //if the relationship is new
      relationship.createNameDiamond(nameWidth);
    else //if the relationship is being create from the database
      relationship.updateNameDiamond(nameWidth);
  }
  
  /*
  void _registerPointsUpdated(Relationship relationship, BorderConnection bcn){
    bcn.pointsUpdated.listen((_) =>
        //_updateRelationshipBorderConnections(relationship, bcn.borderPointA, bcn.borderPointB)
    
  }
  */
  
  void forceUpdateDueToNewPosition(BaseCanvasModel baseCanvasModel){
    Relationship relationship;
    for(RelationshipView rsv in relationshipViews){
      relationship = _getParentModel(baseCanvasModel, rsv.relationship);
      if(relationship != null)
        break;
    }
    
    oldRelationship = relationship;
    updateRelationship(relationship);
  }
  
  void _updateRelationshipBorderConnections(Relationship relationship, BorderConnection bcnParentTableAndRelationship, BorderConnection bcnChildTableAndRelationship){
    for(RelationshipView rsv in relationshipViews){
      if(rsv.relationship == relationship){
        rsv.setBorderConnections(bcnParentTableAndRelationship, bcnChildTableAndRelationship);
      }
    }
  }
    
  void editRelationship(Relationship relationship, [bool isTernary, Table ternaryTable]){
    Relationship clonedRelationship = relationship.clone();
    oldRelationship = relationship; 
    if(isTernary)
      setTernaryValues(clonedRelationship, ternaryTable);
      
    showModal(clonedRelationship, BaseModal.EDIT);
  }
  
  void updateRelationship(Relationship relationship){
   
    UpdateRelationshipRequest updateRelationshipRequest = new UpdateRelationshipRequest();
    updateRelationshipRequest.setOldBaseCanvasModel(oldRelationship);
    updateRelationshipRequest.setBaseCanvasModel(relationship);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(updateRelationshipRequest);
    
    req.onReadyStateChange.listen((Event e) {
      if(req.readyState == HttpRequest.DONE){
        if(req.status == 200 || req.status == 0 || req.status == 204) {
          Map relationshipMapped = JSON.decode(req.responseText);
          relationship.id = relationshipMapped["id"];
          _mapFieldsIds(relationship, relationshipMapped, "relationship_fields", "relationship_sub_fields");
          
          RelationshipView relationshipView = _getRelationshipView(oldRelationship);
          updateCanvasModel(oldRelationship, relationship);
          relationshipView.updateRelationship(relationship);
          
          //_createRelationshipNameDiamond(relationship);
          relationship.updateNameDiamond(ctx.measureText(relationship.name).width);
          
          _createTernary(relationship, relationshipView);
          //BorderConnection bcnParentTableAndRelationship = borderInteractionController.createBorderConnection(relationship.parentTable, relationship);
          //BorderConnection bcnChildTableAndRelationship = borderInteractionController.createBorderConnection(relationship.childTable, relationship);
          
          relationshipView.glueRelationshipFields();
                    
          borderInteractionController.calculateConnectionsLocation();
         //_updateRelationshipBorderConnections(relationship, bcnParentTableAndRelationship, bcnChildTableAndRelationship);
          
          }
       else{
          if(diagramController.isConceptual()){
            window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
          }
       }
      }
      
    });
  }
  
  //String url = "/tables/${tableId}.json";
  //req.open("DELETE", url); // Use POST http method to send data in the next call
  void deleteRelationship(Relationship relationship){
    DeleteRelationshipRequest deleteRelationshipRequest = new DeleteRelationshipRequest();
    deleteRelationshipRequest.setBaseCanvasModel(relationship);
    HttpRequest req = _HTTPRequestController.executeBaseCanvasModelRequest(deleteRelationshipRequest);
    
    req.onReadyStateChange.listen((Event e) {
      if(req.readyState == HttpRequest.DONE){
        if(req.status == 200 || req.status == 0 || req.status == 204) {
            RelationshipView rsv = _getRelationshipView(relationship);
            relationshipViews.remove(rsv);
            borderInteractionController.deleteCanvasModel(relationship);
            
            if(relationship.identifying == true || relationship.dataType == Relationship.NON_IDENTIFYING_RELATIONSHIP)
              deleteSubsequentForeignKeys(relationship);  
            
          }
       else
          window.alert("Erro! Envie um e-mail para ecopat@gmail.com");
      }
    });
  }
  
  _createTernary(Relationship relationship, RelationshipView relationshipView){
    if(_isRelationshipTernary(relationship) &&
        !relationship.ternaryConnection){
      if(relationship.identifying)
        tableController.createForeignKeyForTernary(relationship.parentTable, relationship.ternaryTable);
      relationship.ternaryConnection = true;
      relationshipView.bcnTernaryTableAndRelationship = borderInteractionController.createBorderConnection(relationship.ternaryTable, relationship);
    }
  }
  
  void deleteSubsequentForeignKeys(Relationship relationship){
    //First, we delete all foreign keys from the parent table.
    tableController.deleteAllForeignKeys(relationship.parentTable);
    
    //tableController.updateTableRequest(clonedChild, relationship.childTable);
    //But then, because I'm lazy, we update the table to force the creation of foreign keys again.
    //Why is that? Because a table may have more than one relationship
    if(relationship.parentTable != null){
      tableController.updateTable(relationship.parentTable, relationship.parentTable.name);
    }
    
  }
  
  void showModal(Relationship relationship, String modalType){
    String baseModalType;
    if(relationshipModal != null)
      relationshipModal.cancelSubmitListener();
    
    if(modalType == BaseModal.CREATE)
      baseModalType = BaseModal.CREATE;
    else
      baseModalType = BaseModal.EDIT;
    
    relationshipModal = relationshipModalFactory.newTableModal(relationship, baseModalType, this);
  }
  
  List<Table> getTablesWeakedByRelationshipFrom(Table table){
    List<Table> weakEntities = new List<Table>();
    for(RelationshipView rsv in relationshipViews){
      if(rsv.relationship.parentTable.id == table.id && rsv.relationship.identifying == true){
        weakEntities.add(rsv.relationship.childTable);
        if(rsv.relationship.ternaryTable != null){
          weakEntities.add(rsv.relationship.ternaryTable);
        }
      }
    }
    return weakEntities;
  }
  
  List<Table> getTablesNotWeakedByRelationshipFrom(Table table){
    List<Table> tables = new List<Table>();
    for(RelationshipView rsv in relationshipViews){
      if(rsv.relationship.parentTable.id == table.id && rsv.relationship.dataType == Relationship.NON_IDENTIFYING_RELATIONSHIP){
        tables.add(rsv.relationship.childTable);
        if(rsv.relationship.ternaryTable != null){
          tables.add(rsv.relationship.ternaryTable);
        }
      }
    }
    return tables;
  }
  
  void updateRelationshipsWithTable(Table table){
    for(RelationshipView rsv in relationshipViews){
      if(rsv.relationship.parentTable.id == table.id)
        rsv.relationship.parentTable = table;
      if(rsv.relationship.childTable == table.id)
        rsv.relationship.childTable = table;
      if(rsv.relationship.ternaryTable != null)
        if(rsv.relationship.ternaryTable.id == table.id)  
          rsv.relationship.ternaryTable = table;  
    }
  }
  
  void deleteRelationshipsFromTable(Table table){
    // Contains the relationships to be removed, needed to not confused the following for loop...
    List<RelationshipView> relationsToBeRemoved = []; 
  
    // Append the relationships which contains the table
    for(RelationshipView rsv in relationshipViews){
      if(rsv.relationship.parentTable == table || rsv.relationship.childTable == table){
        relationsToBeRemoved.add(rsv);
      }
    }
    
    for(RelationshipView rsv in relationsToBeRemoved){
      deleteRelationship(rsv.relationship);
      //borderInteraction... etc?
      //borderInteractionController.deleteConnection(modelA,modelB) ?????
      relationshipViews.remove(rsv);
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
    
    if(baseCanvasModel.runtimeType == Relationship){
      Relationship draggedRelationship = baseCanvasModel;
      num nameWidth = ctx.measureText(draggedRelationship.name).width;
      draggedRelationship.updateNameDiamond(nameWidth);
    }
    //_createRelationshipNameDiamond( baseCanvasModel );

    /*When I drag a table, the connections must be recalculated*/
    borderInteractionController.calculateConnectionsLocation();
  }
  
  Relationship getClickedRelationship(Point canvasMousePosition){
    if(diagramController.isConceptual())
      return getConceptualClickedRelationship(canvasMousePosition);
    if(diagramController.isLogical())
      return getLogicalClickedRelationship(canvasMousePosition);
  }
  
  
  /**Get the closets relationship in a range from the click (clientPoint) of the user **/
  Relationship getLogicalClickedRelationship(Point clientPoint){
    borderInteractionController.calculateConnectionsLocation();
    int closestDistance = BorderInteractionController.dummyMaxDistance;
    Relationship closestRelationship;
    num distanceFromClientPoint;
    
    for(RelationshipView rsv in relationshipViews){
      for(Line relationshipLine in rsv.relationshipLines){
        distanceFromClientPoint = pDistance(clientPoint.x, clientPoint.y, relationshipLine.start.x, relationshipLine.start.y, relationshipLine.end.x, relationshipLine.end.y);
        
        if(distanceFromClientPoint < 20){
          if(closestDistance > distanceFromClientPoint){
              closestDistance = distanceFromClientPoint;
              closestRelationship = rsv.relationship;
          }
        }
      }
    }
    
    return closestRelationship;
  }
    
  Relationship getConceptualClickedRelationship(Point canvasMousePosition){
    for(RelationshipView relationshipView in relationshipViews){
      if(canvasMousePosition.x > relationshipView.relationship.x                                         &&
         canvasMousePosition.x < relationshipView.relationship.x + relationshipView.relationship.width   &&
         canvasMousePosition.y > relationshipView.relationship.y                                         &&
         canvasMousePosition.y < relationshipView.relationship.y + relationshipView.relationship.height){
        return relationshipView.relationship;
      }
    }
    return null;
 }
 
 RelationshipField getClickedRelationshipField(Point canvasMousePosition){
   for(RelationshipView relationshipView in relationshipViews){
     for(RelationshipField relationshipField in relationshipView.relationship.relationshipFields){
       if(canvasMousePosition.x > relationshipField.x                       &&
           canvasMousePosition.x < relationshipField.x + relationshipField.width   &&
           canvasMousePosition.y > relationshipField.y                      &&
           canvasMousePosition.y < relationshipField.y + relationshipField.height){
         return relationshipField;
       } 
       for(RelationshipField subRelationshipField in relationshipField.baseSubFields){
         if(canvasMousePosition.x > subRelationshipField.x                       &&
             canvasMousePosition.x < subRelationshipField.x + subRelationshipField.width   &&
             canvasMousePosition.y > subRelationshipField.y                      &&
             canvasMousePosition.y < subRelationshipField.y + subRelationshipField.height){
           return subRelationshipField;
         } 
       }
     }
   }
   return null;
 }
 
 void resetModelLocation(BaseCanvasModel baseCanvasModel, Map baseFieldsPosition, Point initialCanvasModelPosition){
   baseCanvasModel.x = initialCanvasModelPosition.x;
   baseCanvasModel.y = initialCanvasModelPosition.y;
   
   baseCanvasModel.updateLocation(initialCanvasModelPosition);
   
   if(baseCanvasModel.runtimeType == Relationship){
     print("reset relationship");
     Relationship resetRelationship = baseCanvasModel;
     num nameWidth = ctx.measureText(resetRelationship.name).width;
     resetRelationship.updateNameDiamond(nameWidth);
   }   
   
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
 
 
 void convertIntoTernary(Table ternaryTable, Relationship ternaryRelationship){
   if(_isTableInRelationship(ternaryTable, ternaryRelationship))
     return;
   if(_isRelationshipTernary(ternaryRelationship))
     return;
      
   editRelationship(ternaryRelationship, true , ternaryTable);
 }
 
 void setTernaryValues(Relationship relationship, Table ternaryTable){
   relationship.ternaryTable = ternaryTable;
   relationship.ternaryCardinality = '(0,1)';
 }
 
 bool _isTableInRelationship(Table table, Relationship relationship){
   if(relationship.parentTable == table || 
      relationship.childTable == table  ||
      relationship.ternaryTable == table)
     return true;
   else
     return false;
 }
 
 bool _isRelationshipTernary(Relationship relationship){
   if(relationship.ternaryTable == null)
     return false;
   else
     return true;
 }
  
 void toggle(BaseCanvasModel baseCanvasModel){
   RelationshipView relationshipView = _getRelationshipView(baseCanvasModel);
   if(relationshipView != null){
     relationshipView.toggled = true;
     return; 
   }
   
   for(RelationshipView rv in relationshipViews){
     for(RelationshipField rf in rv.relationship.relationshipFields){
       if(rf == baseCanvasModel){
         rv.toggledRelationshipField = baseCanvasModel;
         return;
       }
       for(RelationshipField subRf in rf.baseSubFields){
         rv.toggledRelationshipField = baseCanvasModel;
         return;
       }
     }
   }
 }
 
 RelationshipView _getRelationshipView(Relationship relationship) {
   for(RelationshipView relationshipView in relationshipViews) {
     if(relationshipView.relationship == relationship)
       return relationshipView;
   }
 }

  
  void untoggleRelationships(){
    for(RelationshipView rsv in relationshipViews){
        rsv.toggle(false);
        rsv.toggledRelationshipField = null;
    }
  }

  void drawAllRelations()
  {
    if(this.relationshipDefinition != null)
      relationshipDefinition.draw();

    for(RelationshipView rsv in relationshipViews){
      rsv.drawRelationshipName(preferencesController.getPreferences().relationshipNameInLogicalDiagram);
      rsv.draw();
    }
  }
  
  void highlightRelationship(Relationship relationship, [bool status]){
    RelationshipView rsv = _getRelationshipView(relationship);
     if(status == true)
       rsv.highlighted = true;
     else
       rsv.highlighted = false;
  }
  
  /*RelationshipDefinition stands for a attempt of creating a relation*/
  void createRelationshipDefinition(Point startRel)
  {
    this.relationshipDefinition = new RelationshipDefinitionView(startRel,startRel, ctx);
  }
  void deleteRelationshipDefinition()
  {
    this.relationshipDefinition = null;
  }
  void setRelationshipDefinitionEndPoint(Point endRel)
  {
    this.relationshipDefinition.endRel = endRel;
  }
}
