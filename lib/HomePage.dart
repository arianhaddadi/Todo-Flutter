import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo/TodoItem.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final List<TodoItem> items = [
    TodoItem(id: 1, title: "Learn Flutter", notes: "Do it soon!", tags: const ["Job", "Code"]),
    TodoItem(id: 2, title: "Learn iOS", notes: "Do it Later!", tags: const ["Mac", "XCode"]),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _addNewItem(TodoItem? item) {
    setState(() {
      items.add(item!);
    });
  }

  Future<void> _saveData() async {
    final directory = await getExternalStorageDirectory();
    print(directory?.path);
    final file = File('${directory?.path}/items.txt');
    IOSink sink = file.openWrite(mode: FileMode.write);
    for (var item in items) {
      sink.write('${jsonEncode(item.toMap())}\n');
    }
    sink.close();
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
          Column(children: items),
          const Center(child: Text('Settings')),
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
        onPressed: () => _addNewItem(null),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}