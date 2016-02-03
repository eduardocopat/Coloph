part of coloph;

class ValidateRelationshipRequest extends BaseCanvasModelHTTPRequest{
  Relationship relationship;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    relationship = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.POST, "${resourceURL}/relationships.json");
  }
  
  getModelJson(){
    return relationship.toJson();
  }
}