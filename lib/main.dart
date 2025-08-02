import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/data/models/hive_todo.dart';
import 'package:todo/presentation/todo_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize any necessary services or repositories here
  // For example, if using Hive for local storage, initialize it here
  await Hive.initFlutter();
  Hive.registerAdapter(HiveTodoAdapter());
  await Hive.openBox<HiveTodo>('todos');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListView(),
    );
  }
}
