import 'package:flutter/material.dart';

class TodoItem extends StatelessWidget {
  late String title;
  String? notes;
  final List<String> tags = [];

  TodoItem({super.key, required this.title, this.notes, List<String>? tags}) {
    this.tags.addAll(tags ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(160,204,252, 0.6),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text(notes ?? ""),
                    Text(tags.map((e) => '#$e').join(", "))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
