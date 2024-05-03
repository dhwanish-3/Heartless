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

    final TextEditingController messageController = widget.messageController;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Constants.customGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.image_outlined),
                onPressed: () async {
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
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.2,
                ),
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: widget.messageController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Text(convertBytes(result.files.single.size),
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
                  icon: Icon(
                    Icons.attach_file_outlined,
                  )
                  // onPressed: () async {
                  )
            ]),
          ),
          GestureDetector(
            onTap: () {
              widget.sendMessage();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.only(
                left: 16,
                right: 14,
                top: 14,
                bottom: 14,
              ),
              child: const Icon(
                Icons.send,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
