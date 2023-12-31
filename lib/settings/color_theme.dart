import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorTheme with ChangeNotifier {
  Color colorTheme = Colors.indigo;

  ColorTheme() {
    _loadSettings();
  }

  void setThemeSeedColor(
      {required int red, required int green, required int blue}) {
    colorTheme = Color.fromRGBO(red, green, blue, 1);
    notifyListeners();
    _storeSettings(red, green, blue);
  }

  void _storeSettings(int red, int green, int blue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("red", red);
    await prefs.setInt("green", green);
    await prefs.setInt("blue", blue);
  }

  void _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final red = prefs.getInt("red") ?? colorTheme.red;
    final green = prefs.getInt("green") ?? colorTheme.green;
    final blue = prefs.getInt("blue") ?? colorTheme.blue;
    setThemeSeedColor(red: red, green: green, blue: blue);
    notifyListeners();
  }
}
