import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:heartless/pages/auth/dummy_home.dart';
import 'package:heartless/pages/home/patient_home_page.dart';
import 'package:heartless/pages/log/daywise_log.dart';
import 'package:heartless/pages/schedule/schedule_page.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/analytics/graphs_widget.dart';
import 'package:provider/provider.dart';

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
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    return Scaffold(
      body: [
        PatientHomePage(),
        DayWiseLogPage(
          patient: authNotifier.appUser!,
        ),
        SchedulePage(
          patient: authNotifier.appUser!,
        ),
        GraphsWidget(
          patientId: authNotifier.appUser!.uid,
        ),
        DummyHome(),
      ][_selectedIndex],
      bottomNavigationBar: _buildGnav(context),
    );
  }

  Widget _buildGnav(BuildContext context) {
    double fem = MediaQuery.of(context).size.width / 500;
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40 * fem))),
      child: GNav(
          rippleColor: Constants.primaryColor.withOpacity(0.3),
          hoverColor: Constants.primaryColor.withOpacity(0.5),
          haptic: true,
          tabBorderRadius: 20,
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 300),
          gap: 0,
          color: Colors.black,
          activeColor: Constants.primaryColor,
          iconSize: 24,
          tabBackgroundColor: Constants.primaryColor.withOpacity(0.1),
          padding: const EdgeInsets.all(16),
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.list_alt_rounded,
              text: 'Log',
            ),
            GButton(
              icon: Icons.edit_calendar_rounded,
              text: 'Schedule',
            ),
            GButton(
              icon: Icons.auto_graph_rounded,
              text: 'Analytics',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ]),
    );
  }
}
