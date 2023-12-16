import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  late int id;
  late String title;
  String? notes;
  final List<String> tags = [];

  TodoItem({super.key, required this.title, this.notes, required this.id, List<String>? tags}) {
    this.tags.addAll(tags ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "notes": notes,
      "tags": tags
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
              onTap: () {},
              child: Column(
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
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Text(tags.map((e) => '#$e').join(", ")),
                  ),
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
