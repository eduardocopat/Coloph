part of coloph;

//May the force be with you
class BorderInteractionController extends BaseController{
  List<BaseCanvasModel> canvasModels; 
  List<BorderConnection> borderConnections;
  static const dummyMaxDistance = 42*42*42*42; // Dummy variable to represent a big distance 

  BorderInteractionController(){
    canvasModels = [];
    borderConnections = [];
  }

  void setRequiredControllers(){
  }
  
  void clearConnections(){
    borderConnections.clear();
  }

  void addCanvasModel(BaseCanvasModel canvasModel){
    canvasModels.add(canvasModel);
  }
  
  void updateCanvasModel(BaseCanvasModel oldBaseCanvasModel, BaseCanvasModel baseCanvasModel){
    // Update all border connections which contains the canvas model to the updated one
    for(BorderConnection borderConnection in borderConnections){
      if(borderConnection.canvasModelA == oldBaseCanvasModel)
        borderConnection.canvasModelA = baseCanvasModel;
      if(borderConnection.canvasModelB == oldBaseCanvasModel)
        borderConnection.canvasModelB = baseCanvasModel;
    }
    
    canvasModels.remove(oldBaseCanvasModel);
    canvasModels.add(baseCanvasModel);
  }

  //Removes canvas model and its connections
  void deleteCanvasModel(BaseCanvasModel canvasModel){
    List<BorderConnection> borderConnectionsToBeDeleted = [];
    
    //Mark connections which have the canvas model for deletion
    for(BorderConnection borderConnection in borderConnections){
      if(borderConnection.canvasModelA == canvasModel || borderConnection.canvasModelB == canvasModel){
        borderConnectionsToBeDeleted.add(borderConnection);
      }
    }
    //Delete them
    for(BorderConnection borderConnection in borderConnectionsToBeDeleted){
      borderConnections.remove(borderConnection);
    }
    
    canvasModels.remove(canvasModel);
  }
  
  BorderConnection deleteBorderConnection(BaseCanvasModel canvasModelA, BaseCanvasModel canvasModelB){
    BorderConnection bcnToBeDeleted;
    for(BorderConnection bcn in borderConnections){
      if((bcn.canvasModelA == canvasModelA && bcn.canvasModelB == canvasModelB) ||
         (bcn.canvasModelA == canvasModelB && bcn.canvasModelB == canvasModelA)){
        bcnToBeDeleted = bcn;
        break;
      }
    }
    
    if(bcnToBeDeleted != null)
      borderConnections.remove(bcnToBeDeleted);
    
    return bcnToBeDeleted;
  }
 
  BorderConnection createBorderConnection(BaseCanvasModel canvasModelA,BaseCanvasModel canvasModelB){
    BorderConnection bcm = new BorderConnection(canvasModelA, canvasModelB);
    borderConnections.add(bcm);
    return bcm;
  }

  void calculateConnectionsLocation(){
    // First of all, I'll analyze the closestBorders from the canvas models
    // and add it to the border utilization list.
    // Knowing this, I can now know how many connections will occupy a border in a table
    for(BorderConnection borderConnection in borderConnections){
      
      borderConnection.canvasModelA.updateCentralBorderPoints();
      borderConnection.canvasModelB.updateCentralBorderPoints();
      
      List<BorderPoint> listA = borderConnection.canvasModelA.getCentralBorderPoints();
      List<BorderPoint> listB = borderConnection.canvasModelB.getCentralBorderPoints();
      
      List<BorderPoint> closestBorders = _getClosestPointsOfList(listA, listB, borderConnection.enforcedOppositeBorderForModelA);
      
      borderConnection.canvasModelA.addBorderUtilization(closestBorders[0].borderCode);
      borderConnection.canvasModelB.addBorderUtilization(closestBorders[1].borderCode);

      borderConnection.setBorderCodes(closestBorders[0].borderCode, closestBorders[1].borderCode);

      // Also, I need to clean the old borderpoints 
      borderConnection.clearBorderPointsAndAngle();
    }

    // Here I'll generate the required segments for each table
    for(BaseCanvasModel canvasModel in canvasModels) {
      canvasModel.generateBorderSegments();
    }

    // Then, for each border connection, try to define the best point for it
    for(BorderConnection borderConnection in borderConnections){
      _defineBestPoint(borderConnection);
    }
  }

