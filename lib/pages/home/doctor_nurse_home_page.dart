import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/pages/profile/users_list_page.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/home/heading_widget.dart';
import 'package:provider/provider.dart';

class DoctorNurseHomePage extends StatefulWidget {
  DoctorNurseHomePage({
    super.key,
  });

  @override
  State<DoctorNurseHomePage> createState() => _DoctorNurseHomePageState();
}

class _DoctorNurseHomePageState extends State<DoctorNurseHomePage> {
  Future<List<AppUser>>? usersFuture;

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
                        users.length,
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
