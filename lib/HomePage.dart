import 'package:flutter/material.dart';
import 'package:todo/TodoItem.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TodoItem> items = [];

  void _incrementCounter(TodoItem? item) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getItems()
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(null),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}