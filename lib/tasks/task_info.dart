import 'package:flutter/material.dart';

class TaskInfo extends StatefulWidget {
  final String text;
  final String defaultText;
  final EdgeInsets padding;
  final Function parentFinishEditing;
  final bool isRequired;
  final bool beginWithEditingState;
  final TextStyle? style;

  const TaskInfo(
      {super.key,
      this.style,
      this.isRequired = false,
      this.beginWithEditingState = false,
      required this.defaultText,
      required this.text,
      required this.padding,
      required this.parentFinishEditing});

  @override
  State<StatefulWidget> createState() => TaskInfoState();
}

class TaskInfoState extends State<TaskInfo> {
  String _text = "";
  var _isEditing = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.beginWithEditingState;
    _text = widget.text;
  }

  String get text => _text;

  void finishEditing() {
    if (!_isEditing) return;
    final newText = controller.text;
    setState(() {
      _isEditing = false;
      _text = newText.isEmpty
          ? (widget.isRequired ? widget.defaultText : "")
          : newText;
    });
  }

  void startEditing() {
    if (_isEditing) return;
    setState(() {
      _isEditing = true;
      controller.text = _text;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          startEditing();
        },
        child: Padding(
          padding: widget.padding,
          child: _isEditing
              ? SizedBox(
                  width: 200,
                  height: 30,
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(hintText: widget.defaultText),
                    onSubmitted: (newText) {
                      widget.parentFinishEditing();
                    },
                  ),
                )
              : Text(
                  _text,
                  style: widget.style,
                ),
        ));
  }
}
