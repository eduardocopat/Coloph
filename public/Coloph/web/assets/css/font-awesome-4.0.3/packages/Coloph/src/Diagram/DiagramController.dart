part of coloph;

class DiagramController extends BaseController{
  Diagram diagram;
  static String CONCEPTUAL_DIAGRAM = "Conceptual_entity_relationship_diagram";
  static String LOGICAL_DIAGRAM = "Logical_entity_relationship_diagram";
  bool SYNCHRONOUS_DIAGRAM_READ_HAPPENED = false;
  
  TableController tableController;
  RelationshipController relationshipController;
  SpecializationController specializationController;
  
  HTTPRequestController _HTTPRequestController; 
  DiagramController(diagramId){
    diagram = new Diagram(diagramId);
    _handleLogicalPhysicalConversion();
  }
  
  void setRequiredControllers(){
    _HTTPRequestController = controllerFactory.getHTTPRequestController();
    tableController = controllerFactory.getTableController();
    relationshipController = controllerFactory.getRelationshipController();
    specializationController = controllerFactory.getSpecializationController();
  }
  
  _handleLogicalPhysicalConversion(){
    querySelector("#logicalPhysicalConversion").onClick.listen((Event evt) {
      if(diagram.logical){
        diagram.logical  = false;
        diagram.physical = true;
        querySelector("#logicalPhysicalConversionText").text = "Converter para lógico";
      } else {
        diagram.logical  = true;
        diagram.physical = false;
        querySelector("#logicalPhysicalConversionText").text = "Converter para físico";
      }
    });
  }
  
  num getDiagramId(){
    return diagram.id;
  }
  
  readDiagramData(){
    HttpRequest req = _HTTPRequestController.executeGetDiagramRequest();
    if(req.status == 200 || req.status == 0 || req.status == 204) {
      Map mappedDiagram = JSON.decode(req.responseText);
      if(mappedDiagram["diagram_type"] == CONCEPTUAL_DIAGRAM)
        diagram.conceptual = true;
      if(mappedDiagram["diagram_type"] == LOGICAL_DIAGRAM)
        diagram.logical = true;
    }     
  }
  
  loadBaseCanvasModels(){
    loadTables();
    loadRelationships();
    loadSpecializations();
  }
  
  loadTables(){
    HttpRequest request = new HttpRequest();
    request.open(HTTPMethod.GET, "/diagrams/${getDiagramId()}/tables.json", async : false);
    request.setRequestHeader("Content-Type", "application/json");
    request.send(); 
    
    if(request.status == 200 || request.status == 0 || request.status == 204) {
      Map tables = JSON.decode(request.responseText);
      tableController.createTablesFromJsonMap(tables);
      
    }
  }
  
  loadRelationships(){
    HttpRequest request = new HttpRequest();
    request = new HttpRequest();
    request.open(HTTPMethod.GET, "/diagrams/${getDiagramId()}/relationships.json", async : false);
    request.setRequestHeader("Content-Type", "application/json");
    request.send(); 
    
    if(request.status == 200 || request.status == 0 || request.status == 204) {
      Map relationships = JSON.decode(request.responseText);
      relationshipController.createRelationshipsFromJsonMap(relationships);
    }
  }
  
  loadSpecializations(){
    HttpRequest request = new HttpRequest();
    request = new HttpRequest();
    request.open(HTTPMethod.GET, "/diagrams/${getDiagramId()}/specializations.json", async : false);
    request.setRequestHeader("Content-Type", "application/json");
    request.send(); 
    
    if(request.status == 200 || request.status == 0 || request.status == 204) {
      Map specializations = JSON.decode(request.responseText);
      specializationController.createSpecializationFromJsonMap(specializations);
    }
  }
  
  bool isConceptual(){
    if(diagram.conceptual)
      return true;
    else
      return false;
  }
  
  bool isLogical(){
    if(diagram.logical)
      return true;
    else
      return false;
  }
  
  bool isPhysical(){
    if(diagram.physical)
      return true;
    else
      return false;
  }
  
  setNavBar(){
    UListElement canvasActionsNav = querySelector("#canvas-actions-nav");
    canvasActionsNav.style.display = "";
    
    if(isLogical()){
      querySelector("#openTableModal").appendText('Relação');
      querySelector("#relationCreationTernary").parent.remove();
      
    }
    if(isConceptual()){
      querySelector("#openTableModal").appendText("Entidade");
      querySelector("#relationCreationManyToMany").parent.remove();
      querySelector("#logicalPhysicalConversion").parent.remove();
    }
  }
    
  
}