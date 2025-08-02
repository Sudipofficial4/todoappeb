/*
used to define what we can do here
for eg : basically according to requirements of todo
-> View a list of tasks
-> Add new tasks
-> Edit existing tasks
-> Delete tasks
*/
import 'package:todo/domain/models/todo.dart';

abstract class TodoRepo {
  //retrieve all todos list
  Future<List<Todo>> getAllTodos();
  //add a new todo
  Future<void> addTodo(Todo newTodo);
  //edit an existing todo
  Future<void> updateTodo(Todo todo);
  //delete a todo
  Future<void> deleteTodo(Todo todo);
}
