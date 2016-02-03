part of coloph;

class DeleteTableRequest extends BaseCanvasModelHTTPRequest{
  Table table;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    table = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.DELETE, "${resourceURL}/tables/${table.id}.json");
  }
  
  getModelJson(){
    return table.toJson();
  }
}