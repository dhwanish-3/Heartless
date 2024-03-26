import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  final List<String> queries = [
    'Scan to add a Doctor or Nurse',
    'Chat with Abhiram',
    'Chat with Dr. John',
    'Upload Files',
    'View Your Docuemnts',
    'View Today\'s Schedule',
    'View Today\'s Medication',
    'View Today\'s Exercise',
    'View Today\'s Diet',
    'View Today\'s Readings',
    'Add a new Reading',
    'Add a Diary Entry',
    'View Your Diary',
    'View Your Timeline',
    'View Analytics of Medical Readings',
    'View Analytics of Activities',
    'Change Profile Picture',
    'Change Password',
  ];
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(90),
          child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 30,
                horizontal: 20,
              ),
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
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: widget.queries.length,
                      itemBuilder: (context, index) {
                        final query = widget.queries[index].toLowerCase();
                        final searchText = _searchController.text.toLowerCase();

                        if (searchText.isEmpty || query.contains(searchText)) {
                          return ListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                widget.queries[index],
                                style: TextStyle(
                                  color: Theme.of(context).shadowColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            onTap: () {
                              // redirect to particular shortcut
                            },
                          );
                        } else {
                          return SizedBox
                              .shrink(); // Return an empty widget if the query doesn't match the search text
                        }
                      },
                    )))));
  }
}
