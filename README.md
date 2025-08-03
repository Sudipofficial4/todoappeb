# Todo App

A Flutter-based Todo application built with clean architecture principles, using BLoC state management and Hive for local storage.

## Features

- ✅ Add new todos with title and description
- ✅ Mark todos as completed/incomplete
- ✅ Delete todos
- ✅ Persistent local storage using Hive
- ✅ Clean architecture with separation of concerns
- ✅ BLoC pattern for state management
- ✅ Responsive UI with empty state handling

## Architecture

The app follows Clean Architecture principles:

### Domain Layer
- `Todo` model - Core business entity
- `TodoRepo` - Abstract repository interface

### Data Layer
- `HiveTodo` - Hive-specific model with type adapters
- `HiveTodoRepository` - Concrete implementation of TodoRepo using Hive

### Presentation Layer
- `TodoCubit` - BLoC for state management
- `TodoPage` - Main page with dependency injection
- `TodoView` - UI components and widgets

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Hive adapters:
   ```bash
   dart run build_runner build
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Testing

Run tests with:
```bash
flutter test
```

## Usage

1. **Add Todo**: Tap the floating action button (+) to add a new todo
2. **Complete Todo**: Tap the checkbox to mark a todo as completed
3. **Delete Todo**: Tap the delete (trash) icon to remove a todo

## Dependencies

- `flutter_bloc` - State management
- `hive_flutter` - Local database
- `hive` - NoSQL database
- `build_runner` - Code generation
- `hive_generator` - Hive adapter generation

## Project Structure

```
lib/
├── domain/
│   ├── models/
│   │   └── todo.dart
│   └── repo/
│       └── todo_repo.dart
├── data/
│   └── models/
│       ├── hive_todo.dart
│       ├── hive_todo.g.dart
│       └── repository/
│           └── hive_todo_repo.dart
├── presentation/
│   ├── todo_cubit.dart
│   ├── todo_page.dart
│   └── todo_view.dart
└── main.dart
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request