part of coloph;

class UpdateSpecializationRequest extends BaseCanvasModelHTTPRequest{
  Specialization specialization;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    specialization = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.PUT, "${resourceURL}/specializations/${specialization.id}.json");
  }
  
  getModelJson(){
    return specialization.toJson();
  }
}