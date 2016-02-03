part of coloph;

/** An abstract used by canvas to set how the user is interacting or will interact with the canvas
 * Uses Strategy pattern.
 */
abstract class CanvasInteractionStrategy{
  
  static const LEFT_CLICK = 1; //Mouse events
  static const RIGHT_CLICK = 3; //Mouse events
  
  executeMouseDown(Point canvasMousePosition, int clickOrigin){}
  executeMouseMove(Point canvasMousePosition){}
  executeMouseUp(Point canvasMousePosition){}
  executeCanvasScroll(MouseEvent evt){}
  executeDoubleClick(Point canvasMousePosition){}
  executeKeyDown(KeyboardEvent evt){}
}