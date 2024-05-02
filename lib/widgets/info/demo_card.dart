import 'package:flutter/material.dart';

class ScrollableDemoList extends StatelessWidget {
  final items;
  const ScrollableDemoList({
    super.key,
    required this.items,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return DemoCard(
            imageUrl: items[index]["image"] as String,
            title: items[index]["title"] as String,
          );
        },
      ),
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
