/*
model for todo item
 properties:
 - id: unique identifier for the todo item -> String (assigned by the database)
  - title: title of the todo item -> String (required )
  - description: description of the todo item -> String (required )
  - isCompleted: status of the todo item -> bool (default: false)
  - createdAt: timestamp when the todo item was created -> DateTime(stored during the event creation)
*/
class Todo {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
  });
  Todo togglecompleted() {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: !isCompleted,
      createdAt: createdAt,
    );
  }
}
