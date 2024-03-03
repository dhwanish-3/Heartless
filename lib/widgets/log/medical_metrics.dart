import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class MedicalMetrics extends StatelessWidget {
  const MedicalMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
            Text('  Medical Metrics',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium),
            const RowImages(
              imageUrl1: 'assets/Icons/heartRateCard.png',
              imageUrl2: 'assets/Icons/bpCard.png',
            ),
            const SizedBox(
              height: 10,
            ),
            const RowImages(
              imageUrl1: 'assets/Icons/weightCard.png',
              imageUrl2: 'assets/Icons/glucoseCard.png',
            )
          ],
        ));
  }
}

class RowImages extends StatelessWidget {
  final String imageUrl1;
  final String imageUrl2;
  const RowImages({
    super.key,
    required this.imageUrl1,
    required this.imageUrl2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Image.asset(
            imageUrl1,
            height: 150,
          ),
        ),
        Expanded(
          flex: 1,
          child: Image.asset(
            imageUrl2,
            height: 150,
          ),
        ),
      ],
    );
  }
}
