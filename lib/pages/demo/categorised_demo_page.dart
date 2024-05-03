import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/demonstration_controller.dart';
import 'package:heartless/pages/demo/demo_page.dart';
import 'package:heartless/shared/models/demonstration.dart';
import 'package:heartless/widgets/info/demo_card.dart';

class CategorisedDemoListPage extends StatelessWidget {
  const CategorisedDemoListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Video Demonstrations')),
        body: SafeArea(
            child: StreamBuilder(
                stream: DemonstrationController().getDemos(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data.docs.isNotEmpty) {
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          Demonstration demo = Demonstration.fromMap(
                              snapshot.data.docs[index].data());
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DemoPage(demonstration: demo),
                                ),
                              );
                            },
                            child: DemoCard(
                                imageUrl: demo.imageUrl!, title: demo.title),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("No Demos Yet"),
                    );
                  }
                })));
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
                  category,
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
                      imageUrl: item.imageUrl!,
                    ),
                  ),
              ],
            ),
          ],
        ));
  }
}
