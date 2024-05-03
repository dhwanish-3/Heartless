import 'package:flutter/material.dart';
import 'package:heartless/services/utils/search_service.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

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
                  textStyle: WidgetStateTextStyle.resolveWith(
                    (Set<WidgetState> states) {
                      return TextStyle(
                        color: Theme.of(context).shadowColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      );
                    },
                  ),
                  shadowColor: WidgetStateColor.resolveWith(
                      (states) => Theme.of(context).highlightColor),
                  surfaceTintColor: WidgetStateColor.resolveWith(
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
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: SearchService.globalSearchOptions.length,
                itemBuilder: (context, index) {
                  final String option = SearchService
                      .globalSearchOptions[index].name
                      .toLowerCase();
                  final String searchText =
                      _searchController.text.toLowerCase();
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
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                color: Theme.of(context).shadowColor),
                            const SizedBox(width: 20),
                            Text(
                              SearchService.globalSearchOptions[index].name,
                              style: TextStyle(
                                color: Theme.of(context).shadowColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: SearchService.globalSearchOptions[index].onTap,
                    );
                  } else {
                    return Container(); // Return an empty widget if the query doesn't match the search text
                  }
                },
              ),
            ),
          ],
        ));
  }
}
