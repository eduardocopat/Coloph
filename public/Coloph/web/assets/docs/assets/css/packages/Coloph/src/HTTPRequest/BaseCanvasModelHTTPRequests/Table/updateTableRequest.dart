part of coloph;

class UpdateTableRequest extends BaseCanvasModelHTTPRequest{
  Table table;
  Table oldTable; 
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    oldTable = baseCanvasModel;
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    table = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.PUT, "${resourceURL}/tables/${oldTable.id}.json");
  }
  
  getModelJson(){
    return table.toJson(oldTable);
  }
}