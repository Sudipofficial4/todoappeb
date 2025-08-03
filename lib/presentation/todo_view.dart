import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/models/todo.dart';
import 'package:todo/presentation/todo_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  String _getSortOptionLabel(SortOption option) {
    return option.displayName;
  }

  String _getFilterOptionLabel(FilterOption option) {
    return option.displayName;
  }

  void _showEditTodoDialog(BuildContext context, Todo todo) {
    final todoCubit = context.read<TodoCubit>();
    final titleController = TextEditingController(text: todo.title);
    final descriptionController = TextEditingController(text: todo.description);
    DateTime? selectedDueDate = todo.dueDate;
    Priority selectedPriority = todo.priority;

    // Show a dialog to edit the todo
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Todo'),
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
                  DropdownButtonFormField<Priority>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        Priority.values.map((Priority priority) {
                          return DropdownMenuItem<Priority>(
                            value: priority,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color:
                                      priority == Priority.high
                                          ? Colors.red
                                          : priority == Priority.medium
                                          ? Colors.orange
                                          : Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(priority.displayName),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (Priority? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPriority = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final today = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDueDate ?? today,
                              firstDate: today, // Prevent selecting past dates
                              lastDate: DateTime(2100),
                            );
                            if (date != null && context.mounted) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime:
                                    selectedDueDate != null
                                        ? TimeOfDay.fromDateTime(
                                          selectedDueDate!,
                                        )
                                        : TimeOfDay.now(),
                              );
                              if (time != null) {
                                final selectedDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );

                                // Check if the selected time is in the past for today's date
                                if (selectedDateTime.isAfter(now)) {
                                  setState(() {
                                    selectedDueDate = selectedDateTime;
                                  });
                                } else {
                                  // Show error message for past time
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select a future date and time',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                          },
                          child: const Text('Pick Date & Time'),
                        ),
                      ),
                      if (selectedDueDate != null)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDueDate = null;
                            });
                          },
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear date',
                        ),
                    ],
                  ),
                  if (selectedDueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Due: ${_formatDateTime(selectedDueDate!)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
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
                      final updatedTodo = Todo(
                        id: todo.id,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        createdAt: todo.createdAt,
                        isCompleted: todo.isCompleted,
                        dueDate: selectedDueDate,
                        priority: selectedPriority,
                      );
                      todoCubit.updateTodo(updatedTodo);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? selectedDueDate;
    Priority selectedPriority = Priority.medium;

    // Show a dialog to add a new todo
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  DropdownButtonFormField<Priority>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        Priority.values.map((Priority priority) {
                          return DropdownMenuItem<Priority>(
                            value: priority,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color:
                                      priority == Priority.high
                                          ? Colors.red
                                          : priority == Priority.medium
                                          ? Colors.orange
                                          : Colors.green,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(priority.displayName),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (Priority? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPriority = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final today = DateTime(
                              now.year,
                              now.month,
                              now.day,
                            );
                            final date = await showDatePicker(
                              context: context,
                              initialDate: today,
                              firstDate: today, // Prevent selecting past dates
                              lastDate: DateTime(2100),
                            );
                            if (date != null && context.mounted) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                final selectedDateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );

                                // Check if the selected time is in the past for today's date
                                if (selectedDateTime.isAfter(now)) {
                                  setState(() {
                                    selectedDueDate = selectedDateTime;
                                  });
                                } else {
                                  // Show error message for past time
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select a future date and time',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            }
                          },
                          child: const Text('Pick Date & Time'),
                        ),
                      ),
                      if (selectedDueDate != null)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDueDate = null;
                            });
                          },
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear date',
                        ),
                    ],
                  ),
                  if (selectedDueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Due: ${_formatDateTime(selectedDueDate!)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
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
                          dueDate: selectedDueDate,
                          priority: selectedPriority,
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
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool _isDueDatePassed(DateTime dueDate) {
    return DateTime.now().isAfter(dueDate);
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    return Scaffold(
      //drawer to view details
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey[900],
              height: 200,
              width: double.infinity,
              child: const Center(
                child: Text(
                  "Todo App",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context); // Close drawer first
                launchUrl(Uri.parse("https://www.sudipkoirala44.com.np/"));
              },
              leading: const Icon(Icons.person_2),
              title: const Text(
                "Get In Touch",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context); // Close drawer first
                launchUrl(
                  Uri.parse("https://www.facebook.com/sudip.koirala.415846"),
                );
              },
              leading: const Icon(Icons.facebook),
              title: const Text(
                "About me",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.tune),
            tooltip: 'Sort & Filter',
            itemBuilder: (BuildContext context) {
              return [
                // Filter Section
                const PopupMenuItem<String>(
                  enabled: false,
                  child: Text(
                    'FILTER TASKS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ...FilterOption.values.map((FilterOption option) {
                  return PopupMenuItem<String>(
                    value: 'filter_${option.name}',
                    child: Row(
                      children: [
                        Icon(
                          todoCubit.currentFilterOption == option
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color:
                              todoCubit.currentFilterOption == option
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(_getFilterOptionLabel(option)),
                      ],
                    ),
                  );
                }),
                const PopupMenuDivider(),
                // Sort Section
                const PopupMenuItem<String>(
                  enabled: false,
                  child: Text(
                    'SORT TASKS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                //sorting current sort option
                ...SortOption.values.map((SortOption option) {
                  return PopupMenuItem<String>(
                    value: 'sort_${option.name}',
                    child: Row(
                      children: [
                        Icon(
                          todoCubit.currentSortOption == option
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color:
                              todoCubit.currentSortOption == option
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(_getSortOptionLabel(option)),
                      ],
                    ),
                  );
                }),
              ];
            },
            onSelected: (String value) {
              if (value.startsWith('filter_')) {
                final filterName = value.substring(7);
                final filterOption = FilterOption.values.firstWhere(
                  (e) => e.name == filterName,
                );
                todoCubit.changeFilterOption(filterOption);
              } else if (value.startsWith('sort_')) {
                final sortName = value.substring(5);
                final sortOption = SortOption.values.firstWhere(
                  (e) => e.name == sortName,
                );
                todoCubit.changeSortOption(sortOption);
              }
            },
          ),
        ],
      ),
      //to take the todo task
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        onPressed: () {
          _showAddTodoDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.black, size: 30),
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
                  onTap: () => _showEditTodoDialog(context, todo),
                  //title with due date
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: TextStyle(
                          decoration:
                              todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      if (todo.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 16,
                                color:
                                    _isDueDatePassed(todo.dueDate!)
                                        ? Colors.red
                                        : Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDateTime(todo.dueDate!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      _isDueDatePassed(todo.dueDate!)
                                          ? Colors.red
                                          : Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  decoration:
                                      todo.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Priority indicator
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flag,
                              size: 16,
                              color:
                                  todo.priority == Priority.high
                                      ? Colors.red
                                      : todo.priority == Priority.medium
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${todo.priority.displayName} Priority',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    todo.priority == Priority.high
                                        ? Colors.red
                                        : todo.priority == Priority.medium
                                        ? Colors.orange
                                        : Colors.green,
                                fontWeight: FontWeight.w500,
                                decoration:
                                    todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Missed indicator for overdue incomplete tasks
                      if (todo.dueDate != null &&
                          !todo.isCompleted &&
                          _isDueDatePassed(todo.dueDate!))
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              border: Border.all(color: Colors.red, width: 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: 14,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'MISSED',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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
