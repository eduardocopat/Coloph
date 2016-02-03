library coloph;

import 'dart:core';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as Math;
import 'package:js/js.dart' as js;
//import 'dart:js' as js;


part 'src/Bases/BaseCanvasModel.dart';
part 'src/Bases/BaseCanvasModelController.dart';
part 'src/Bases/BaseController.dart';
part 'src/Bases/BaseField.dart';
part 'src/Bases/BaseModal.dart';
part 'src/Bases/BaseModel.dart';
part 'src/Bases/BaseView.dart';
part 'src/Border/Border.dart';
part 'src/Border/BorderConnection.dart';
part 'src/Border/BorderInteractionController.dart';
part 'src/Border/BorderPoint.dart';
part 'src/Canvas/BaseFieldGluer.dart';
part 'src/Canvas/CanvasActionsController.dart';
part 'src/Canvas/CanvasScroller.dart';
part 'src/Canvas/CanvasEllipseDrawer.dart';
part 'src/Canvas/SelectionRectangle.dart';
part 'src/Canvas/Strategies/CanvasInteractionStrategy.dart';
part 'src/Canvas/Strategies/RelationshipTernaryDefinitionStrategy.dart';
part 'src/Canvas/Strategies/DefaultStrategy.dart';
part 'src/Canvas/Strategies/RelationshipCanvasMenuStrategy.dart';
part 'src/Canvas/Strategies/RelationshipDefinitionStrategy.dart';
part 'src/Canvas/Strategies/RelationshipSelectStrategy.dart';
part 'src/Canvas/Strategies/TableCanvasMenuStrategy.dart';
part 'src/Canvas/Strategies/TableCreationStrategy.dart';
part 'src/Canvas/Strategies/SpecializationStrategy.dart';
part 'src/Canvas/Strategies/SpecializationNewConnectionStrategy.dart';
part 'src/Canvas/Strategies/SpecializationCanvasMenuStrategy.dart';
part 'src/Canvas/Strategies/CanvasModelSelectAndDragStrategy.dart';
part 'src/Command/Command.dart';
part 'src/Command/CommandController.dart';
part 'src/Command/CommandUpdate.dart';
part 'src/Connector/Connector.dart';
part 'src/Connector/ConnectorMany.dart';
part 'src/Connector/ConnectorOne.dart';
part 'src/Connector/ConnectorOneOrMany.dart';
part 'src/Connector/ConnectorZeroOrMany.dart';
part 'src/Connector/ConnectorZeroOrOne.dart';
part 'src/Diagram/Diagram.dart';
part 'src/Diagram/DiagramController.dart';
part 'src/Factories/ControllerFactory.dart';
part 'src/Factories/ModalFactory.dart';
part 'src/Factories/ViewFactory.dart';
part 'src/HTTPRequest/HTTPRequestController.dart';
part 'src/HTTPRequest/HTTPMethod.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Table/CreateTableRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Table/ValidateTableRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Table/UpdateTableRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Table/DeleteTableRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Table/DeleteTableFieldRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Relationship/CreateRelationshipRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Relationship/DeleteRelationshipRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Relationship/UpdateRelationshipRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Relationship/ValidateRelationshipRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Specialization/CreateSpecializationRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Specialization/DeleteSpecializationRequest.dart';
part 'src/HTTPRequest/BaseCanvasModelHTTPRequests/Specialization/UpdateSpecializationRequest.dart';
part 'src/MainController.dart';
part 'src/Line.dart';
part 'src/ModalBaseFieldBuilder.dart';
part 'src/Preferences/Preferences.dart';
part 'src/Preferences/PreferencesController.dart';
part 'src/Preferences/PreferencesModal.dart';
part 'src/Relationship/Modal/ConceptualRelationshipModal.dart';
part 'src/Relationship/Modal/LogicalRelationshipModal.dart';
part 'src/Relationship/Modal/RelationshipModal.dart';
part 'src/Relationship/Modal/RelationshipModalFactory.dart';
part 'src/Relationship/Modal/ConceptualModalRelationshipFieldBuilder.dart';
part 'src/Relationship/Relationship.dart';
part 'src/Relationship/RelationshipController.dart';
part 'src/Relationship/RelationshipField.dart';
part 'src/Relationship/RelationshipLines/RelationshipHorizontalCurvedLine.dart';
part 'src/Relationship/RelationshipLines/RelationshipLine.dart';
part 'src/Relationship/RelationshipLines/RelationshipRightAngleCurvedLine.dart';
part 'src/Relationship/View/ConceptualRelationshipView.dart';
part 'src/Relationship/View/LogicalRelationshipView.dart';
part 'src/Relationship/View/RelationshipDefinitionView.dart';
part 'src/Relationship/View/RelationshipView.dart';
part 'src/Relationship/View/RelationshipViewFactory.dart';
part 'src/Specialization/SpecializationController.dart';
part 'src/Specialization/Specialization.dart';
part 'src/Specialization/View/SpecializationViewFactory.dart';
part 'src/Specialization/View/SpecializationView.dart';
part 'src/Specialization/View/ConceptualSpecializationView.dart';
part 'src/Specialization/View/LogicalSpecializationView.dart';
part 'src/Table/ForeignKey.dart';
part 'src/Table/Modal/ConceptualModalTableFieldBuilder.dart';
part 'src/Table/Modal/ConceptualTableModal.dart';
part 'src/Table/Modal/LogicalModalTableFieldBuilder.dart';
part 'src/Table/Modal/LogicalTableModal.dart';
part 'src/Table/Modal/TableModal.dart';
part 'src/Table/Modal/TableModalFactory.dart';
part 'src/Table/Table.dart';
part 'src/Table/TableController.dart';
part 'src/Table/TableField.dart';
part 'src/Table/View/ConceptualTableView.dart';
part 'src/Table/View/LogicalTableView.dart';
part 'src/Table/View/TableView.dart';
part 'src/Table/View/TableViewFactory.dart';

