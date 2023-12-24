import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RGBColorSelector extends StatefulWidget {
  const RGBColorSelector({super.key, required this.changeTheme});

  final Function changeTheme;

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
              child: Slider(
                value: redValue,
                onChanged: (value) {
                  setState(() {
                    redValue = value;
                    widget.changeTheme(
                        red: redValue.round(),
                        green: greenValue.round(),
                        blue: blueValue.round());
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
                child: Slider(
                  value: greenValue,
                  onChanged: (value) {
                    setState(() {
                      greenValue = value;
                      widget.changeTheme(
                          red: redValue.round(),
                          green: greenValue.round(),
                          blue: blueValue.round());
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
                child: Slider(
                  value: blueValue,
                  onChanged: (value) {
                    setState(() {
                      blueValue = value;
                      widget.changeTheme(
                          red: redValue.round(),
                          green: greenValue.round(),
                          blue: blueValue.round());
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
