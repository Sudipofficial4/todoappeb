// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/domain/models/todo.dart';
import 'package:todo/domain/repo/todo_repo.dart';
import 'package:todo/presentation/todo_page.dart';

// Mock repository for testing
class MockTodoRepo implements TodoRepo {
  final List<Todo> _todos = [];

  @override
  Future<void> addTodo(Todo newTodo) async {
    _todos.add(newTodo);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    _todos.removeWhere((t) => t.id == todo.id);
  }

  @override
  Future<List<Todo>> getTodos() async {
    return List.from(_todos);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }
}

void main() {
  testWidgets('Todo app basic smoke test', (WidgetTester tester) async {
    final mockRepo = MockTodoRepo();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: TodoPage(todoRepo: mockRepo)));

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that our app shows the empty state
    expect(find.text('No todos yet!'), findsOneWidget);
    expect(find.text('Todo App'), findsOneWidget);

    // Verify the floating action button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Todo app can add a todo', (WidgetTester tester) async {
    final mockRepo = MockTodoRepo();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: TodoPage(todoRepo: mockRepo)));

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify the dialog is shown
    expect(find.text('Add New Todo'), findsOneWidget);

    // Enter a todo title
    await tester.enterText(find.byType(TextField).first, 'Test Todo');

    // Tap the add button in the dialog
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify the todo is added and shown in the list
    expect(find.text('Test Todo'), findsOneWidget);
    expect(find.text('No todos yet!'), findsNothing);
  });
}
