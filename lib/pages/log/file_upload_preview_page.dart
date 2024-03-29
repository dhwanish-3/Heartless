import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/health_document_controller.dart';
import 'package:heartless/services/enums/custom_file_type.dart';
import 'package:heartless/services/enums/event_tag.dart';
import 'package:heartless/widgets/miscellaneous/health_tag_selection.dart';

class FileUploadPreviewPage extends StatelessWidget {
  final PlatformFile file;
  final String patientId;
  final CustomFileType fileType;

  FileUploadPreviewPage(
      {super.key,
      required this.file,
      required this.patientId,
      required this.fileType});

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
    List<EventTag> selectedList = [];

    void _addHealthDocument() async {
      await HealthDocumentController().addHealthDocument(
        patientId,
        file.name,
        fileType,
        selectedList,
        File(file.path!),
      );
    }

    ;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Preview',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   'assets/Icons/fileFormat/documentPreview.png',
                      //   height: 60,
                      //   width: 60,
                      // ),
                      Icon(
                        Icons.insert_drive_file,
                        size: 50,
                      ),
                      Flexible(
                        child: Text(file.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.6),
                              fontSize: 24,
                            )),
                      ),
                      const SizedBox(height: 5),
                      Text(convertBytes(file.size),
                          style: TextStyle(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.6),
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              HealthTagSelctionWidget(
                selectedList: selectedList,
              ),
              Container(
                // padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                // height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comment',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).shadowColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      maxLines: 3,
                      style: TextStyle(
                        color: Theme.of(context).shadowColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1,
                          ),
                        ),
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: Theme.of(context).shadowColor.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        hintText: 'Enter a description for the file',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CustomFormSubmitButton(
                onTap: _addHealthDocument,
                padding: 40,
                text: 'Upload',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFormSubmitButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final double padding;
  const CustomFormSubmitButton({
    super.key,
    required this.onTap,
    this.text = 'Submit',
    this.padding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 50,
          margin: EdgeInsets.symmetric(
            horizontal: padding,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).highlightColor,
                blurRadius: 0.5,
                spreadRadius: 0.5,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                // color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
