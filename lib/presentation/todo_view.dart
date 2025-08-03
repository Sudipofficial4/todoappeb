import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/models/todo.dart';
import 'package:todo/presentation/todo_cubit.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});
  void _showAddTodoDialog(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    // Show a dialog to add a new todo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    // You can handle the selected date and time here if needed
                  }
                },
                child: const Text('Pick Date & Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  todoCubit.addTodo(
                    Todo(
                      id: UniqueKey().toString(),
                      title: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      createdAt: DateTime.now(),
                    ),
                  );
                  Navigator.of(context).pop();
                }
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
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      //bloc builder
      body: BlocBuilder<TodoCubit, List<Todo>>(
        builder: (context, todos) {
          if (todos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No todos yet!',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  Text(
                    'Tap the + button to add a new todo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  //titile
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  //description of the work
                  subtitle:
                      todo.description.isNotEmpty
                          ? Text(
                            todo.description,
                            style: TextStyle(
                              decoration:
                                  todo.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          )
                          : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          todo.isCompleted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          //if todo is completed, show check box with green color
                          //else show unchecked box
                          color: todo.isCompleted ? Colors.green : null,
                        ),
                        onPressed: () {
                          todoCubit.toggleTodoCompletion(todo);
                        },
                      ),
                      //delete the todo task
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          todoCubit.deleteTodo(todo);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
