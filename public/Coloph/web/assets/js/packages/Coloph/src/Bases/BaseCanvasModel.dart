part of coloph;

abstract class BaseCanvasModel extends BaseModel{ // implements Border {
  int diagramId;
  num x;
  num y;
  num width;
  num height;
  List<BorderPoint> centralBorderPoints;
  List<String>      borderUtilization;
  List<BorderPoint> borderConnectionPoints;

  BaseCanvasModel(int diagramId, num x, num y){
    this.diagramId = diagramId;
    this.x = x;
    this.y = y;
    this.width = 0; // Width and height are calculated dynamically
    this.height = 0;
    this.centralBorderPoints = [];
    updateCentralBorderPoints();
    borderUtilization = [];
  }
  
  void updateLocation(Point newLocation){
    this.x = newLocation.x;
    this.y = newLocation.y;
    updateCentralBorderPoints();
  }

  void updateCentralBorderPoints(){
    List<BorderPoint> borderPoints = new List<BorderPoint>();
    Point centerPoint;

    centerPoint = new Point((x + (width / 2)), y);
    borderPoints.add(new BorderPoint(centerPoint, BorderPoint.NORTH ) );

    centerPoint = new Point(x , ( y + (height / 2) ) );
    borderPoints.add(new BorderPoint(centerPoint, BorderPoint.WEST ) );

    centerPoint = new Point(x + width , ( y + (height / 2) ) );
    borderPoints.add(new BorderPoint(centerPoint, BorderPoint.EAST ) );

    centerPoint = new Point( (x + (width / 2)), y + height);
    borderPoints.add(new BorderPoint(centerPoint, BorderPoint.SOUTH) );

    this.centralBorderPoints = borderPoints;
  }

  List<BorderPoint> getConnectionPointsFromBorder(String borderCode){
    List<BorderPoint> conectionPointsOfBorder = [];

    for(BorderPoint bp in borderConnectionPoints){
      if(bp.borderCode == borderCode)
        conectionPointsOfBorder.add(bp);
    }
    return conectionPointsOfBorder;
  }

  void generateBorderSegments(){
     int numNorthPoints = 0;
     int numSouthPoints = 0;
     int numEastPoints  = 0;
     int numWestPoints  = 0;
     borderConnectionPoints = [];

     // Counts the number of points used in each border
     for(String borderCode in borderUtilization){
       switch(borderCode)
       {
         case BorderPoint.NORTH:
           numNorthPoints++;
           break;
         case BorderPoint.SOUTH:
           numSouthPoints++;
           break;
         case BorderPoint.WEST:
           numWestPoints++;
           break;
         case BorderPoint.EAST:
           numEastPoints++;
           break;
       }
     }
      
     if(numNorthPoints != 0) {
       borderConnectionPoints.addAll(_getSegmentedBorderPoints(BorderPoint.NORTH,numNorthPoints) );
     }
     if(numSouthPoints != 0) {
       borderConnectionPoints.addAll(_getSegmentedBorderPoints(BorderPoint.SOUTH,numSouthPoints) );
     }
     if(numWestPoints != 0) {
       borderConnectionPoints.addAll(_getSegmentedBorderPoints(BorderPoint.WEST,numWestPoints) );
     }
     if(numEastPoints != 0) {
       borderConnectionPoints.addAll(_getSegmentedBorderPoints(BorderPoint.EAST,numEastPoints) );
     }

     /*Clear the utilization border list*/
     borderUtilization = [];
  }

  List<BorderPoint> getCentralBorderPoints(){
    return this.centralBorderPoints;
  }

  void addBorderUtilization(String borderCode){
    borderUtilization.add(borderCode);
  }
  
  List<BorderPoint> _getSegmentedBorderPoints(String borderCode, num numberOfSegments){
      if (numberOfSegments < 1)
        return null;
      
      List<BorderPoint> splitedBorderPoints = [];
      Point startBorderPoint;
      Point endBorderPoint;

      switch(borderCode){
        case BorderPoint.NORTH:
          startBorderPoint = new Point(x, y);
          endBorderPoint   = new Point(x + width, y);
          break;
        case BorderPoint.SOUTH:
          startBorderPoint = new Point(x, y + height);
          endBorderPoint   = new Point(x + width, y + height );
          break;
        case BorderPoint.WEST:
          startBorderPoint = new Point(x, y);
          endBorderPoint   = new Point(x, y + height);
          break;
        case BorderPoint.EAST:
          startBorderPoint = new Point(x + width, y);
          endBorderPoint   = new Point(x + width, y + height);
          break;
      }

      List<Point> segmentedPoints = segmentLine(startBorderPoint, endBorderPoint, numberOfSegments);
      
      for(Point point in segmentedPoints){
        splitedBorderPoints.add(new BorderPoint(point, borderCode));
      }
      
      return splitedBorderPoints;
  }
  

  bool intersectsBaseCanvasModel(BaseCanvasModel other){
    return (x <= other.x + other.width && other.x <= x + width &&
        y <= other.y + other.height && other.y <= y + height);
    
  }
    
  bool areThereFieldsWithDuplicatedNames(){
    for(BaseField fieldA in getFields()){
      for(BaseField fieldB in getFields())
        if(fieldA != fieldB)
          if(fieldA.name == fieldB.name)
            return true;
    }
  }
  
  List<Map> mapFields([BaseCanvasModel oldModel]){
    List<Map> mappedFields = new List<Map>();
    for(BaseField baseField in getFields()){
      if(baseField.foreignKey.value == true)
        continue; 
      
      if(oldModel == null) //No old Table passed, not editing
        mappedFields.add(baseField.toMap());
      
      if(oldModel != null) // editing
        //Check if the tableField already exists, if it does, passes it to the tableFieldMapping
        //in order to check sub table fields
        if(oldModel.hasField(baseField.name)){
          for(BaseField oldTableField in oldModel.getFields()){
            if(oldTableField.name == baseField.name)
              mappedFields.add(baseField.toMap(false, oldTableField));  
          }
        }
        else{// new field while editing
          baseField.id = null; //Reset the id so it can create a new one
          mappedFields.add(baseField.toMap());
        }
    }
    
    //Fields from the oldTable which have been deleted, must be deleted aswell in the back-end
    if(oldModel != null){
      for(BaseField oldTableField in oldModel.getFields()){
        if(this.hasField(oldTableField.name) == false)
          mappedFields.add(oldTableField.toMap(true));
      }
    }
    
    
    return mappedFields;
  }
  
  bool hasField(String name){
    for(BaseField baseField in this.getFields()){
      if(baseField.name == name)
        return true;
    }
    return false;
  }
  
  bool isPositionEmpty(){
    if(x == 0 && y == 0 && width == 0 && height == 0)
      return true;
    else
      return false;
  }
 
}

