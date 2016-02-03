part of coloph;

class GetDiagramRequest extends BaseCanvasModelHTTPRequest{
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.GET, resourceURL);
  }
  
  getModelJson(){
    
  }
}