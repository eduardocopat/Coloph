part of coloph;

abstract class BaseModel{
  int id;
  String toJson();
  List<BaseField> getFields();
}