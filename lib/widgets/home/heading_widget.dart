import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class HomePageHeadingWidget extends StatelessWidget {
  const HomePageHeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 360,
      child: Stack(
        children: [
          Container(
            // height: 360,
            child: Column(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(90),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.message_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      Expanded(
                        child: const SizedBox(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Welcome,',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Dr. John Doe ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Constants.primaryColor,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(
                          height: 10), // 20 if searchBar not overlapping
                    ],
                  ),
                ),
                Container(
                  color: Constants.primaryColor,
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(90),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 45, // 20 if searchBar overlapping
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SearchBar(
                hintText: 'Search...',
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
                leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Icon(Icons.search)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
