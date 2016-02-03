part of coloph;

class ValidateTableRequest extends BaseCanvasModelHTTPRequest{
  Table table;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    table = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.POST, "/table.json/validate");
  }
  
  getModelJson(){
    return table.toJson();
  }
}