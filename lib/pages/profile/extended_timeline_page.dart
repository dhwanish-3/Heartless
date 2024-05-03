import 'package:flutter/material.dart';
import 'package:heartless/services/enums/schedule_toggle_type.dart';
import 'package:heartless/services/enums/timeline_event_type.dart';
import 'package:heartless/services/utils/timeline_service.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:heartless/widgets/patient_management/timeline_entry_widget.dart';
import 'package:heartless/widgets/schedule/multi_toggle_panel.dart';
import 'package:provider/provider.dart';

class ExtendedTimelinePage extends StatefulWidget {
  final AppUser patient;
  const ExtendedTimelinePage({
    super.key,
    required this.patient,
  });

  @override
  State<ExtendedTimelinePage> createState() => _ExtendedTimelinePageState();
}

class _ExtendedTimelinePageState extends State<ExtendedTimelinePage> {
  TimeLineEventType? selectedTag;
  static TimeLineEventType? getTimeLineEventType(
      ScheduleToggleType toggleType) {
    Map<ScheduleToggleType, TimeLineEventType?> scheduleToggleTypeMap = {
      ScheduleToggleType.all: null,
      ScheduleToggleType.medicine: TimeLineEventType.activity,
      ScheduleToggleType.diet: TimeLineEventType.reading,
      ScheduleToggleType.drill: TimeLineEventType.healthDocument,
    };

    return scheduleToggleTypeMap[toggleType];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBar(
                title: const Text('Extended Timeline'),
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              MutltiToggle(
                isTimeLine: true,
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
              future: TimeLineService.getTimeLine(widget.patient.uid, null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Consumer<WidgetNotifier>(
                    builder: (context, widgetNotifier, child) {
                      selectedTag = getTimeLineEventType(
                          widgetNotifier.scheduleToggleType);
                      return Column(
                        children: snapshot.data!
                            .where((e) =>
                                selectedTag == null || e.tag == selectedTag)
                            .map((e) => TimeLineEntryWidget(
                                patient: widget.patient,
                                title: e.title,
                                time: e.date,
                                tag: e.tag))
                            .toList(),
                      );
                    },
                  );
                } else {
                  return Text("Failed");
                }
              }),
        ),
      )),
    );
  }
}
