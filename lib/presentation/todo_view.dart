import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/models/todo.dart';
import 'package:todo/presentation/todo_cubit.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});
  void _showAddTodoDialog(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();
    // Show a dialog to add a new todo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: textController,
            onSubmitted: (value) {
              todoCubit.addTodo(
                Todo(
                  id: UniqueKey().toString(),
                  title: value,
                  description: '',
                  createdAt: DateTime.now(),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                todoCubit.addTodo(
                  Todo(
                    id: UniqueKey().toString(),
                    title: textController.text,
                    description: '',
                    createdAt: DateTime.now(),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      //bloc builder
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.description),
                trailing: IconButton(
                  icon: Icon(
                    todo.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                  onPressed: () {
                    todoCubit.toggleTodoCompletion(todo);
                  },
                ),
                onLongPress: () {
                  todoCubit.deleteTodo(todo);
                },
              );
            },
          );
        },
      ),
    );
  }
}
