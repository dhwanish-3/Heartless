import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/widgets/log/add_button.dart';
import 'package:heartless/widgets/log/cutom_rect.dart';
import 'package:heartless/widgets/log/diary_list.dart';
import 'package:heartless/shared/models/diary_model.dart';
import 'package:heartless/widgets/log/hero_dialog.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

const String _heroAddTodo = 'add-todo-hero';

class DiaryMain extends StatefulWidget {
  const DiaryMain({super.key});

  @override
  State<DiaryMain> createState() => _DiaryMainState();
}

class _DiaryMainState extends State<DiaryMain> {
  List<Diary> diaryList = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         Color.fromARGB(255, 8, 123, 255),
        //         Color.fromARGB(158, 0, 119, 255),
        //         Color.fromARGB(161, 121, 206, 255),
        //       ],
        //       stops: [0, 0, 1],
        //     ),
        //   ),
        // ),
        Column(
          children: [
            // SizedBox(
            //   height: 56,
            //   child: TextButton(
            //     onPressed: () {},
            //     child: const Text(
            //       'Your Diary',
            //       style: TextStyle(
            //           fontSize: 20,
            //           color: Color.fromARGB(255, 255, 255, 255),
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            Consumer<WidgetNotifier>(
              builder: (context, value, child) {
                return const Expanded(child: DiaryList());
              },
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context)
                    .push(HeroDialogRoute(builder: (context) {
                  return AddDiaryPopCard();
                }));
              },
              child: Hero(
                tag: _heroAddTodo,
                createRectTween: (begin, end) {
                  return CustomRectTween(
                      begin: begin as Rect, end: end as Rect);
                },
                child: Align(
                  alignment: const Alignment(1.1, 1.05),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Colors.transparent,
                    elevation: 10,
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 77, 250, 204),
                            Color.fromARGB(255, 71, 200, 255),
                            Color.fromARGB(255, 30, 255, 150),
                          ],
                          stops: [0, 0, 1],
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 56,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
    // );
  }
}
