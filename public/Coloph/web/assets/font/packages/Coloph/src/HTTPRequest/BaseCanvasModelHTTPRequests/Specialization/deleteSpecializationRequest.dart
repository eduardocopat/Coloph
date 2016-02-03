part of coloph;

class DeleteSpecializationRequest extends BaseCanvasModelHTTPRequest{
  Specialization specialization;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    specialization = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.DELETE, "${resourceURL}/specializations/${specialization.id}.json");
  }
  
  getModelJson(){
    return specialization.toJson();
  }
}