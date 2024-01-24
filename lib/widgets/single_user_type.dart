import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class SingleUserType extends StatelessWidget {
  final int type;
  final bool isSelected;
  const SingleUserType(
      {super.key, required this.type, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double containerWidth = isSelected ? width * 0.7 : width * 0.6;
    double imageHeight = isSelected ? 100 : 80;
    double fontSize = isSelected ? 30 : 26;
    final String imageUrl = type == 1
        ? 'assets/Icons/patient.png'
        : type == 2
            ? 'assets/Icons/nurse.png'
            : type == 3
                ? 'assets/Icons/doctor.png'
                : 'assets/Icons/doctor.png';

    final String value = type == 1
        ? 'PATIENT'
        : type == 2
            ? 'NURSE'
            : type == 3
                ? 'DOCTOR'
                : 'DOCTOR';

    return Container(
        width: containerWidth,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Constants.primaryColor, width: 2)
              : Border.all(color: Colors.black, width: 1),
          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          type != 1
              ? Expanded(
                  flex: 1,
                  child: Container(
                    height: imageHeight,
                    width: imageHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ))
              : const SizedBox(height: 0, width: 0),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).shadowColor,
              ),
            ),
          ),
          type == 1
              ? Expanded(
                  flex: 1,
                  child: Container(
                    height: imageHeight,
                    width: imageHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ))
              : const SizedBox(height: 0, width: 0),
        ]));
  }
}
