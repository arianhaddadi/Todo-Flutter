import 'package:flutter/material.dart';
import 'package:todo/tasks/task_info.dart';
import 'package:provider/provider.dart';
import 'package:todo/tasks/tasks_repo.dart';

class Task extends StatefulWidget {
  late final int id;
  late final String title;
  late final String? notes;
  late final List<String>? tags;
  final bool beginWithEditingState;
  final GlobalKey<TaskInfoState> _titleGlobalKey = GlobalKey<TaskInfoState>();
  final GlobalKey<TaskInfoState> _notesGlobalKey = GlobalKey<TaskInfoState>();
  final GlobalKey<TaskInfoState> _tagsGlobalKey = GlobalKey<TaskInfoState>();

  Task(
      {super.key,
      this.notes,
      this.tags,
      this.beginWithEditingState = false,
      required this.title,
      required this.id});

  Task.fromJsonObject(var object,
      {super.key, this.beginWithEditingState = false, required this.id}) {
    title = object['title'];
    notes = object['notes'] ?? "";
    tags = [];
    for (var tag in object['tags']) {
      tags?.add(tag);
    }
  }

  List<String> _convertTagsStringToList(String tagsString) {
    if (tagsString.isEmpty) return [];
    return tagsString
        .split(",")
        .map((e) {
          e = e.trim();
          int hashtagIndex = e.indexOf("#");
          int startIndex = hashtagIndex == -1 ? 0 : hashtagIndex + 1;
          return e.substring(startIndex).trim();
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "title": _titleGlobalKey.currentState?.text,
      "notes": _notesGlobalKey.currentState?.text,
      "tags": _convertTagsStringToList(_tagsGlobalKey.currentState?.text ?? "")
    };
  }

  @override
  State<StatefulWidget> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  var _isDeleting = false;
  var _isEditing = false;

  final configs = {
    "animation_duration": 1
  };

  @override
  void initState() {
    super.initState();
    _isEditing = widget.beginWithEditingState;
  }

  void _startEditing() {
    if (_isEditing) return;
    setState(() {
      _isEditing = true;
      widget._titleGlobalKey.currentState?.startEditing();
      widget._notesGlobalKey.currentState?.startEditing();
      widget._tagsGlobalKey.currentState?.startEditing();
    });
  }

  void _finishEditing() {
    setState(() {
      _isEditing = false;
      widget._titleGlobalKey.currentState?.finishEditing();
      widget._notesGlobalKey.currentState?.finishEditing();
      widget._tagsGlobalKey.currentState?.finishEditing();
      context.read<TasksRepo>().saveData();
    });
  }

  Widget _renderItemFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaskInfo(
          key: widget._titleGlobalKey,
          text: widget.title,
          defaultText: "New Task",
          isRequired: true,
          beginWithEditingState: widget.beginWithEditingState,
          padding: const EdgeInsets.all(20),
          style: const TextStyle(fontSize: 20),
          parentFinishEditing: _finishEditing,
        ),
        TaskInfo(
          key: widget._notesGlobalKey,
          text: widget.notes ?? "",
          defaultText: "notes",
          beginWithEditingState: widget.beginWithEditingState,
          padding: const EdgeInsets.only(left: 20),
          parentFinishEditing: _finishEditing,
        ),
        TaskInfo(
          key: widget._tagsGlobalKey,
          text: widget.tags?.map((e) => '#$e').join(", ") ?? "",
          defaultText: "Tags",
          beginWithEditingState: widget.beginWithEditingState,
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
          parentFinishEditing: _finishEditing,
        )
      ],
    );
  }

  Widget _getActionButtonGestureDetector() {
    if (_isEditing) {
      return GestureDetector(
        onTap: () {
          _finishEditing();
        },
        child: const Icon(Icons.check),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isDeleting = true;
          });
          Future.delayed(Duration(seconds: configs["animation_duration"] ?? 1), () {
            context.read<TasksRepo>().removeItem(widget.id);
          });
        },
        child: const Icon(Icons.delete),
      );
    }
  }

  Widget _renderActionButton() {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: _getActionButtonGestureDetector());
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: orientation == Orientation.portrait
          ? screenSize.height * 0.2
          : screenSize.width * 0.2,
      child: Stack(children: [
        AnimatedPositioned(
            right: _isDeleting ? -screenSize.width : 0,
            left: _isDeleting ? screenSize.width : 0,
            top: 0,
            duration: Duration(seconds: configs["animation_duration"] ?? 1),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.only(
                top: screenSize.height * 0.02,
                left: screenSize.width * 0.05,
                right: screenSize.width * 0.05,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        _startEditing();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [_renderItemFields(), _renderActionButton()],
                      )),
                ),
              ),
            ))
      ]),
    );
  }
}
