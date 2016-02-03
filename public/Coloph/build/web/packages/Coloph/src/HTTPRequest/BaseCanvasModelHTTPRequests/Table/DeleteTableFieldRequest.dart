part of coloph;

class DeleteTableFieldRequest extends BaseCanvasModelHTTPRequest{
  Table table;
  TableField tableField; 
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    table = baseCanvasModel;
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    tableField = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.PUT, "/delete_table_field.json");
  }
  
  getModelJson(){
    Map map =  new Map();
    map["table_id"] = table.id;
    map["table_field_id"] = tableField.id;
    return JSON.encode(map);
  }
}