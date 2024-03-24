import 'package:flutter/material.dart';
import 'package:heartless/quick_actions_widget.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/widgets/home/activity_schedule.dart';
import 'package:heartless/widgets/home/heading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HomePageHeadingWidget(),
              QuickActionsWidget(),
              const SizedBox(height: 20),
              ActivitiesSchedule(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).shadowColor,
        elevation: 20,
        selectedFontSize: 12,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Log',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar_rounded),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Container ActivitiesSchedule(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(10),
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
        vertical: 20,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              'Your Activites',
              textAlign: TextAlign.start,
              // style: Theme.of(context).textTheme.headlineMedium
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ActivityScheduleEntry(
                title: 'Morning Walk',
                time: '9:00 AM',
                comment: 'Walk for 30 minutes',
                status: ActivityStatus.completed,
                type: ActivityType.exercise,
              ),
              ActivityScheduleEntry(
                title: 'Green Pea Stew',
                time: '2:00 PM',
                comment: 'Have at least 2 bowls. It is good for you.',
                status: ActivityStatus.missed,
                type: ActivityType.diet,
              ),
              ActivityScheduleEntry(
                title: 'Evening Walk',
                time: '6:00 PM',
                comment: 'Walk for 30 minutes',
                status: ActivityStatus.upcoming,
                type: ActivityType.medicine,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
