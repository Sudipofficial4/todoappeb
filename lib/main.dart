import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/data/models/hive_todo.dart';
import 'package:todo/data/models/repository/hive_todo_repo.dart';
import 'package:todo/presentation/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize any necessary services or repositories here
  // For example, if using Hive for local storage, initialize it here
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveTodoAdapter());

    // Try to open the box, if it fails, delete and recreate it
    try {
      await Hive.openBox<HiveTodo>('todos');
    } catch (e) {
      // If there's an error opening the box (likely due to schema changes),
      // delete the old box and create a new one
      await Hive.deleteBoxFromDisk('todos');
      await Hive.openBox<HiveTodo>('todos');
    }
  } catch (e) {
    // If Hive initialization fails completely, we'll handle it gracefully
    print('Error initializing Hive: $e');
  }

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
    try {
      // Get the Hive box for todos
      final todoBox = Hive.box<HiveTodo>('todos');
      // Create the repository instance
      final todoRepo = HiveTodoRepository(todoBox);

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TodoPage(todoRepo: todoRepo),
      );
    } catch (e) {
      // If there's an error with Hive, show an error screen
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo Apps',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Todo Apps', textAlign: TextAlign.center),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Database Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please restart the app',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // Clear the database and restart
                    try {
                      await Hive.deleteBoxFromDisk('todos');
                      await Hive.openBox<HiveTodo>('todos');
                      // Rebuild the widget
                      if (mounted) {
                        setState(() {});
                      }
                    } catch (e) {
                      print('Error clearing database: $e');
                    }
                  },
                  child: const Text('Clear Data & Restart'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
