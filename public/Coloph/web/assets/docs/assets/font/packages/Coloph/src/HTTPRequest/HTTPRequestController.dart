part of coloph;

class HTTPRequestController extends BaseController{
  DiagramController diagramController;
  
  HTTPRequestController(){
    
  }
  
  void setRequiredControllers(){
    diagramController = this.controllerFactory.getDiagramController();
  }
  
  HttpRequest executeBaseCanvasModelRequest(BaseCanvasModelHTTPRequest baseModelRequest){
    HttpRequest request = new HttpRequest();
    String diagramId =  diagramController.getDiagramId().toString();
    baseModelRequest.openWithMethodAndURL("/diagrams/${diagramId}", request);

    request.setRequestHeader("Content-Type", "application/json, 'X-CSRF-Token', ");
    String diagramJson = baseModelRequest.getModelJson();
    request.send(diagramJson); 
    
    return request;
  }
  
  HttpRequest executeGetDiagramRequest(){
    HttpRequest request = new HttpRequest();
    String diagramId =  diagramController.getDiagramId().toString();
    request.open(HTTPMethod.GET, "/diagrams/${diagramId}.json", async : false);
    request.setRequestHeader("Content-Type", "application/json");
    request.send(); 
    return request;
  }
}