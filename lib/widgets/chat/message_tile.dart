import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSender;
  final String time;

  const MessageTile(
      {super.key,
      required this.message,
      this.isSender = true,
      required this.time});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.8,
          minHeight: 30,
          minWidth: 115,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSender
              ? (Theme.of(context).brightness == Brightness.dark)
                  ? Theme.of(context).primaryColor.withOpacity(0.7)
                  : Theme.of(context).primaryColor.withOpacity(0.8)
              : Constants.customGray,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isSender ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight:
                isSender ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 2, bottom: 10, right: 10),
              child: Text(
                message,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(
                time,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
