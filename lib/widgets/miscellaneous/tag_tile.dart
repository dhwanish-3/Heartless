import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String tag;
  final Color tagColor;
  const TagWidget({
    super.key,
    required this.tag,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: tagColor,
            width: 0.6,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 8,
            color: tagColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
