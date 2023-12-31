import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/tasks/tasks_repo.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<TasksRepo>().items;
    return items.isEmpty
        ? const Center(child: Text('You have no tasks.'))
        : SingleChildScrollView(child: Column(children: items));
  }
}