  void _defineBestPoint(BorderConnection borderConnection){
    // Get the possible parent and border points 
    List<BorderPoint> borderAPoints = borderConnection.canvasModelA.getConnectionPointsFromBorder(borderConnection.borderCodeA);
    List<BorderPoint> borderBPoints = borderConnection.canvasModelB.getConnectionPointsFromBorder(borderConnection.borderCodeB);

    // This tests if the relationship is a special relation,
    // an special relation is a relation between a east border and a north border, for example
    // or a west border and south border. This kind of relation has special treatment on the
    // code flow
    if(
        ((borderConnection.borderCodeA == BorderPoint.EAST || borderConnection.borderCodeA == BorderPoint.WEST) ||
         (borderConnection.borderCodeB == BorderPoint.EAST || borderConnection.borderCodeB == BorderPoint.WEST))
        &&
        ((borderConnection.borderCodeA == BorderPoint.NORTH || borderConnection.borderCodeA == BorderPoint.SOUTH) ||
         (borderConnection.borderCodeB == BorderPoint.NORTH || borderConnection.borderCodeB == BorderPoint.SOUTH))
        ){
      borderConnection.specialRelation = true;
    }
    else
    {
      borderConnection.specialRelation = false;
    }

    //Then, calculate the best point and angle for this relationship
    _calculateBestPointAndAngle(borderConnection, borderAPoints, borderBPoints);
  }

  /* This is a very important recursive method. It calculate the best modelA and modelB points for
   * a connection. Based on angles, borders and special relations */
  void _calculateBestPointAndAngle(BorderConnection borderConnection, List<BorderPoint> borderAPoints, List<BorderPoint> borderBPoints){
    num bestAngle = dummyMaxDistance;
    num worstAngle = -1;
    num smallerHypotenuse = dummyMaxDistance;
    BorderPoint bestAPoint = null;
    BorderPoint bestBPoint  = null;

    // For each parent point, and child Point, i'll decide what point it is based mainly on the angle generated
    // by these two points 
    for(BorderPoint parentBP in borderAPoints){
      for(BorderPoint childBP in borderBPoints){
        //Creates a point to act as anchor to a opposite cathethus
        Point relativePoint = new Point(parentBP.point.x, childBP.point.y);

        num hypotenuse      = distance2D(parentBP.point, childBP.point);
        num oppositCathetus = distance2D(childBP.point, relativePoint);
        num angle           = getDegreesFromRightRectangle(oppositCathetus, hypotenuse);

        //If the relation is not a special relation
        if(borderConnection.specialRelation == false) {
          // When it comes to East and West borders, I need to get the opposite angle of the
          // triangle rectangle
          if((borderConnection.borderCodeA == BorderPoint.EAST || borderConnection.borderCodeA == BorderPoint.WEST) ||
             (borderConnection.borderCodeB == BorderPoint.EAST || borderConnection.borderCodeB == BorderPoint.WEST)){
            angle = 90 - angle;
          }

          // Is the best Angle higher then my angle? Then this angle is better
          if(bestAngle > angle){
            bestAngle = angle;
            bestAPoint = parentBP;
            bestBPoint = childBP;
          }
        } else {
          // When it comes to a specialRelation, it gets a little tricky
          // I actually need to get the worst Angle, not the best Angle, as it would be in the "normal" way
          // I also need to check if the hypotenuse distance is better on this point
          if(worstAngle < angle){
            if(smallerHypotenuse > hypotenuse){
              smallerHypotenuse = hypotenuse;
              worstAngle = angle ;
              bestAPoint = parentBP;
              bestBPoint  = childBP;
            }
          }

          // But what I'll actualy store in the relationship, will be the best Angle
          if(bestAngle > angle )
            bestAngle = angle;
        }
      }
    }
    // Remember, this works kinda fine
    
    // Then, I define the best points and angle that I got, to this relationship key*/
    borderConnection.setRelationshipPointsAndAngle(bestAPoint, bestBPoint, bestAngle);

    //Now, is it really the best angle for this relationship? Check out the _isItTheBestAngle method
    // to understand better
    int bestAngleReturn = _isItTheBestAngle(borderConnection);

    // if it returns 0, bestAngle is the best angle!
    // If not, I need to remove a recently used modelA or modelB point, doing this, I'm canceling the 
    // participation of this certain point in the tentative to define a connection.
    // and trying a new best relationship. This is where the recursion call happens
    if(bestAngleReturn != 0){
      if(bestAngleReturn == 1){
        int canceledPointIndex = borderAPoints.indexOf(bestAPoint, 0);
        borderAPoints.removeAt(canceledPointIndex);
        _calculateBestPointAndAngle(borderConnection, borderAPoints, borderBPoints);
        return;
      }
      if(bestAngleReturn == 2){
        int canceledPointIndex = borderBPoints.indexOf(bestBPoint, 0);
        borderBPoints.removeAt(canceledPointIndex);
        _calculateBestPointAndAngle(borderConnection, borderAPoints, borderBPoints);
        return;
      }
    }

    // If it has arrived here, indeed this is the best parent point and child point for this relationship
    borderConnection.triggerPointsUpdated();
  }

