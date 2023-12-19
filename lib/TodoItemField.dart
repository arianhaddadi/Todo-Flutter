import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoItemField extends StatefulWidget {
  final String text;
  final EdgeInsets padding;
  final TextStyle? style;

  TodoItemField(
      {super.key, required this.text, required this.padding, this.style});

  @override
  State<StatefulWidget> createState() => _TodoItemFieldState();
}

class _TodoItemFieldState extends State<TodoItemField> {
  final List<String> tags = [];
  late String text = widget.text;
  TextEditingController controller = TextEditingController();
  var isEditing = false;
  var width = 200;

  @override
  void initState() {
    super.initState();
  }

  void finishEditing(String newText) {
    setState(() {
      isEditing = false;
      text = newText;
    });
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

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
        ));
  }
}
