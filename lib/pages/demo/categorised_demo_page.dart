import 'package:flutter/material.dart';
import 'package:heartless/pages/demo/demo_page.dart';
import 'package:heartless/shared/models/demonstration.dart';
import 'package:heartless/widgets/info/demo_card.dart';

class CategorisedDemoListPage extends StatelessWidget {
  final List<Demonstration> items;

  const CategorisedDemoListPage({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Video Demonstrations')),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              DemoCategory(
                items: items,
              ),
              DemoCategory(
                items: items,
              ),
            ],
          ),
        )));
  }
}

class DemoCategory extends StatelessWidget {
  final String category;
  final List<Demonstration> items;
  const DemoCategory({
    super.key,
    this.category = 'Breathing Exercise',
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  'Breathing Exercise',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                for (var item in items)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DemoPage(demonstration: item),
                        ),
                      );
                    },
                    child: DemoCard(
                      title: item.title,
                      imageUrl: item.imageUrl,
                    ),
                  ),
              ],
            ),
          ],
        ));
  }
}
