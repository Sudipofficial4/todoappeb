/*
* Hive implementation of Todo repository
*/
import 'package:hive/hive.dart';
import 'package:todo/data/models/hive_todo.dart';
import 'package:todo/domain/models/todo.dart';
import 'package:todo/domain/repo/todo_repo.dart';

class HiveTodoRepository implements TodoRepo {
  final Box<HiveTodo> _box;

  HiveTodoRepository(this._box);

  @override
  Future<void> addTodo(Todo newTodo) async {
    // Convert the domain model to Hive model and store it in the Hive box
    final hiveTodo = HiveTodo.fromDomain(newTodo);
    await _box.put(hiveTodo.id, hiveTodo);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    // Update the todo in the Hive box using its unique identifier
    final hiveTodo = HiveTodo.fromDomain(todo);
    await _box.put(hiveTodo.id, hiveTodo);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    // Delete the todo from the Hive box using its unique identifier
    await _box.delete(todo.id);
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    // Retrieve all todos from the Hive box and convert them to domain models
    final todos = _box.values.map((hiveTodo) => hiveTodo.toDomain()).toList();
    return todos;
  }
}
