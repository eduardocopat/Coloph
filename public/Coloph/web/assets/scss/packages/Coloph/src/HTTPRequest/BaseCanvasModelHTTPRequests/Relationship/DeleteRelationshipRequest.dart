part of coloph;

class DeleteRelationshipRequest extends BaseCanvasModelHTTPRequest{
  Relationship relationship;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    relationship = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.DELETE, "${resourceURL}/relationships/${relationship.id}.json");
  }
  
  getModelJson(){
    return relationship.toJson();
  }
}