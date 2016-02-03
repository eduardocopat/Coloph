part of coloph;

class UpdateRelationshipRequest extends BaseCanvasModelHTTPRequest{
  Relationship relationship;
  Relationship oldRelationship;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    oldRelationship = baseCanvasModel;
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    relationship = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.PUT, "${resourceURL}/relationships/${relationship.id}.json");
  }
  
  getModelJson(){
    return relationship.toJson(oldRelationship);
  }
}