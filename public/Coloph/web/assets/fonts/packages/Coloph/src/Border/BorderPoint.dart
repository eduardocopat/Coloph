part of coloph;

class BorderPoint {
    Point  point;
    String borderCode;

    static const String NORTH = "NORTH";
    static const String SOUTH = "SOUTH";
    static const String WEST = "WEST";
    static const String EAST = "EAST";

    BorderPoint(Point point, String borderCode){
      this.point = point;
      this.borderCode  = borderCode;
    }

}
