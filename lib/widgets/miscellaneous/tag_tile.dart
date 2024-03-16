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
          color: tagColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 8,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
