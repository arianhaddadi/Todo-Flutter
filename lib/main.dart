import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color themeSeedColor = Colors.indigo;

  void _setThemeSeedColor(
      {required int red, required int green, required int blue}) {
    setState(() {
      themeSeedColor = Color.fromRGBO(red, green, blue, 1);
      _storeSettings(red, green, blue);
    });
  }

  void _storeSettings(int red, int green, int blue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("red", red);
    await prefs.setInt("green", green);
    await prefs.setInt("blue", blue);
  }

  void _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final red = prefs.getInt("red") ?? themeSeedColor.red;
    final green = prefs.getInt("green") ?? themeSeedColor.green;
    final blue = prefs.getInt("blue") ?? themeSeedColor.blue;
    _setThemeSeedColor(red: red, green: green, blue: blue);
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: themeSeedColor),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Tasks', changeTheme: _setThemeSeedColor),
    );
  }
}
