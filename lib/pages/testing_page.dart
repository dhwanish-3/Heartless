import 'package:flutter/material.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/widgets/log/reading_tile2.dart';

class TestingPage extends StatefulWidget {
  const TestingPage({super.key});

  @override
  State<TestingPage> createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenericReadingTile(
              reading: '120 bpm',
              time: '9:00 AM',
              comment: 'Normal',
              readingType: MedicalReadingType.heartRate,
            ),
            GenericReadingTile(
              reading: '120 bpm',
              time: '9:00 AM',
              comment: 'It was just a normal day with a normal reading',
              readingType: MedicalReadingType.glucose,
            ),
            GenericReadingTile(
              reading: '120 bpm',
              time: '9:00 AM',
              readingType: MedicalReadingType.weight,
              comment:
                  'this is a long comment I wish this would extend beyond three four lines. That is what I wish to happen, but I am not sure that woudl happpen now that it has gone beyond several lines',
            ),
            GenericReadingTile(
              reading: '120 bpm 140 bpm 160 bpm',
              time: '9:00 AM',
              comment: 'this is not normale not that I can think of ',
              readingType: MedicalReadingType.other,
            ),
            GenericReadingTile(
              reading: '120 bpm 140 bpm',
              time: '9:00 AM',
              comment: 'this is not normale not that I can think of ',
              readingType: MedicalReadingType.bloodPressure,
            ),
          ],
        ),
      ),
    );
  }
}
