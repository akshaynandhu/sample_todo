import 'package:hive_flutter/adapters.dart';
part 'model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject{
  @HiveField(0)
  String title;
  @HiveField(1)
  String description;
  @HiveField(2)
  dynamic time;

  TodoModel({required this.title, required this.description,required this.time});
}