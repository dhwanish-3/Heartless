import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/analytics/graphs_widget.dart';
import 'package:intl/intl.dart';

class PanelWidget extends StatefulWidget {
  final String patientId;
  final String title;

  const PanelWidget({super.key, required this.title, required this.patientId});

  @override
  State<PanelWidget> createState() => _PanelState();
}

class _PanelState extends State<PanelWidget> {
  final String month = DateFormat('MMMM').format(DateTime.now());
  final int year = DateTime.now().year;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        // backgroundColor: Colors.transparent,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: GraphsWidget(
        patientId: widget.patientId,
      ),
    );
  }
}
