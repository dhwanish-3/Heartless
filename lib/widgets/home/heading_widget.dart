import 'package:flutter/material.dart';
import 'package:heartless/pages/home/search_page.dart';
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
            bottom: 50, // 20 if searchBar overlapping
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => SearchPage(),
                    transitionsBuilder: (_, animation, __, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).highlightColor,
                        blurRadius: 3,
                        spreadRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ]),
                height: 54,
                width: MediaQuery.of(context).size.width - 80,
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    const Icon(
                      size: 30,
                      Icons.search,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Search ...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
