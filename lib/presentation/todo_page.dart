/*
Todo Page
responsible for displaying the list of todos and handling user interactions in the UI
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/domain/repo/todo_repo.dart';
import 'package:todo/presentation/todo_cubit.dart';
import 'package:todo/presentation/todo_view.dart';

class TodoPage extends StatelessWidget {
  final TodoRepo todoRepo;
  const TodoPage({super.key, required this.todoRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(todoRepo),
      child: const TodoListView(),
    );
  }
}
