//* this file is obsolete, daywise_log page is the new file to be navigated to
import 'package:flutter/material.dart';
import 'package:heartless/pages/log/daywise_diary_page.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/log/diary_list.dart';
import 'package:heartless/widgets/log/medical_metrics.dart';
import 'package:provider/provider.dart';

//! This page is not being used
class MedicalLogPage extends StatelessWidget {
  final AppUser patient;
  const MedicalLogPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    //* setting the selected date to today without notifying the listeners (if notified, it will rebuild the whole widget tree & lead to error, which is not needed here)
    widgetNotifier.setSelectedDateWithoutNotifying(DateTime.now());

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Medical Log',
        style: Theme.of(context).textTheme.headlineMedium,
      )),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicalMetrics(
              patient: patient,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: width * 0.85,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).brightness == Brightness.light
                    ? Constants.cardColor
                    : Constants.darkCardColor,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DayWiseDiary(patient: patient)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text(
                        'My Diary',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ),
                    DiaryListBuilder(
                      patient: patient,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
