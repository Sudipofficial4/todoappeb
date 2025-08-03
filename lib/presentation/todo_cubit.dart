import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/models/todo.dart';
import 'package:todo/domain/repo/todo_repo.dart';

enum SortOption {
  createdDateNewest,
  createdDateOldest,
  dueDateNearest,
  dueDateFarthest,
  alphabetical,
  priority,
}

enum FilterOption {
  all,
  active,
  completed,
}

class TodoCubit extends Cubit<List<Todo>> {
  //reference to the Todo repository
  //this will be used to interact with the data layer
  final TodoRepo todoRepo;
  SortOption _currentSortOption = SortOption.createdDateNewest;
  FilterOption _currentFilterOption = FilterOption.all;

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
    final filteredList = _filterTodos(todoList);
    final sortedList = _sortTodos(filteredList);
    emit(sortedList);
  }

  //change sort option and re-fetch todos
  Future<void> changeSortOption(SortOption sortOption) async {
    _currentSortOption = sortOption;
    fetchTodos();
  }

  //change filter option and re-fetch todos
  Future<void> changeFilterOption(FilterOption filterOption) async {
    _currentFilterOption = filterOption;
    fetchTodos();
  }

  //get current sort option
  SortOption get currentSortOption => _currentSortOption;

  //get current filter option
  FilterOption get currentFilterOption => _currentFilterOption;

  //filter todos based on current filter option
  List<Todo> _filterTodos(List<Todo> todos) {
    switch (_currentFilterOption) {
      case FilterOption.all:
        return todos;
      case FilterOption.active:
        return todos.where((todo) => !todo.isCompleted).toList();
      case FilterOption.completed:
        return todos.where((todo) => todo.isCompleted).toList();
    }
  }

  //sort todos based on current sort option
  List<Todo> _sortTodos(List<Todo> todos) {
    switch (_currentSortOption) {
      case SortOption.createdDateNewest:
        return todos..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortOption.createdDateOldest:
        return todos..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case SortOption.dueDateNearest:
        return todos..sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
      case SortOption.dueDateFarthest:
        return todos..sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return b.dueDate!.compareTo(a.dueDate!);
        });
      case SortOption.alphabetical:
        return todos..sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case SortOption.priority:
        return todos..sort((a, b) => b.priority.value.compareTo(a.priority.value));
    }
  }
}
