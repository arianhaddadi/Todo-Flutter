import 'package:flutter/material.dart';
import 'package:todo/todo_item_field.dart';

class TodoItem extends StatelessWidget {
  late final int id;
  late final String title;
  late final String? notes;
  late final List<String>? tags;
  final Function removeItem;
  final Function saveData;
  final GlobalKey<TodoItemFieldState> titleGlobalKey =
      GlobalKey<TodoItemFieldState>();
  final GlobalKey<TodoItemFieldState> notesGlobalKey =
      GlobalKey<TodoItemFieldState>();
  final GlobalKey<TodoItemFieldState> tagsGlobalKey =
      GlobalKey<TodoItemFieldState>();

  TodoItem(
      {super.key,
      required this.title,
      this.notes,
      required this.id,
      this.tags,
      required this.removeItem,
      required this.saveData});

  TodoItem.fromJsonObject(var object,
      {super.key, required this.removeItem, required this.saveData, required this.id}) {
    title = object['title'];
    notes = object['notes'] ?? "";
    tags = [];
    for (var tag in object['tags']) {
      tags?.add(tag);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "title": titleGlobalKey.currentState?.text,
      "notes": notesGlobalKey.currentState?.text,
      "tags": tagsGlobalKey.currentState?.tags
    };
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(160, 204, 252, 0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () {
                  titleGlobalKey.currentState?.startEditing();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TodoItemField(
                            key: titleGlobalKey,
                            text: title,
                            padding: const EdgeInsets.all(20),
                            style: const TextStyle(fontSize: 20),
                            saveData: saveData),
                        TodoItemField(
                            key: notesGlobalKey,
                            text: notes ?? "",
                            padding: const EdgeInsets.only(left: 20),
                            saveData: saveData),
                        TodoItemField(
                          key: tagsGlobalKey,
                          text: tags?.map((e) => '#$e').join(", ") ?? "",
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, bottom: 10),
                          saveData: saveData,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onTap: () {
                          removeItem(id);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
