import 'package:flutter/material.dart';

class TimelineWidget extends StatefulWidget {
  const TimelineWidget({Key? key}) : super(key: key);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  final List<Map<String, String>> timelineItems = [
    {
      'title': 'Activity 1',
      'description': 'Description of Activity 1',
      'time': '1hr ago',
    },
    {
      'title': 'Activity 2',
      'description': 'Description of Activity 2',
      'time': '5hrs ago',
    },
    {
      'title': 'Activity 3',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus quis vestibulum est. Aenean molestie ipsum a molestie sagittis',
      'time': 'Yesterday',
    },
    {
      'title': 'Activity 4',
      'description': 'Description of Activity 4',
      'time': '2 days ago',
    },
    {
      'title': 'Activity 5',
      'description': 'Description of Activity 5',
      'time': '1 week ago',
    },
    {
      'title': 'Activity 6',
      'description': 'Description of Activity 6',
      'time': '2 weeks ago',
    },
    {
      'title': 'Activity 7',
      'description': 'Description of Activity 7',
      'time': '1 month ago',
    },
    {
      'title': 'Activity 8',
      'description': 'Description of Activity 8',
      'time': '3 months ago',
    },
    {
      'title': 'Activity 9',
      'description': 'Description of Activity 9',
      'time': '6 months ago',
    },
    {
      'title': 'Activity 10',
      'description': 'Description of Activity 10',
      'time': '1 year ago',
    },
  ];

  int visibleItems = 3; // Number of items to show initially
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Timeline'),
      ),
      body: isExpanded ? buildDetailedTimeline() : buildExpandableTimeline(),
    );
  }

  Widget buildDetailedTimeline() {
    return ListView.builder(
      itemCount: timelineItems.length + 1,
      itemBuilder: (context, index) {
        if (index == timelineItems.length) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                isExpanded = false;
              });
            },
            child: const Text('Contract Timeline'),
          );
        } else {
          return TimelineItemCard(item: timelineItems[index]);
        }
      },
    );
  }

  Widget buildExpandableTimeline() {
    return ListView.builder(
      itemCount: visibleItems + 1,
      itemBuilder: (context, index) {
        if (index == visibleItems) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                isExpanded = true;
              });
            },
            child: const Text('Expand Timeline'),
          );
        } else {
          return TimelineItemCard(item: timelineItems[index]);
        }
      },
    );
  }

  Widget buildExpandButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isExpanded = true;
          });
        },
        child: const Text('Expand Timeline'),
      ),
    );
  }
}

class TimelineItemCard extends StatelessWidget {
  final Map<String, String> item;

  const TimelineItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 12.0),
          // Circle indicating the event
          const Column(
            children: [
              SizedBox(height: 30.0),
              CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.blue,
              ),
            ],
          ),
          const SizedBox(width: 16.0), // Spacing between circle and text
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Time: ${item['time']}',
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 6.0, right: 6.0, bottom: 6.0, top: 0.0),
                    child: Text(
                      item['description']!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
