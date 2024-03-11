import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:image_picker/image_picker.dart';

class MessageField extends StatefulWidget {
  final TextEditingController messageController;
  final void Function({File? file}) sendMessage;
  const MessageField(
      {super.key, required this.messageController, required this.sendMessage});

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenWidth,
        height: screenHeight * 0.07,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Constants.customGray,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          controller: widget.messageController,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: "Send a message...",
            hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
            border: InputBorder.none,
            prefixIcon: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    XFile? image = await _picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 50);
                    if (image != null) {
                      widget.sendMessage(file: File(image.path));
                    }
                  },
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    FilePock
                  },
                  child: const Icon(
                    Icons.edit_document,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
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
