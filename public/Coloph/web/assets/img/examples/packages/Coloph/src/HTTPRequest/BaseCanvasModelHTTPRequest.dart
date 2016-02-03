part of coloph;

abstract class BaseCanvasModelHTTPRequest{
  
  void setOldBaseCanvasModel(BaseCanvasModel baseCanvasModel);
  void setBaseCanvasModel(BaseCanvasModel baseCanvasModel);
  void openWithMethodAndURL(String resourceURL, HttpRequest request);
  String getModelJson();
}