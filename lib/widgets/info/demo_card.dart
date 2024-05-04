import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/demonstration_controller.dart';
import 'package:heartless/pages/demo/demo_page.dart';
import 'package:heartless/pages/profile/settings/static_data.dart';
import 'package:heartless/shared/models/demonstration.dart';

class ScrollableDemoList extends StatefulWidget {
  const ScrollableDemoList({
    Key? key,
    required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  _ScrollableDemoListState createState() => _ScrollableDemoListState();
}

class _ScrollableDemoListState extends State<ScrollableDemoList> {
  late Timer _timer;
  int _currentPage = 0;
  List<Demonstration> items = StaticData.previewList;

  @override
  void initState() {
    super.initState();
    bool forwardScroll = true;
    //todo logic to implement forward and backward scrolling
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < items.length) {
        widget._pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
        _currentPage++;
      } else {
        _currentPage = 0;
        widget._pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DemonstrationController().getDemos(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data.docs.isNotEmpty) {
          return SizedBox(
            height: 180,
            child: PageView.builder(
              controller: widget._pageController,
              itemCount: items.length,
              itemBuilder: (context, index) {
                Demonstration demo =
                    Demonstration.fromMap(snapshot.data.docs[index].data());
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DemoPage(demonstration: demo),
                      ),
                    );
                  },
                  child: DemoCard(imageUrl: demo.imageUrl!, title: demo.title),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("No Demos Yet"),
          );
        }
      },
    );
  }
}

class DemoCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const DemoCard({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: 160,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(
                imageUrl,
              ),
              fit: BoxFit.cover,
              opacity: 1,
            )),
        child: Stack(children: [
          Positioned(
              top: 20,
              left: 20,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ))
        ]));
  }
}
