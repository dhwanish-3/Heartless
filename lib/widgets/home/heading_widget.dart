import 'package:flutter/material.dart';
import 'package:heartless/pages/chat/contacts_page.dart';
import 'package:heartless/pages/home/search_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';

class HomePageHeadingWidget extends StatelessWidget {
  final AppUser user;
  const HomePageHeadingWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
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
                padding: const EdgeInsets.only(
                  right: 20,
                  bottom: 20,
                ),
                child: Stack(
                  children: [
                    Positioned(
                        child: Container(
                      height: 200,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(200),
                          bottomLeft: Radius.circular(0),
                        ),
                      ),
                    )),

                    Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          height: 120,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(100),
                              bottomLeft: Radius.circular(0),
                            ),
                          ),
                        )),
                    Positioned(
                      top: 20,
                      right: 0,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactsPage(),
                              ));
                        },
                        icon: const Icon(
                          Icons.message_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 50,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                user.userType == UserType.doctor
                                    ? 'Dr. ' + user.name
                                    : user.userType == UserType.nurse
                                        ? 'Rn. ' + user.name
                                        : user.name,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(user.imageUrl),
                      ),
                    ),

                    // 20 if searchBar not overlapping
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
