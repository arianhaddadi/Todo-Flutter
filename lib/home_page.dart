import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/settings/rgb_selector.dart';
import 'package:todo/todo_item/todo_item.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.changeTheme});

  final String title;
  final Function changeTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<TodoItem> items = [];
  int newItemId = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _readData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addNewItem() {
    TodoItem newItem = TodoItem(
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
    var directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/items.txt');
    IOSink sink = file.openWrite(mode: FileMode.write);
    for (var item in items) {
      sink.write('${jsonEncode(item.toMap())}\n');
    }
    await sink.close();
    _readData();
  }

  Future<void> _readData() async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/items.txt');
    final List<TodoItem> fileItems = [];
    if (file.existsSync()) {
      for (var line in file.readAsLinesSync()) {
        fileItems.add(TodoItem.fromJsonObject(jsonDecode(line),
            removeItem: _removeItem,
            key: UniqueKey(),
            saveData: _saveData,
            id: newItemId));
        newItemId++;
      }
    }

    setState(() {
      items.clear();
      items.addAll(fileItems);
    });
  }

  Widget _renderItems() {
    if (items.isEmpty) {
      return const Center(child: Text('You have no tasks.'));
    } else {
      return SingleChildScrollView(child: Column(children: items));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _renderItems(),
          RGBColorSelector(changeTheme: widget.changeTheme),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(icon: Icon(Icons.list)),
          Tab(icon: Icon(Icons.settings)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _tabController.animateTo(0);
          _addNewItem();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
