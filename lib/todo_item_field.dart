import 'package:flutter/material.dart';

class TodoItemField extends StatefulWidget {
  final String text;
  final EdgeInsets padding;
  final Function saveData;
  final TextStyle? style;

  const TodoItemField(
      {super.key, required this.text, required this.padding, this.style, required this.saveData});

  @override
  State<StatefulWidget> createState() => TodoItemFieldState();
}

class TodoItemFieldState extends State<TodoItemField> {
  late String text = widget.text;
  TextEditingController controller = TextEditingController();
  var isEditing = false;

  void finishEditing(String newText) {
    setState(() {
      isEditing = false;
      text = newText.isEmpty ? "New Task" : newText;
    });
    widget.saveData();
  }

  void startEditing() {
    setState(() {
      isEditing = true;
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
          child: isEditing
              ? Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        onSubmitted: (newText) {
                          finishEditing(newText);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        finishEditing(controller.text);
                      },
                      child: const Icon(Icons.check),
                    )
                  ],
                )
              : Text(
                  text,
                  style: widget.style,
                ),
        )
    );
  }
}
