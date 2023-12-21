import 'package:flutter/material.dart';

class TodoItemField extends StatefulWidget {
  final String text;
  final String defaultText;
  final EdgeInsets padding;
  final Function saveData;
  final Function parentFinishEditing;
  final bool isRequired;
  final bool beginWithEditingState;
  final TextStyle? style;

  const TodoItemField(
      {super.key,
      this.style,
      this.isRequired = false,
      this.beginWithEditingState = false,
      required this.defaultText,
      required this.text,
      required this.padding,
      required this.saveData,
      required this.parentFinishEditing});

  @override
  State<StatefulWidget> createState() => TodoItemFieldState();
}

class TodoItemFieldState extends State<TodoItemField> {
  String text = "";
  var _isEditing = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.beginWithEditingState;
    text = widget.text;
  }

  void finishEditing() {
    if (!_isEditing) return;
    final newText = controller.text;
    setState(() {
      _isEditing = false;
      text = newText.isEmpty
          ? (widget.isRequired ? widget.defaultText : "")
          : newText;
    });
    widget.saveData();
  }

  void startEditing() {
    if (_isEditing) return;
    setState(() {
      _isEditing = true;
      controller.text = text;
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
                  text,
                  style: widget.style,
                ),
        ));
  }
}
