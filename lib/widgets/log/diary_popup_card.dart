import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/diary_controller.dart';
import 'package:heartless/shared/models/diary.dart';
import 'package:heartless/widgets/log/cutom_rect.dart';

class DiaryPopUpCard extends StatelessWidget {
  final Diary diary;
  DiaryPopUpCard({super.key, required this.diary});
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  // edit diary submission
  Future<void> _editDiaryFormSubmit() async {
    // updating diary properties
    diary.title = _titleController.text;
    diary.body = _bodyController.text;
    diary.time = DateTime.now();
    await DiaryController().editDiary(diary);
  }

  @override
  Widget build(BuildContext context) {
    _bodyController.text = diary.body;
    _titleController.text = diary.title;
    return Hero(
      tag: diary.title + diary.time.toString(),
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin as Rect, end: end as Rect);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Material(
          borderRadius: BorderRadius.circular(32),
          color: const Color.fromARGB(255, 126, 208, 255),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                    controller: _titleController,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'Title',
                        border: InputBorder.none),
                  ),
                  Text(diary.time.toString().substring(0, 10)),
                  Container(
                    constraints: const BoxConstraints(
                        maxHeight: 500,
                        minHeight: 100,
                        maxWidth: 300,
                        minWidth: 100),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: _bodyController,
                      maxLines: 8,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'Write a diary...',
                          border: InputBorder.none),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: TextButton(
                      onPressed: () async {
                        await _editDiaryFormSubmit();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        height: 35,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue)),
                        child: const Center(
                          child: Text(
                            'Done',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
