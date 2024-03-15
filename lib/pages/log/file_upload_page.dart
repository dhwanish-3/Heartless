import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/file_type.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/log/file_tile.dart';
import 'package:heartless/widgets/miscellaneous/month_divider.dart';
import 'package:heartless/widgets/patient_management/timeline_widget.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                      for (var fileFormat in FileType.values)
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  //! file upload mechanism here
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
      appBar: AppBar(
        title: SearchBar(
          controller: _searchController,
          hintText: 'Search by tag or title',
          hintStyle: MaterialStateProperty.all(
            TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          leading: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.fromLTRB(0, 5, 12, 0),
            child: Image.asset('assets/Icons/magnifyingGlass.png', scale: 2),
          ),
          onChanged: (text) {
            setState(() {});
            {
              // ! search functionality
              print(text);
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MonthDivider(
                month: 'February',
                year: '2024',
              ),
              FileTile(
                title: 'Blood Report',
                dateString: DateService.dayDateTimeFormat(DateTime.now()),
                imageUrl:
                    'assets/Icons/fileFormat/pdf.png', //should be replaced with FileType.imageUrl
              ),
              const SizedBox(height: 5),
              FileTile(
                title: 'Blood Report',
                dateString: DateService.dayDateTimeFormat(DateTime.now()),
                imageUrl: 'assets/Icons/fileFormat/txt.png',
              ),
              const SizedBox(height: 5),
              FileTile(
                title: 'Blood Report',
                dateString: DateService.dayDateTimeFormat(DateTime.now()),
                imageUrl: 'assets/Icons/fileFormat/png.png',
              ),
              MonthDivider(
                month: 'March',
                year: '2024',
              ),
              FileTile(
                title: 'Blood Report',
                dateString: DateService.dayDateTimeFormat(DateTime.now()),
                imageUrl: 'assets/Icons/fileFormat/doc.png',
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
