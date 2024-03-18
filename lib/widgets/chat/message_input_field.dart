import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:image_picker/image_picker.dart';

class MessageField extends StatefulWidget {
  final TextEditingController messageController;
  final void Function({File? file}) sendMessage;
  final bool isOnlyText;
  const MessageField({
    super.key,
    required this.messageController,
    required this.sendMessage,
    this.isOnlyText = false,
  });

  @override
  State<MessageField> createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final ImagePicker _picker = ImagePicker();

  static String convertBytes(int bytes) {
    double kilobytes = bytes / 1024;
    double megabytes = kilobytes / 1024;

    if (megabytes >= 1) {
      return '${megabytes.toStringAsFixed(2)} MB';
    } else {
      return '${kilobytes.toStringAsFixed(2)} KB';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //! dummy controller created for the sake of testing
    final TextEditingController messageController = widget.messageController;
    return Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.2,
        ),
        width: screenWidth,
        // height: screenHeight * 0.07,
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
            prefixIcon: widget.isOnlyText
                ? null
                : SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            XFile? image = await _picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 50);
                            if (image != null) {
                              bool? shouldSend = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    backgroundColor: Colors.black,
                                    appBar: AppBar(
                                      title: Text('Preview'),
                                      actions: [
                                        IconButton(
                                          icon: Icon(Icons.check),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ),
                                    body: Column(
                                      children: [
                                        Expanded(
                                            child: Image.file(File(
                                          image.path,
                                        ))),
                                        MessageField(
                                          //! new controller need to be passed if necessary
                                          messageController: messageController,
                                          //! new sendMessage function to be passed that would send both image and text and associate them to each other
                                          sendMessage: widget.sendMessage,
                                          isOnlyText: true,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              if (shouldSend == true) {
                                widget.sendMessage(file: File(image.path));
                              }
                            }
                          },
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null &&
                                result.files.isNotEmpty &&
                                result.files.single.path != null) {
                              bool? shouldSend = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    backgroundColor: Colors.grey,
                                    appBar: AppBar(
                                      title: Text('Preview'),
                                      actions: [
                                        IconButton(
                                          icon: Icon(Icons.check),
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                        ),
                                      ],
                                    ),
                                    body: Center(
                                      //* for the time being only image is shown can display pdf preview later on
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/Icons/fileFormat/documentPreview.png',
                                            height: 60,
                                            width: 60,
                                          ),
                                          Text(result.files.single.name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                              )),
                                          const SizedBox(height: 5),
                                          Text(
                                              convertBytes(
                                                  result.files.single.size),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              )),
                                          const SizedBox(
                                            height: 100,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              if (shouldSend == true) {
                                widget.sendMessage(
                                    file: File(result.files.single.path!));
                              }
                            }
                          },
                          child: const Icon(
                            Icons.edit_document,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
