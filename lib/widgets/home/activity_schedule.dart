import 'package:flutter/material.dart';
import 'package:heartless/services/enums/activity_status.dart';
import 'package:heartless/services/enums/activity_type.dart';
import 'package:heartless/widgets/miscellaneous/tag_tile.dart';

class ActivityScheduleEntry extends StatelessWidget {
  final String title;
  final String time;
  final String comment;
  final ActivityStatus status;
  final ActivityType type;

  const ActivityScheduleEntry({
    super.key,
    this.title = 'Morning Walk',
    this.comment = '',
    this.time = '9:00 AM',
    this.status = ActivityStatus.upcoming,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
            // horizontal: 20,

            ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14, height: 1.2, fontWeight: FontWeight.w500),
              ),
              Container(
                // height: 100,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        image: status.completionStatusIcon == null
                            ? null
                            : DecorationImage(
                                image: AssetImage(status.completionStatusIcon!),
                                fit: BoxFit.cover,
                              ),
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                    title.isNotEmpty
                        ? Text(
                            title,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox(), //title
                    const SizedBox(height: 5),
                    comment.isNotEmpty
                        ? Text(
                            comment,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.2,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          )
                        : const SizedBox(), //title
//! optionally displayed if tags are present

                    const SizedBox(height: 5),

                    TagWidget(
                      tag: type.value,
                      tagColor: type.color,
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
