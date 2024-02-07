import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class MessageField extends StatefulWidget {
  final TextEditingController messageController;
  final void Function() sendMessage;
  const MessageField(
      {super.key, required this.messageController, required this.sendMessage});

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth,
        constraints: BoxConstraints(
          minHeight: screenHeight * 0.07,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Constants.customGray,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          maxLines: null,
          controller: widget.messageController,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: "Send a message...",
            hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              onTap: widget.sendMessage,
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
