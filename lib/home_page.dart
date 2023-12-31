import 'package:flutter/material.dart';
import 'package:todo/settings/rgb_selector.dart';
import 'package:todo/tasks/tasks_list.dart';
import 'package:provider/provider.dart';
import 'package:todo/tasks/tasks_repo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Tasks"),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TasksList(),
          RGBColorSelector(),
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
          context.read<TasksRepo>().addNewItem();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
