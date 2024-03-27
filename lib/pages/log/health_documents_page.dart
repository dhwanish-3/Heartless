import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/health_document_controller.dart';
import 'package:heartless/pages/log/file_upload_preview_page.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/custom_file_type.dart';
import 'package:heartless/services/storage/file_storage.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/health_document.dart';
import 'package:heartless/widgets/log/file_tile.dart';
import 'package:heartless/widgets/miscellaneous/month_divider.dart';

class HealthDocumentsPage extends StatefulWidget {
  final String patientId;
  const HealthDocumentsPage({super.key, required this.patientId});

  @override
  State<HealthDocumentsPage> createState() => _HealthDocumentsPageState();
}

class _HealthDocumentsPageState extends State<HealthDocumentsPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void healthDocumentonTap(HealthDocument healthDocument) async {
    String? path = await FileStorageService.saveFile(healthDocument.url,
        healthDocument.customFileType.name, healthDocument.name);
    if (path != null) {
      FileStorageService.openFile(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<DateTime> documentDates = {};
    Set<int> documentDatesIndex = {};
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 200,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      for (var fileFormat in CustomFileType.values)
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions:
                                        fileExtensionsFromCustomFileType(
                                            fileFormat),
                                  );

                                  if (result != null &&
                                      result.files.isNotEmpty &&
                                      result.files.single.path != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FileUploadPreviewPage(
                                                  file: result.files[0],
                                                  fileType: fileFormat,
                                                  patientId: widget.patientId,
                                                )));
                                  }
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(fileFormat.imageUrl),
                                  radius: 20,
                                ),
                              ),
                              Text(fileFormat.value),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
              margin: const EdgeInsets.only(
                  // top: 30,
                  // left: 20,
                  // right: 20,
                  ),
              height: 60,
              child: SearchBar(
                onChanged: (value) {
                  setState(() {});
                },
                controller: _searchController,
                hintText: 'Search with tag or title...',
                textStyle: MaterialStateTextStyle.resolveWith(
                  (Set<MaterialState> states) {
                    return TextStyle(
                      color: Theme.of(context).shadowColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    );
                  },
                ),
                shadowColor: MaterialStateColor.resolveWith(
                    (states) => Theme.of(context).highlightColor),
                surfaceTintColor: MaterialStateColor.resolveWith(
                  (states) =>
                      // Theme.of(context).scaffoldBackgroundColor,
                      Colors.white,
                ),
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.arrow_back_sharp),
                  ),
                ),
              )),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                //todo alternatives to specifying height
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                    stream: HealthDocumentController.getHealthDocuments(
                        widget.patientId),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.data.docs.isNotEmpty) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              HealthDocument healthDocument =
                                  HealthDocument.fromMap(
                                      snapshot.data.docs[index].data());
                              log(healthDocument.toMap().toString());

                              // check if the document is the first document of the month
                              if (!documentDates.contains(
                                  DateService.getStartOfMonth(
                                      healthDocument.createdAt))) {
                                documentDates.add(DateService.getStartOfMonth(
                                    healthDocument.createdAt));
                                documentDatesIndex.add(index);
                              }

                              // if the document is the first document of the month show the month divider
                              if (documentDatesIndex.contains(index)) {
                                return Column(children: [
                                  MonthDivider(
                                      month: DateService.getMonthFormatMMM(
                                          healthDocument.createdAt.month),
                                      year: healthDocument.createdAt.year
                                          .toString()),
                                  _buildDocumentTile(healthDocument)
                                ]);
                              } else {
                                return _buildDocumentTile(healthDocument);
                              }
                            });
                      } else {
                        return const Center(
                          child: Text('No Documents yet!'),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTile(HealthDocument healthDocument) {
    return GestureDetector(
      onTap: () {
        healthDocumentonTap(healthDocument);
      },
      child: FileTile(
        title: healthDocument.name,
        fileType: healthDocument.customFileType,
        dateString: DateService.dayDateTimeFormat(healthDocument.createdAt),
      ),
    );
  }
}
