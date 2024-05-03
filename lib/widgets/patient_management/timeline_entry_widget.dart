import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/timeline_event_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/widgets/miscellaneous/tag_tile.dart';

class TimeLineEntryWidget extends StatelessWidget {
  final AppUser patient;
  final String title;
  final DateTime time;
  final TimeLineEventType tag;
  const TimeLineEntryWidget({
    super.key,
    required this.patient,
    this.title = '',
    required this.time,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => tag.route(patient))),
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
                      height: 20,
                      width: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      width: 14.0,
                      height: 14.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).shadowColor,
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
                    title.isNotEmpty
                        ? Text(
                            title,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox(), //title
                    title.isNotEmpty
                        ? const SizedBox(height: 5)
                        : const SizedBox(),
//! optionally displayed if tags are present
                    Wrap(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        TagWidget(
                          tag: tag.tag,
                          tagColor: tag.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
