import 'package:flutter/material.dart';
import 'package:todo/TodoItem.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  List<TodoItem> items = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Specify the number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addNewItem(TodoItem? item) {
    setState(() {
      items.add(item!);
    });
  }


  List<Widget> getItems() {
    return items.map((e) => Text(e.title)).toList();
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
        children: const [
          Center(child: Text('Tab 1 Content')),
          Center(child: Text('Tab 2 Content')),
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