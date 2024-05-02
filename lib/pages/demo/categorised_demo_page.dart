import 'package:flutter/material.dart';
import 'package:heartless/widgets/info/demo_card.dart';

class CategorisedDemoListPage extends StatelessWidget {
  const CategorisedDemoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Video Demonstrations')),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              DemoCategory(),
              DemoCategory(),
            ],
          ),
        )));
  }
}

class DemoCategory extends StatelessWidget {
  const DemoCategory({super.key});

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
                DemoCard(
                  imageUrl: "assets/illustrations/plank.jpeg",
                  title: "Planking",
                ),
                DemoCard(
                  imageUrl: "assets/illustrations/breathing.jpeg",
                  title: "Breathing",
                ),
              ],
            ),
          ],
        ));
  }
}