  /**
   * Returns if it is the best angle for the border connection
   *  0 = Yes, it is the best angle for this connection.
   *  1 = I'm sorry son, there's already a connection using a point from the modelA and unfortunately it has the best angle.
   *  2 = Same thing as 1, but the modelB instead.
   */
  int _isItTheBestAngle(BorderConnection candidateBorderConnection){
    int status = 0; // Read the method comment, this status will be the return 
  
    for(BorderConnection rivalBorderConnection in borderConnections){
      if(rivalBorderConnection != candidateBorderConnection){
          // Are there border points and an angle already created for this other border connection? 
          if(rivalBorderConnection.areBorderPointsDefined()){
            
            // Is there any borderPoint from both A and B model being used in other border connection? 
            // Test candidate's borderPointA
            if(rivalBorderConnection.borderPointA == candidateBorderConnection.borderPointA) 
             status = 1;
            
            if(rivalBorderConnection.borderPointB == candidateBorderConnection.borderPointA)
             status = 1;

            // Test candidate's borderPointB
            if(rivalBorderConnection.borderPointA == candidateBorderConnection.borderPointB) 
             status = 2;
            
            if(rivalBorderConnection.borderPointB == candidateBorderConnection.borderPointB)
             status = 2;

            /* Maybe this will be useful sometime
            if(requestedRsk.specialRelation == true && loopedRsk.specialRelation ==  true)
              if(requestedRsk.angle > loopedRsk.angle)
                print("it's higher");              
            */

            // If the status is different from zero, then the other border Connection,
            // is already using the same point as the candidate, A CHALLENGER APPEARS.
            // A dispute for whom has the best angle and will have the point begins
            if(status != 0){
              // Who has the best angle then?

              // Maybe the one that I'm testing? the candidateBorderConnection?
              // If the angle from the candidate is larger than the other border connection,
              // then this point belongs to the requestedRSK*/
              if(candidateBorderConnection.angle > rivalBorderConnection.angle){
                // Now, if the looped rsk is a specialRelation, I cannot use this point, it belongs
                // to the specialRelation, remove it and calculate again!
                if(rivalBorderConnection.specialRelation == true){
                    return status;
                }
                else
                {
                  // Please, redefine yo best, rival!
                  rivalBorderConnection.clearBorderPointsAndAngle();
                  _defineBestPoint(rivalBorderConnection);
                  status = 0; // Candidate can have that point, I think I don't return it here due to recursion.
                }
              } else {
                // If it's not, then return the status because this point is already taken by another table*/
                return status;
              }
            } else {
              status = 0;
          }
        }
      }
    }

    // If it has arrived here, the status is 0 and this is the best
    return status;
  }

  /** Returns an array containing the closest points of two lists.
   *  the 0 index belongs to list A
   *  the 1 index belongs to list B */
  List <BorderPoint> _getClosestPointsOfList(List<BorderPoint> listA, List<BorderPoint> listB, bool enforcedOppositeBorderForModelA){
    BorderPoint closestPointA = null;
    BorderPoint closestPointB = null;
    num closestDistance = dummyMaxDistance;
    
    //Between these two tables, what are the closest borders between then?
    for(BorderPoint bpA in listA)
    {
      for(BorderPoint bpB in listB)
      {
        num newDistance = distance2D(bpA.point, bpB.point);
        if(newDistance < closestDistance)
        {
          closestDistance = newDistance;
          closestPointA = bpA;
          closestPointB = bpB;
        }
      }
    }
    
    List<BorderPoint> closestBorders = new List<BorderPoint>();
    
    if(enforcedOppositeBorderForModelA){
      // Enforces the model A gives a the opposite border for best BorderPoint of B
      switch(closestPointB.borderCode){
      case BorderPoint.NORTH:
        closestPointA = _getBorderPointFromBorder(listA, BorderPoint.SOUTH);
        break;
      case BorderPoint.SOUTH:
        closestPointA = _getBorderPointFromBorder(listA, BorderPoint.NORTH);
        break;
      case BorderPoint.WEST:
        closestPointA = _getBorderPointFromBorder(listA, BorderPoint.EAST);
        break;
      case BorderPoint.EAST:
        closestPointA = _getBorderPointFromBorder(listA, BorderPoint.WEST);
        break;
      }
    } 
    
    closestBorders.add(closestPointA);
    closestBorders.add(closestPointB);
    return closestBorders;
  }
  
  BorderPoint _getBorderPointFromBorder(List<BorderPoint> points, String borderCode){
    for(BorderPoint bp in points){
      if(bp.borderCode == borderCode)
        return bp;
    }
  }
  
  bool isIntersecting(BaseCanvasModel canvasModel){
    if(canvasModel.isPositionEmpty())
      return false;
    
    for(BaseCanvasModel modelFromList in canvasModels){
      if(modelFromList != canvasModel){
        if(canvasModel.intersectsBaseCanvasModel(modelFromList))
          return true;
      }
    }
    return false;
  }
}