import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  late final int id;
  late String title;
  late String? notes;
  late final List<String>? tags;
  final Function removeItem;

  TodoItem(
      {super.key,
      required this.title,
      this.notes,
      required this.id,
      this.tags,
      required this.removeItem});

  TodoItem.fromJsonObject(var object, {super.key, required this.removeItem}) {
    id = object['id'];
    title = object['title'];
    notes = object['notes'] ?? "";
    tags = [];
    for (var tag in object['tags']) {
      tags?.add(tag);
    }
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "notes": notes, "tags": tags};
  }

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  final List<String> tags = [];
  late final String title;
  late final String? notes;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    notes = widget.notes;
    tags.addAll(widget.tags ?? []);
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
              onTap: () {},
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(notes ?? ""),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: Text(tags.map((e) => '#$e').join(", ")),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      widget.removeItem(widget.id);
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
