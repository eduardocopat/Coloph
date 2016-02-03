part of coloph;

class PreferencesController extends BaseController{
  CanvasElement canvas;  
  Preferences preferences;
  
  PreferencesController(canvas){
    this.canvas = canvas;
    preferences = new Preferences();
    _createCanvasToImageHandler();
  }
  
  setRequiredControllers(){} //None in this case
  
  showModal(){
    PreferencesModal preferencesModal = new PreferencesModal(this, preferences);
  }
  
  //Set the preferences that the user has chosen
  executePreferencesChosen(){
    enableGrid(preferences.grid);
  }
  
  void enableGrid(bool option){
    if(option)
      canvas.style.backgroundImage = "url(http://i.imgur.com/StCBO5W.png)"; //image in rails_root/public/images
      //canvas.style.backgroundImage = "assets/gridPattern.png"; //image in rails_root/public/images
    else
      canvas.style.backgroundImage = "";
    
  }
  
  void _createCanvasToImageHandler(){
    ButtonElement canvasToImagebutton = querySelector("#export_canvas_to_img");
    canvasToImagebutton.onClick.listen((Event evt) {
      _convertCanvasToImage();
    });
  }
  
  void _convertCanvasToImage(){
    ImageElement canvasImage = new ImageElement();
    canvasImage.src = canvas.toDataUrl();
    window.open(canvasImage.src, "_blank" );
  }
  
  Preferences getPreferences(){
    return preferences;
  }
  
  
  
  
}
