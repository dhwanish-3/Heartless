import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/auth_controller.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/pages/log/health_documents_page.dart';
import 'package:heartless/pages/profile/edit_profile_page.dart';
import 'package:heartless/pages/profile/extended_timeline_page.dart';
import 'package:heartless/pages/profile/qr_code_page.dart';
import 'package:heartless/pages/profile/settings/settings_page.dart';
import 'package:heartless/pages/profile/users_list_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = AuthController();

  List<AppUser> users = []; // list of patients

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // to be used for nurse_doctor_profile page

    if (authNotifier.appUser!.userType == UserType.patient) {
      ConnectUsersController.getAllUsersConnectedToPatient(
              authNotifier.appUser!.uid)
          .then((value) {
        setState(() {
          users = value;
        });
      });
    } else {
      ConnectUsersController.getAllPatientsHandledByUser(
              authNotifier.appUser!.uid, authNotifier.appUser!.userType)
          .then((value) {
        setState(() {
          users = value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    void logout() async {
      await _authController.logout(authNotifier);
      if (context.mounted) {
        // ! ensure that the widget is mounted before navigating
        Navigator.pushNamedAndRemoveUntil(
            context, '/loginOrSignup', (route) => false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            _HeaderSection(authNotifier: authNotifier),
            _ProfileActions(
              users: users,
              logout: logout,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    super.key,
    required this.authNotifier,
  });

  final AuthNotifier authNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Stack(children: [
          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: Theme.of(context).secondaryHeaderColor,
                width: 1,
              ),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: Uri.parse(authNotifier.appUser!.imageUrl).isAbsolute
                    ? authNotifier.appUser!.imageUrl
                    : 'https://via.placeholder.com/150',
                height: 160,
                width: 160,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                // todo: modify the error widget
                errorWidget: (context, url, error) => Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).shadowColor,
                    ),
                    child: const Icon(
                      Icons.person_2_outlined,
                      color: Colors.black,
                      size: 30,
                    )),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  //show as pop up the QRPopupWidget
                  showDialog(
                    context: context,
                    builder: (context) => QRPopupWidget(
                      user: authNotifier.appUser!,
                    ),
                  );
                },
                iconSize: 24,
                icon: Icon(
                  Icons.qr_code,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Text(
          authNotifier.appUser!.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mail,
              size: 12,
            ),
            const SizedBox(width: 2),
            Text(
              authNotifier.appUser!.email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 0,
            top: 20,
          ),
          child: RightButton(
            text: 'Edit Profile',
            showTrailingIcon: false,
            onTap: () {
              //navigate to edit profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    user: authNotifier.appUser!,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class _ProfileActions extends StatelessWidget {
  final void Function() logout;
  final List<AppUser> users;
  const _ProfileActions({
    super.key,
    required this.logout,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    const actions = [
      'Settings',
      'TimeLine',
      'Documents',
      'Doctors & Nurses',
      'Logout',
    ];
    const alternateActions = [
      'Settings',
      'Patients',
      'Logout',
    ];
    const actionIcons = [
      Icons.settings,
      Icons.timeline,
      Icons.file_copy,
      Icons.people,
      Icons.logout,
    ];

    const alternateActionIcons = [
      Icons.settings,
      Icons.people,
      Icons.logout,
    ];
    return Container(
        width: double.infinity,
        child: Column(
          children: authNotifier.appUser!.userType == UserType.patient
              ? [
                  for (int i = 0; i < actions.length; i++)
                    _ProfileActionTile(
                      actionString: actions[i],
                      actionIcon: actionIcons[i],
                      onTap: () {
                        switch (i) {
                          case 0:
                            //navigate to settings
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            );
                            break;
                          case 1:
                            //navigate to timeline
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExtendedTimelinePage(
                                  patient: authNotifier.appUser!,
                                ),
                              ),
                            );
                            break;
                          case 2:
                            //documents
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    //* should be rechecked
                                    builder: (context) => HealthDocumentsPage(
                                          patientId: authNotifier.appUser!.uid,
                                        )));

                            break;
                          case 3:
                            //navigate to doctors and nurses
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsersListPage(
                                  appUser: authNotifier.appUser!,
                                  users: users,
                                ),
                              ),
                            );
                            break;
                          case 4:

                            //logout
                            logout();
                            break;
                          default:
                        }
                      },
                    )
                ]
              : [
                  for (int i = 0; i < alternateActions.length; i++)
                    _ProfileActionTile(
                      actionString: alternateActions[i],
                      actionIcon: alternateActionIcons[i],
                      onTap: () {
                        switch (i) {
                          case 0:
                            //navigate to settings
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            );

                            break;
                          case 1:
                            //navigate to patients
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsersListPage(
                                  appUser: authNotifier.appUser!,
                                  users: users,
                                ),
                              ),
                            );
                            break;
                          case 2:

                            //logout
                            logout();
                            break;
                          default:
                        }
                      },
                    )
                ],
        ));
  }
}

class _ProfileActionTile extends StatelessWidget {
  final String actionString;
  final IconData actionIcon;
  final void Function() onTap;
  const _ProfileActionTile({
    super.key,
    required this.actionString,
    required this.actionIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(
            left: 40,
            right: 20,
            top: 10,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                actionIcon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 20),
              Text(
                actionString,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Expanded(
                child: const SizedBox(),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          )),
    );
  }
}
