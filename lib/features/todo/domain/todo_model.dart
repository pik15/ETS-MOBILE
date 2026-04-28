import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement;

  late String title;
  
  bool isCompleted = false;
}