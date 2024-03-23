import 'package:flutter/material.dart';
import 'package:heartless/pages/log/daywise_log.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';

class MedicalMetrics extends StatelessWidget {
  final AppUser patient;
  const MedicalMetrics({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        // height: height * 0.3,
        width: width * 0.85,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Constants.cardColor
              : Constants.darkCardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '  Medical Metrics',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 320,
              child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DayWiseLogPage(
                                      patient: patient,
                                    )));
                      },
                      child: Image.asset(
                        'assets/Icons/heartRateCard.png',
                        height: 150,
                      ),
                    ),
                    Image.asset(
                      'assets/Icons/bpCard.png',
                      height: 150,
                    ),
                    Image.asset(
                      'assets/Icons/weightCard.png',
                      height: 150,
                    ),
                    Image.asset(
                      'assets/Icons/glucoseCard.png',
                      height: 150,
                    ),
                  ]),
            ),
          ],
        ));
  }
}
