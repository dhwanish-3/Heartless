import 'package:flutter/material.dart';
import 'package:heartless/services/utils/search_service.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  // final List<String> queries = [
  //   'Scan to add a Doctor or Nurse',
  //   'Chat with Abhiram',
  //   'Chat with Dr. John',
  //   'Upload Files',
  //   'View Your Docuemnts',
  //   'View Today\'s Schedule',
  //   'View Today\'s Medication',
  //   'View Today\'s Exercise',
  //   'View Today\'s Diet',
  //   'View Today\'s Readings',
  //   'Add a new Reading',
  //   'Add a Diary Entry',
  //   'View Your Diary',
  //   'View Your Timeline',
  //   'View Analytics of Medical Readings',
  //   'View Analytics of Activities',
  //   'Change Profile Picture',
  //   'Change Password',
  // ];
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(
                  // top: 30,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                height: 60,
                child: SearchBar(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _searchController,
                  hintText: 'Search for shortcuts...',
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
                child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: SearchService.globalSearchOptions.length,
            itemBuilder: (context, index) {
              final String option =
                  SearchService.globalSearchOptions[index].name.toLowerCase();
              final String searchText = _searchController.text.toLowerCase();
              final List<String> keywords =
                  SearchService.globalSearchOptions[index].keywords;

              if (searchText.isEmpty ||
                  option.contains(searchText) ||
                  searchText.contains(option) ||
                  keywords.any((keyword) => keyword.contains(searchText)) ||
                  keywords.any((keyword) => searchText.contains(keyword))) {
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      SearchService.globalSearchOptions[index].name,
                      style: TextStyle(
                        color: Theme.of(context).shadowColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  onTap: SearchService.globalSearchOptions[index].onTap,
                );
              } else {
                return SizedBox
                    .shrink(); // Return an empty widget if the query doesn't match the search text
              }
            },
          ),
          // child: FutureBuilder(
          //     future: SearchService.generateStaticSearchList(
          //         Provider.of<AuthNotifier>(context).appUser!),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState ==
          //           ConnectionState.waiting) {
          //         return Center(
          //           child: CircularProgressIndicator(
          //             color: Theme.of(context).primaryColor,
          //           ),
          //         );
          //       } else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       } else {
          //         List<SearchOption> searchOptions = snapshot.data!;
          //         return ListView.builder(
          //           itemCount: searchOptions.length,
          //           itemBuilder: (context, index) {
          //             final String option =
          //                 searchOptions[index].name.toLowerCase();
          //             final String searchText =
          //                 _searchController.text.toLowerCase();

          //             if (searchText.isEmpty ||
          //                 option.contains(searchText) ||
          //                 searchText.contains(option)) {
          //               return ListTile(
          //                 title: Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                     horizontal: 20,
          //                     vertical: 10,
          //                   ),
          //                   child: Text(
          //                     searchOptions[index].name,
          //                     style: TextStyle(
          //                       color: Theme.of(context).shadowColor,
          //                       fontSize: 16,
          //                     ),
          //                   ),
          //                 ),
          //                 onTap: searchOptions[index].onTap,
          //               );
          //             } else {
          //               return SizedBox
          //                   .shrink(); // Return an empty widget if the query doesn't match the search text
          //             }
          //           },
          //         );
          //       }
          // })))));
        ))));
  }
}
