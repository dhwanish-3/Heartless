import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/widgets/miscellaneous/tag_tile.dart';

class TimeLinewidget extends StatelessWidget {
  final String title;
  final String description;
  final DateTime time;
  const TimeLinewidget({
    super.key,
    required this.title,
    this.description = '',
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                // height: 100,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateService.getRelativeTimeInWording(time),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          // color: Colors.black,
                          fontSize: 12,
                          height: 1.2,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'blood pressure is one of the most sought out diseases in the wordl',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        TagWidget(
                          tag: 'blood pressure',
                          tagColor: Colors.red,
                        ),
                        TagWidget(
                          tag: 'test report',
                          tagColor: Colors.blue,
                        ),
                        TagWidget(
                          tag: 'blood pressure',
                          tagColor: Colors.red,
                        ),
                        TagWidget(
                          tag: 'test report',
                          tagColor: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
