import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo/tasks/task.dart';
import 'package:path_provider/path_provider.dart';

class TasksList extends StatefulWidget {
  const TasksList({super.key});

  @override
  State<TasksList> createState() => TasksListState();
}

class TasksListState extends State<TasksList> {
  final List<Task> items = [];
  int newItemId = 0;

  @override
  void initState() {
    super.initState();
    _readData();
  }

  void addNewItem() {
    Task newItem = Task(
      key: UniqueKey(),
      title: "New Task",
      id: newItemId,
      beginWithEditingState: true,
      removeItem: _removeItem,
      saveData: _saveData,
    );

    setState(() {
      items.add(newItem);
      newItemId++;
    });
  }

  void _removeItem(int id) {
    setState(() {
      for (int i = 0; i < items.length; i++) {
        if (items[i].id == id) {
          items.removeAt(i);
          break;
        }
      }
      _saveData();
    });
  }

  Future<void> _saveData() async {
    var directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/items.txt');
    IOSink sink = file.openWrite(mode: FileMode.write);
    for (var item in items) {
      sink.write('${jsonEncode(item.toMap())}\n');
    }
    await sink.close();
    _readData();
  }

  Future<void> _readData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/items.txt');
    final List<Task> fileItems = [];
    if (file.existsSync()) {
      for (var line in file.readAsLinesSync()) {
        fileItems.add(Task.fromJsonObject(jsonDecode(line),
            removeItem: _removeItem,
            key: UniqueKey(),
            saveData: _saveData,
            id: newItemId));
        newItemId++;
      }

      setState(() {
        items.clear();
        items.addAll(fileItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? const Center(child: Text('You have no tasks.'))
        : SingleChildScrollView(child: Column(children: items));
  }
}
