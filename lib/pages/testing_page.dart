import 'dart:developer';

import 'package:flutter/material.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 300,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class ScrollWidget extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              if (_pageController.hasClients && _pageController.page! > 0) {
                _pageController.animateToPage(
                  (_pageController.page! - 1).toInt(),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue,
                  child: Center(
                    child: Text('Item $index',
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              if (_pageController.hasClients && _pageController.page! < 9) {
                _pageController.animateToPage(
                  (_pageController.page! + 1).toInt(),
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class MonthSelector extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: 10,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              log('Item $index', name: 'MonthSelector');
            },
            child: Container(
              width: 100,
              height: 30,
              margin: EdgeInsets.all(5.0),
              child: Center(
                  child: Text('Item $index',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ))),
            ),
          );
        },
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            //clicked postion -80
            details.globalPosition.dx - 80,
            200,
            details.globalPosition.dx + 80,
            20,
          ),
          items: [
            PopupMenuItem(
              child: MonthSelector(),
            ),
          ],
        );
      },
      child: Container(
        color: Colors.red,
        height: 50,
        width: 50,
      ),
    );
    ;
  }
}
