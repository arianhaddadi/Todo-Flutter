import 'package:flutter/material.dart';
import 'package:todo/home_page.dart';
import 'package:provider/provider.dart';
import 'package:todo/settings/color_theme.dart';
import 'package:todo/tasks/tasks_repo.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TasksRepo()),
      ChangeNotifierProvider(create: (_) => ColorTheme())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color themeSeedColor = context.watch<ColorTheme>().colorTheme;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeSeedColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
