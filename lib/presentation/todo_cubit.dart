import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/models/todo.dart';
import 'package:todo/domain/repo/todo_repo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  //reference to the Todo repository
  //this will be used to interact with the data layer
  final TodoRepo todoRepo;

  TodoCubit(this.todoRepo) : super([]) {
    //initially fetch all todos when the cubit is created
    fetchTodos();
  }
  //add a new todo
  Future<void> addTodo(Todo newTodo) async {
    await todoRepo.addTodo(newTodo);
    fetchTodos();
  }

  //toggle completion status of a todo
  Future<void> toggleTodoCompletion(Todo todo) async {
    final updatedTodo = todo.togglecompleted();
    await todoRepo.updateTodo(updatedTodo);
    fetchTodos();
  }

  //update a todo
  Future<void> updateTodo(Todo updatedTodo) async {
    await todoRepo.updateTodo(updatedTodo);
    fetchTodos();
  }

  //delete a todo
  Future<void> deleteTodo(Todo todo) async {
    await todoRepo.deleteTodo(todo);
    fetchTodos();
  }

  //fetch all todos from the repository and emit the list
  Future<void> fetchTodos() async {
    final todoList = await todoRepo.getTodos();
    emit(todoList);
  }
}
