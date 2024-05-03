import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/pages/demo/categorised_demo_page.dart';
import 'package:heartless/pages/profile/users_list_page.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/demonstration.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/home/heading_widget.dart';
import 'package:heartless/widgets/info/demo_card.dart';
import 'package:provider/provider.dart';

List<Demonstration> items = [
  Demonstration(
    title: "Planking",
    imageUrl: "assets/illustrations/plank.jpeg",
    videoUrl:
        "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
    sections: List<Section>.generate(
      4,
      (index) => Section(title: "Section $index", points: [
        "point 1 take ample water inside to match your requirements",
        "point 2",
        "point 3"
      ]),
    ),
  ),
  Demonstration(
    title: "Breathing",
    imageUrl: "assets/illustrations/breathing.jpeg",
    videoUrl:
        "https://firebasestorage.googleapis.com/v0/b/heartless-17b56.appspot.com/o/demos%2FArc%20on%20Windows.%20Download%20now..mp4?alt=media",
    sections: List<Section>.generate(
      3,
      (index) => Section(
          title: "Section $index", points: ["point 1", "point 2", "point 3"]),
    ),
  ),
];

class DoctorNurseHomePage extends StatefulWidget {
  DoctorNurseHomePage({
    super.key,
  });

  @override
  State<DoctorNurseHomePage> createState() => _DoctorNurseHomePageState();
}

class _DoctorNurseHomePageState extends State<DoctorNurseHomePage> {
  Future<List<AppUser>>? usersFuture;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    AuthNotifier _authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    usersFuture = ConnectUsersController.getAllPatientsHandledByUser(
        _authNotifier.appUser!.uid, _authNotifier.appUser!.userType);
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HomePageHeadingWidget(
                user: authNotifier.appUser!,
              ),
              PatientList(usersFuture: usersFuture),
              const SizedBox(height: 20),
              DemoPreviewWidget(pageController: _pageController),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientList extends StatelessWidget {
  final Future<List<AppUser>>? usersFuture;

  const PatientList({Key? key, this.usersFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color:Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Patients',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  //navigate to UserListPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersListPage(
                        appUser: authNotifier.appUser!,
                        usersFuture: usersFuture,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.keyboard_arrow_right),
                color: Theme.of(context).shadowColor,
                padding: EdgeInsets.zero,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<List<AppUser>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<AppUser> users = snapshot.data!;
                  if (users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                      ),
                      child: Text('No patients currently under your care',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).shadowColor,
                            fontWeight: FontWeight.w400,
                          )),
                    );
                  } else {
                    return Column(
                      children: List.generate(
                        users.length > 3 ? 3 : users.length,
                        (index) {
                          AppUser user = users[index];
                          return Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).highlightColor,
                                  offset: const Offset(0, 0.5),
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    user.imageUrl,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    user.name,
                                    style:
                                        // Theme.of(context).textTheme.bodySmall,
                                        TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).shadowColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }
}

class DemoPreviewWidget extends StatelessWidget {
  final PageController pageController;
  const DemoPreviewWidget({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        // color:Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(20),
        //todo should test as to whether or not the boxshadow should be kept
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor,
            offset: const Offset(0, 0.5),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Text(
                'Demonstrations',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).shadowColor,
                ),
              ),
              Expanded(
                child: const SizedBox(height: 10),
              ),
              // Icon(
              //   Icons.keyboard_arrow_right_outlined,
              // ),
              SizedBox(
                height: 20,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    //navigate to UserListPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategorisedDemoListPage(
                                items: items,
                              )),
                    );
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_right_outlined,
                  ),
                  color: Theme.of(context).shadowColor,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 5),
          ScrollableDemoList(items: items, pageController: pageController),
        ],
      ),
    );
  }
}
