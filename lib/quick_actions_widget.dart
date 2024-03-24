import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color:Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            textAlign: TextAlign.start,
            // style: Theme.of(context).textTheme.headlineMedium
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                children: [
                  QuickActionCard(
                    icon: Icons.file_copy,
                    title: 'Files',
                  ),
                  QuickActionCard(
                    icon: Icons.qr_code_scanner,
                    title: 'Scan',
                  ),
                  QuickActionCard(
                    icon: Icons.timeline,
                    title: 'Timeline',
                  ),
                  QuickActionCard(
                    icon: Icons.add,
                    title: 'Activity',
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).shadowColor,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
        ],
      ),
    );
  }
}
