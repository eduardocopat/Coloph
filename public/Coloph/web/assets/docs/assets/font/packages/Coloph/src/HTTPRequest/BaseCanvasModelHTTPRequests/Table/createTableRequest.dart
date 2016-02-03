part of coloph;

class CreateTableRequest extends BaseCanvasModelHTTPRequest{
  Table table;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    table = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.POST, "${resourceURL}/tables.json");
  }
  
  getModelJson(){
    return table.toJson();
  }
}