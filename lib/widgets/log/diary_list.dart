import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/log/cutom_rect.dart';
import 'package:heartless/widgets/log/diary_model.dart';
import 'package:heartless/widgets/log/hero_dialog.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class DiaryList extends StatefulWidget {
  const DiaryList({super.key});

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    showPopUpDelete(Diary diary) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(25),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              title: const Text('Delete'),
              content: const Text('Do you want to Delete this note/diary'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                ElevatedButton(
                    onPressed: () {
                      widgetNotifier.deleteDiary(diary);
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'))
              ],
            );
          });
    }

    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      // log(vajbkhvjhv.toString());
      List<Diary> vajbkhvjhv = [
        Diary('title', 'body this is the one', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'it was a nice day today', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'food was okay. Sleep got disturbed', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
        Diary('title', 'body', DateTime.now()),
      ];
      double calculateHeight(int length) {
        if (length % 2 == 0) {
          return (length / 2) * 200;
        } else {
          return ((length + 1) / 2) * 200;
        }
      }

      return SizedBox(
        height: calculateHeight(vajbkhvjhv.length),
        child: MasonryGridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          // physics: const PageScrollPhysics(),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: vajbkhvjhv.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final diary = vajbkhvjhv[index];
            return GestureDetector(
              onDoubleTap: () {
                showPopUpDelete(diary);
                debugPrint(widgetNotifier.diaryList.toString());
              },
              onTap: () {
                Navigator.of(context).push(
                  HeroDialogRoute(
                    builder: (context) => Center(
                      child: DiaryPopCard(
                        index: index,
                      ),
                    ),
                  ),
                );
              },
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Hero(
                    createRectTween: (begin, end) {
                      return CustomRectTween(
                          begin: begin as Rect, end: end as Rect);
                    },
                    tag: diary.title + diary.dateCreated.toString(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4, bottom: 5, top: 5),
                      child: Material(
                        elevation: 1,
                        // color: const Color.fromARGB(255, 133, 215, 204),
                        color: Constants.lightPrimaryColor,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20, top: 10, right: 20, left: 20),
                          child: Column(
                            children: [
                              Text(
                                diary.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                diary.dateCreated.toString().substring(0, 10),
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                              const Divider(
                                thickness: 0.5,
                              ),
                              Text(diary.body)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}

class DiaryPopCard extends StatelessWidget {
  final int index;
  DiaryPopCard({super.key, required this.index});
  final _diaryController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    _diaryController.text = widgetNotifier.diaryList![index].body != ''
        ? widgetNotifier.diaryList![index].body
        : _diaryController.text;
    _titleController.text = widgetNotifier.diaryList![index].title != ''
        ? widgetNotifier.diaryList![index].title
        : _titleController.text;

    return Hero(
      tag: widgetNotifier.diaryList![index].title +
          widgetNotifier.diaryList![index].dateCreated.toString(),
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin as Rect, end: end as Rect);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Material(
          borderRadius: BorderRadius.circular(32),
          color: const Color.fromARGB(255, 75, 255, 198),
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
                  Text(widgetNotifier.diaryList![index].dateCreated
                      .toString()
                      .substring(0, 10)),
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
                      controller: _diaryController,
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
                      onPressed: () {
                        debugPrint(widgetNotifier.diaryList![index].toString());

                        Diary newDiary = Diary(_titleController.text,
                            _diaryController.text, DateTime.now());

                        widgetNotifier.updateDiary(newDiary, index);

                        debugPrint(newDiary.toString());
                        Navigator.pop(context);
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
