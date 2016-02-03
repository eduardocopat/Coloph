import 'dart:html' ;

//import 'package:js/js.dart' as js;
import '../lib/colophLib.dart';

void main(){
  
  //js.scoped(() {
    //js.context.jQuery.noConflict();
  //});
  
  //js.scoped(() {
    //js.context.jQuery('#canvas').contextmenu();
  //});
  
  
   CanvasElement canvas = querySelector('#canvas');
  

  MainController mainController = new MainController(canvas);
}





