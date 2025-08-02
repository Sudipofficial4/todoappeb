/*
* Hive implementation of Todo model
*/
import 'package:hive/hive.dart';
import 'package:todo/domain/models/todo.dart';

//to generate hive todo objects run: dart run build_runner build
part 'hive_todo.g.dart';

@HiveType(typeId: 0)
class HiveTodo extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late bool isCompleted;
  @HiveField(4)
  late DateTime createdAt;
  // convert hive todo to domain todo
  Todo toDomain() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }

  // convert from domain todo to hive todo
  static HiveTodo fromDomain(Todo todo) {
    return HiveTodo()
      ..id = todo.id
      ..title = todo.title
      ..description = todo.description
      ..isCompleted = todo.isCompleted
      ..createdAt = todo.createdAt;
  }
}
