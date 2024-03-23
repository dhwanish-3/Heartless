import 'package:flutter/material.dart';
import 'package:heartless/services/enums/event_tag.dart';
import 'package:heartless/shared/constants.dart';

class FileUploadPreviewPage extends StatelessWidget {
  static String convertBytes(int bytes) {
    double kilobytes = bytes / 1024;
    double megabytes = kilobytes / 1024;

    if (megabytes >= 1) {
      return '${megabytes.toStringAsFixed(2)} MB';
    } else {
      return '${kilobytes.toStringAsFixed(2)} KB';
    }
  }

  const FileUploadPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.close),
          onPressed: () {
            //! cancel
          },
        ),
        title: Center(
          child: Text(
            'Preview',
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.check),
            onPressed: () {
              //! submit
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Icons/fileFormat/documentPreview.png',
                        height: 60,
                        width: 60,
                      ),
                      Flexible(
                        child: Text('FileName ',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            )),
                      ),
                      const SizedBox(height: 5),
                      Text(
                          convertBytes(
                            2047,
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          )),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    hintText: 'Enter a description for the file',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 600,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                color: Constants.cardColor,
                child: SearchWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _searchController = TextEditingController();
  List<EventTag> dataList = EventTag.values.toList();
  List<EventTag> searchResults = [];
  List<EventTag> selectedItems = [];

  @override
  void initState() {
    super.initState();
    searchResults = dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: Text(
            'Associated Tags',
            textAlign: TextAlign.start,
            // style: Theme.of(context).textTheme.headlineMedium
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).shadowColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              filterSearchResults(value);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              bool isSelected = selectedItems.contains(searchResults[index]);
              return ListTile(
                leading: isSelected
                    ? Icon(Icons.check)
                    : const SizedBox(
                        width: 20,
                      ),
                title: Container(
                  height: 20,
                  child: Row(
                    children: [
                      Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: (searchResults[index]
                                .tagColor), // Use getColor function here
                            shape: BoxShape.circle,
                          )),
                      const SizedBox(width: 10),
                      Text(
                        searchResults[index].value,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ), // Use .value to get the string representation of the enum
                    ],
                  ),
                ),
                trailing: isSelected
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedItems.remove(searchResults[index]);
                          });
                        },
                      )
                    : const SizedBox(width: 20),
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedItems.remove(searchResults[index]);
                    } else {
                      selectedItems.add(searchResults[index]);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

//! doesn't work as expected
  void filterSearchResults(String query) {
    List<EventTag> dummyListData = [];
    dummyListData.addAll(selectedItems); // Add selected items first

    if (query.isNotEmpty) {
      dataList.forEach((item) {
        if (item.value.toLowerCase().contains(query.toLowerCase()) &&
            !selectedItems.contains(item)) {
          dummyListData.add(item);
        }
      });
    } else {
      dataList.forEach((item) {
        if (!selectedItems.contains(item)) {
          dummyListData.add(item);
        }
      });
    }

    setState(() {
      searchResults.clear();
      searchResults.addAll(dummyListData);
    });
  }
}
