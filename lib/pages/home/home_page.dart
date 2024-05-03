import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:heartless/pages/analytics/analytics_page.dart';
import 'package:heartless/pages/chat/contacts_page.dart';
import 'package:heartless/pages/demo/demo_page.dart';
import 'package:heartless/pages/home/doctor_nurse_home_page.dart';
import 'package:heartless/pages/home/patient_home_page.dart';
import 'package:heartless/pages/log/daywise_log.dart';
import 'package:heartless/pages/profile/profile_page.dart';
import 'package:heartless/pages/profile/settings/settings_page.dart';
import 'package:heartless/pages/schedule/schedule_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    List<Widget> _patientScreens = <Widget>[
      PatientHomePage(
        user: authNotifier.appUser!,
      ),
      DayWiseLogPage(
        patient: authNotifier.appUser!,
      ),
      SchedulePage(
        patient: authNotifier.appUser!,
      ),
      AnalyticsPage(
        patientId: authNotifier.appUser!.uid,
      ),
      ProfilePage(),
    ];

    List<Widget> _doctorNurseScreens = <Widget>[
      DoctorNurseHomePage(),
      ContactsPage(),
      ProfilePage(),
      SettingsPage(),
      DemoPage(
        title: 'Demo',
        videoUrl:
            "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
      )
    ];
    const patientTabs = const [
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
        icon: Icons.bar_chart_outlined,
        text: 'Analytics',
      ),
      GButton(
        icon: Icons.person,
        text: 'Profile',
      ),
    ];

    const doctorNurseTabs = const [
      GButton(
        icon: Icons.home,
        text: 'Home',
      ),
      GButton(
        icon: Icons.chat,
        text: 'Chat',
      ),
      GButton(
        icon: Icons.person,
        text: 'Profile',
      ),
    ];

    return Consumer<WidgetNotifier>(
      builder: (context, WidgetNotifier widgetNotifier, child) {
        log(widgetNotifier.selectedIndex.toString());
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (widgetNotifier.selectedIndex != 0) {
              widgetNotifier.setSelectedIndex(0);
              return Future.value(false);
            } else {
              final val = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(25),
                      actionsPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      title: const Text('Alert'),
                      content: const Text('Do you want to Exit the App'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('No')),
                        ElevatedButton(
                            onPressed: () {
                              SystemNavigator.pop();
                              // Navigator.of(context).pop(true);
                            },
                            child: const Text('Yes'))
                      ],
                    );
                  });
              if (val != null) {
                return Future.value(val);
              } else {
                return Future.value(false);
              }
            }
          },
          child: Scaffold(
            body: authNotifier.appUser!.userType == UserType.patient
                ? _patientScreens[widgetNotifier.selectedIndex]
                : _doctorNurseScreens[widgetNotifier.selectedIndex],
            bottomNavigationBar: _buildGnav(
              context,
              authNotifier.appUser!.userType == UserType.patient
                  ? patientTabs
                  : doctorNurseTabs,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGnav(BuildContext context, List<GButton> tabs) {
    double fem = MediaQuery.of(context).size.width / 500;
    final WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(
        horizontal: tabs.length == 3 ? 60 : 0,
        vertical: 0,
      ),
      decoration: BoxDecoration(
        // color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(Radius.circular(40 * fem)),
      ),
      child: GNav(
        selectedIndex: widgetNotifier.selectedIndex,
        rippleColor: Theme.of(context).primaryColor.withOpacity(0.3),
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.5),
        haptic: true,
        tabBorderRadius: 20,
        curve: Curves.easeOutExpo,
        duration: const Duration(milliseconds: 300),
        gap: 0,
        color: Theme.of(context).shadowColor,
        activeColor: Theme.of(context).primaryColor,
        iconSize: 24,
        tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        padding: const EdgeInsets.all(16),
        onTabChange: (index) {
          widgetNotifier.setSelectedIndex(index);
        },
        tabs: tabs,
      ),
    );
  }
}
