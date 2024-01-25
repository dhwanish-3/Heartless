import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class MessageField extends StatelessWidget {
  const MessageField({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
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
          controller: messageController,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(
            hintText: "Send a message...",
            hintStyle: TextStyle(color: Colors.white, fontSize: 16),
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ));
  }
}
