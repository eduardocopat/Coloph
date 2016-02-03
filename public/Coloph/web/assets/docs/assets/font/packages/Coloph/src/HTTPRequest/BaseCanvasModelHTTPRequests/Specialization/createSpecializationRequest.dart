part of coloph;

class CreateSpecializationRequest extends BaseCanvasModelHTTPRequest{
  Specialization specialization;
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    
  }
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel){
    specialization = baseCanvasModel;
  }
  
  void openWithMethodAndURL(String resourceURL, HttpRequest request){
    request.open(HTTPMethod.POST, "${resourceURL}/specializations.json");
  }
  
  getModelJson(){
    return specialization.toJson();
  }
}