import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:todo/tasks/task.dart';
import 'package:flutter/material.dart';

class TasksRepo with ChangeNotifier {
  final List<Task> items = [];
  int newItemId = 0;

  TasksRepo() {
    _readData();
  }

  void addNewItem() {
    Task newItem = Task(
      key: UniqueKey(),
      title: "New Task",
      id: newItemId,
      beginWithEditingState: true,
    );

    items.add(newItem);
    newItemId++;
    notifyListeners();
  }

  void removeItem(int id) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        items.removeAt(i);
        break;
      }
    }
    saveData();
  }

  Future<void> saveData() async {
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
            key: UniqueKey(), id: newItemId));
        newItemId++;
      }

      items.clear();
      items.addAll(fileItems);
      notifyListeners();
    }
  }
}
