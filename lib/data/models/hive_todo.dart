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
  @HiveField(5)
  DateTime? dueDate;
  @HiveField(6)
  late int priority; // Store as int: 1=low, 2=medium, 3=high
  // convert hive todo to domain todo
  Todo toDomain() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
      dueDate: dueDate,
      priority: Priority.values[priority - 1], // Convert int back to enum
    );
  }

  // convert from domain todo to hive todo
  static HiveTodo fromDomain(Todo todo) {
    return HiveTodo()
      ..id = todo.id
      ..title = todo.title
      ..description = todo.description
      ..isCompleted = todo.isCompleted
      ..createdAt = todo.createdAt
      ..dueDate = todo.dueDate
      ..priority = todo.priority.value; // Convert enum to int
  }
}
