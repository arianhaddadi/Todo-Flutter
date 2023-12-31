import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:todo/settings/color_theme.dart';

class RGBColorSelector extends StatefulWidget {
  const RGBColorSelector({super.key});

  @override
  State<StatefulWidget> createState() => _RGBColorSelectorState();
}

class _RGBColorSelectorState extends State<RGBColorSelector> {
  double redValue = 0;
  double greenValue = 0;
  double blueValue = 0;

  void _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      redValue = prefs.getInt("red")?.toDouble() ?? 0;
      greenValue = prefs.getInt("green")?.toDouble() ?? 0;
      blueValue = prefs.getInt("blue")?.toDouble() ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _changeAppTheme() {
    context.read<ColorTheme>().setThemeSeedColor(
        red: redValue.round(),
        green: greenValue.round(),
        blue: blueValue.round());
  }

  Widget _renderSliders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Red: ${redValue.round()}'),
            RotatedBox(
              quarterTurns: 3,
              child: CupertinoSlider(
                value: redValue,
                thumbColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    redValue = value;
                    _changeAppTheme();
                  });
                },
                min: 0,
                max: 255,
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Green: ${greenValue.round()}'),
            RotatedBox(
                quarterTurns: 3,
                child: CupertinoSlider(
                  value: greenValue,
                  thumbColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      greenValue = value;
                      _changeAppTheme();
                    });
                  },
                  min: 0,
                  max: 255,
                ))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Blue: ${blueValue.round()}'),
            RotatedBox(
                quarterTurns: 3,
                child: CupertinoSlider(
                  value: blueValue,
                  thumbColor: Theme.of(context).colorScheme.primary,
                  onChanged: (value) {
                    setState(() {
                      blueValue = value;
                      _changeAppTheme();
                    });
                  },
                  min: 0,
                  max: 255,
                ))
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text("App's Theme", style: TextStyle(fontSize: 20)),
        _renderSliders()
      ],
    );
  }
}
