import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/shared/constants.dart';

class GenericReadingTile extends StatelessWidget {
  final String reading;
  final String optionalValue;
  final DateTime time;
  final String comment;
  final MedicalReadingType readingType;

  const GenericReadingTile({
    super.key,
    required this.reading,
    required this.time,
    this.optionalValue = '',
    this.comment = '',
    required this.readingType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 70,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).highlightColor,
              offset: Offset(0, 0.5),
              blurRadius: 1,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          readingType.icon,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      readingType.formatReading(
                        // double.parse(reading).toInt().toString(),
                        // double.parse(optionalValue).toInt().toString(),
                        reading,
                        optionalValue,
                      ),
                      style: const TextStyle(
                        // overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Constants.primaryColor,
                      ),
                    ),
                    comment.isNotEmpty
                        ? Flexible(
                            child: Text(
                              comment,
                              // overflow: TextOverflow.ellipsis,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : const SizedBox(height: 0),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      // color: color,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: readingType.color,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      readingType.tag,
                      style: TextStyle(
                        fontSize: 10,
                        color: readingType.color,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.red,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    DateService.getFormattedTime(time),
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
