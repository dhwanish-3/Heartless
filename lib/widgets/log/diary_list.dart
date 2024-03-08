import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heartless/backend/controllers/diary_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/widgets/log/cutom_rect.dart';
import 'package:heartless/shared/models/diary.dart';
import 'package:heartless/widgets/log/diary_popup_card.dart';
import 'package:heartless/widgets/log/hero_dialog.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class DiaryListBuilder extends StatefulWidget {
  final AppUser patient;
  const DiaryListBuilder({super.key, required this.patient});

  @override
  State<DiaryListBuilder> createState() => _DiaryListState();
}

class _DiaryListState extends State<DiaryListBuilder> {
  final DiaryController _diaryController = DiaryController();

  double calculateHeight(int length) {
    if (length % 2 == 0) {
      return (length / 2) * 200;
    } else {
      return ((length + 1) / 2) * 200;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    // function to delete diary
    Future<void> deleteDiary(Diary diary) async {
      await _diaryController.deleteDiary(diary);
    }

    // popup to confirm to deleting a diary
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
                    onPressed: () async {
                      await deleteDiary(diary);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Yes'))
              ],
            );
          });
    }

    return Consumer<WidgetNotifier>(builder: (context, value, child) {
      return StreamBuilder(
          stream: DiaryController.getAllDiarysOfTheDate(
              widgetNotifier.selectedDate, widget.patient.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
              return SizedBox(
                height: calculateHeight(snapshot.data.docs.length),
                child: MasonryGridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  // physics: const PageScrollPhysics(),
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data.docs.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    Diary diary =
                        Diary.fromMap(snapshot.data.docs[index].data());
                    return GestureDetector(
                      onDoubleTap: () {
                        showPopUpDelete(diary);
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          HeroDialogRoute(
                            builder: (context) => Center(
                              child: DiaryPopUpCard(
                                diary: diary,
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
            } else {
              return const Center(
                child: Text("No diaries yet"),
              );
            }
          });
    });
  }
}
