import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/log/cutom_rect.dart';
import 'package:heartless/shared/models/diary.dart';
import 'package:heartless/widgets/log/hero_dialog.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class DiaryList extends StatefulWidget {
  const DiaryList({super.key});

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryList> {
  List<Diary> diaryList = [];
  @override
  Widget build(BuildContext context) {
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
                ElevatedButton(onPressed: () {}, child: const Text('Yes'))
              ],
            );
          });
    }

    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      List<Diary> diaryList = [
        Diary(
            title: 'title',
            body: 'body this is the one',
            time: DateTime.now(),
            patientId: ''),
        Diary(
            title: 'title', body: 'body', time: DateTime.now(), patientId: ''),
        Diary(
            title: 'title',
            body: 'it wasdateCreated: a nice day today',
            time: DateTime.now(),
            patientId: ''),
        Diary(
            title: 'title', body: 'body', time: DateTime.now(), patientId: ''),
        Diary(
            title: 'title',
            body: 'food wdateCreated:as okay. Sleep got disturbed',
            time: DateTime.now(),
            patientId: ''),
      ];
      double calculateHeight(int length) {
        if (length % 2 == 0) {
          return (length / 2) * 200;
        } else {
          return ((length + 1) / 2) * 200;
        }
      }

      return SizedBox(
        height: calculateHeight(diaryList.length),
        child: MasonryGridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          // physics: const PageScrollPhysics(),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: diaryList.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) {
            final diary = diaryList[index];
            return GestureDetector(
              onDoubleTap: () {
                showPopUpDelete(diary);
              },
              onTap: () {
                Navigator.of(context).push(
                  HeroDialogRoute(
                    builder: (context) => Center(
                      child: DiaryPopCard(
                        index: index,
                        diaryList: diaryList,
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
                    tag: diary.title + diary.time.toString(),
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
                                diary.time.toString().substring(0, 10),
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
  final List<Diary> diaryList;
  final int index;
  DiaryPopCard({super.key, required this.index, required this.diaryList});
  final _diaryController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: diaryList[index].title + diaryList[index].time.toString(),
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
                  Text(diaryList[index].time.toString().substring(0, 10)),
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
                      onPressed: () {},
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
