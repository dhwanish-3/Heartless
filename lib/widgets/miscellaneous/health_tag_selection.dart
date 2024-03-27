import 'package:flutter/material.dart';
import 'package:heartless/services/enums/event_tag.dart';

class HealthTagSelctionWidget extends StatefulWidget {
  final List<EventTag> selectedList;
  const HealthTagSelctionWidget({
    super.key,
    required this.selectedList,
  });

  @override
  State<HealthTagSelctionWidget> createState() =>
      _HealthTagSelctionWidgetState();
}

class _HealthTagSelctionWidgetState extends State<HealthTagSelctionWidget> {
  List<EventTag> dataList = EventTag.values;
  // List<EventTag> selectedList = [];
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  double _containerHeight = 0;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChange);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    setState(() {
      _containerHeight = _searchFocusNode.hasFocus ? 200 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
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
              'Associated Tags',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).shadowColor,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              children: [
                for (var item in widget.selectedList)
                  Container(
                    margin: const EdgeInsets.only(right: 5, bottom: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).primaryColor,
                      color: item.tagColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).shadowColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.value,
                          style: TextStyle(
                            // color: Theme.of(context).shadowColor,
                            color: item.tagColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Theme.of(context).shadowColor,
                            // color: item.tagColor,
                          ),
                          onTap: () {
                            setState(() {
                              widget.selectedList.remove(item);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                TagSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  height: _containerHeight,
                  duration: Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: _containerHeight > 0
                        ? [
                            BoxShadow(
                              color: Theme.of(context).highlightColor,
                              blurRadius: 0.5,
                              spreadRadius: 0.5,
                              offset: Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return _searchController.text.isEmpty ||
                              dataList[index].value.toLowerCase().contains(
                                  _searchController.text.toLowerCase())
                          ? InkWell(
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.only(bottom: 2),
                                decoration: BoxDecoration(
                                  color: widget.selectedList
                                          .contains(dataList[index])
                                      ? Theme.of(context).secondaryHeaderColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      widget.selectedList
                                              .contains(dataList[index])
                                          ? Icons.check
                                          : Icons.add,
                                      size: 20,
                                      color: widget.selectedList
                                              .contains(dataList[index])
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      dataList[index].value,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: widget.selectedList
                                                .contains(dataList[index])
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context).shadowColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (widget.selectedList
                                      .contains(dataList[index])) {
                                    widget.selectedList.remove(dataList[index]);
                                  } else {
                                    widget.selectedList.add(dataList[index]);
                                  }
                                });
                              },
                            )
                          : SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TagSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;

  const TagSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        padding: EdgeInsets.only(
          bottom: 0,
          top: 0,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).highlightColor,
                blurRadius: 0.5,
                spreadRadius: 0.5,
                offset: Offset(0, 1),
              ),
            ]),
        child: TextField(
          onChanged: onChanged,
          controller: controller,
          focusNode: focusNode,
          cursorHeight: 24,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Lab Report, Prescription...',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
        ));
  }
}

class DummySearchBar extends StatelessWidget {
  const DummySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).highlightColor,
              blurRadius: 0.5,
              spreadRadius: 0.5,
              offset: Offset(0, 1),
            ),
          ]),
      height: 40,
      width: MediaQuery.of(context).size.width - 80,
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          const Icon(
            size: 24,
            Icons.search,
            color: Colors.grey,
          ),
          const SizedBox(width: 5),
          Text(
            'Lab Report, Prescription...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
