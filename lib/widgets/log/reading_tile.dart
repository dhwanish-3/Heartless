import 'package:flutter/material.dart';
import 'package:heartless/services/enums/medical_reading_type.dart';
import 'package:heartless/shared/constants.dart';

class GenericReadingTile extends StatelessWidget {
  final String reading;
  final String time;
  final String comment;
  final MedicalReadingType readingType;

  const GenericReadingTile({
    super.key,
    required this.reading,
    required this.time,
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
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 4),
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
                  // const SizedBox(height: 5),
                ],
              ),
            ),
            // const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reading,
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
                                fontSize: 12,
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          fontSize: 8,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: Colors.red,
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      time,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
