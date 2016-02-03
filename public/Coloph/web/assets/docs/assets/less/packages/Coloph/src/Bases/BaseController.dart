part of coloph;

abstract class BaseController {

  ControllerFactory controllerFactory;

  BaseController()
  {

  }

  
  void setControllerFactory(ControllerFactory controllerFactory)
  {
    this.controllerFactory = controllerFactory;
  }

  void setRequiredControllers();



}
