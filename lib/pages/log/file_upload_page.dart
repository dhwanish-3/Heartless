import 'package:flutter/material.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/log/file_tile.dart';
import 'package:heartless/widgets/miscellaneous/month_divider.dart';

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
        onPressed: () {},
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
              // print(_searchController.text);
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