/*Math stuff here*/
num distance2D(Point firstPoint, Point secondPoint) =>
    ( Math.sqrt
       (
         ( Math.pow((secondPoint.x - firstPoint.x), 2) )
         +
         ( Math.pow((secondPoint.y - firstPoint.y), 2) )
       )
    );

num getDegreesFromRightRectangle(num oppositCathetus, num hypotenuse)
{

  num otherSide = (hypotenuse * hypotenuse) - (oppositCathetus* oppositCathetus);
  otherSide = Math.sqrt(otherSide );

  num tan = oppositCathetus / otherSide ;
  num atan = Math.atan(tan); // (result in radians)
  num angleDegree = atan * 180 / Math.PI; // converted to degrees

  return angleDegree;
}


//http://stackoverflow.com/questions/910882/how-can-i-tell-if-a-point-is-nearby-a-certain-line
num calculateRightAngleDistance(Point lineStart, Point lineEnd, Point arbitraryPoint )
{
  num numerator = ((lineEnd.x - lineStart.x) * (lineStart.y - arbitraryPoint.y)) -
                  ((lineStart.x - arbitraryPoint.x) * (lineEnd.y - lineStart.y));
                  
  num denominator = distance2D(lineEnd, lineStart);  
  
  return (numerator.abs()/denominator);
  
}

/** Segment a line in n points, where n = numberOfSegments */
List<Point> segmentLine(Point startPoint, Point endPoint, int numberOfSegments){
  // First, we calculate the distance between each segmented point
  // For example, if our north border mesaures 200 (Start Point 50, end Point 250). And we want segment this
  // line for 3,  the average distance would be 50. */
  
  List<Point> segmentedPoints = new List<Point>();
  
  num distancex = (endPoint.x - startPoint.x ) / (numberOfSegments+1) ;
  distancex = distancex.abs();
  num distancey = (endPoint.y - startPoint.y ) / (numberOfSegments+1);
  distancey = distancey.abs();
  // Now to create the segments 
  for(int i = 0; i < numberOfSegments;i++){
    // The relative distance is the distance from the start X + distanceX * the iterator
    // It would be easy with a drawing, but you can understand the code...
    // Anyway, here it is a image: http://i.imgur.com/Y4UkO.png */
    num relativeDistanceX = distancex * (i+1);
    num relativeDistanceY = distancey * (i+1);
    Point p = new Point(startPoint.x + relativeDistanceX, startPoint.y + relativeDistanceY);
    
    segmentedPoints.add(p);
  }
  
  return segmentedPoints;
}

Point calculateMiddlePoint(Point lineStartPoint, Point lineEndPoint){
  num x = (lineStartPoint.x + lineEndPoint.x) / 2;
  num y = (lineStartPoint.y + lineEndPoint.y) / 2;
  return new Point(x,y);
  
  /*
  List<Point> segmentedLine = segmentLine(lineStartPoint,lineEndPoint,2);
  Point middlePoint = segmentedLine[0];
  return middlePoint;
  */
}

Point pointFromEndOfLine(Point start, Point end, num distance){
  double x = end.x-start.x;   
  double y = end.y-start.y;
  double z = Math.sqrt(x * x + y * y);  //Pathagrean Theorum for Hypotenuse
  double ratio = distance / z;
  double deltaX = x * ratio;
  double deltaY = y * ratio;

  return new Point(end.x-deltaX, end.y-deltaY);
}

num angleBetweenTwoPoints(Point start, Point end){
  //http://stackoverflow.com/questions/7586063/how-to-calculate-the-angle-between-two-points-relative-to-the-horizontal-axis
  num deltaX = end.x - start.x;
  num deltaY = end.y - start.y;
  
  num angleInDegrees = Math.atan2(deltaX, deltaY) * 180 / Math.PI;
  return angleInDegrees;
}

num pDistance(x, y, x1, y1, x2, y2) {

  var A = x - x1;
  var B = y - y1;
  var C = x2 - x1;
  var D = y2 - y1;

  var dot = A * C + B * D;
  var len_sq = C * C + D * D;
  var param = dot / len_sq;

  var xx, yy;

  if (param < 0 || (x1 == x2 && y1 == y2)) {
    xx = x1;
    yy = y1;
  }
  else if (param > 1) {
    xx = x2;
    yy = y2;
  }
  else {
    xx = x1 + param * C;
    yy = y1 + param * D;
  }

  var dx = x - xx;
  var dy = y - yy;
  return Math.sqrt(dx * dx + dy * dy);
}



const String FILLING_TABLE_COLOR = "#BCE8F1";
const String FILLING_TABLE_COLOR_HEAVY = "#80CFFF";
const String FILLING_RELATIONSHIP_COLOR = "#FFDF73";
const String FILLING_RELATIONSHIP_COLOR_HEAVY = "#FFD340";
const String FILLING_SPECIALIZATION_COLOR= "#886ED7";
const String FILLING_SPECIALIZATION_COLOR_HEAVY= "#6C48D7";
const String SHADOW_COLOR = "#696969";
const int GRID_SQUARE_SIZE = 15;
const String TOGGLE_COLOR = "#00FF00";
const int FONT_SIZE = 10;
const String FONT_TYPE_AND_SIZE = "${FONT_SIZE}pt Helvetica";
const num GOLDEN_RATIO = 1.618033988;
const int TOGGLE_SQUARE_SIZE = 5;

