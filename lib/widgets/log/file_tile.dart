import 'package:flutter/material.dart';
import 'package:heartless/services/enums/custom_file_type.dart';
import 'package:heartless/services/enums/event_tag.dart';
import 'package:heartless/widgets/miscellaneous/tag_tile.dart';

class FileTile extends StatelessWidget {
  final String title;
  final String dateString;
  final CustomFileType fileType;
  final List<EventTag> tags;
  const FileTile({
    super.key,
    required this.title,
    required this.dateString,
    required this.fileType,
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).secondaryHeaderColor,
        margin: const EdgeInsets.symmetric(),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        child: Row(
          children: [
            Image.asset(
              fileType.imageUrl,
              height: 50,
              width: 50,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    dateString,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        // color: Colors.black,
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      for (EventTag tag in tags)
                        TagWidget(
                          tag: tag.value,
                          tagColor: tag.tagColor,
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class TagTile {}
