import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/pages/log/health_documents_page.dart';
import 'package:heartless/pages/profile/edit_profile_page.dart';
import 'package:heartless/pages/profile/qr_code_page.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/miscellaneous/right_trailing_button.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

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
            _ProfileActions(),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: CachedNetworkImage(
                imageUrl: Uri.parse(authNotifier.appUser!.imageUrl).isAbsolute
                    ? authNotifier.appUser!.imageUrl
                    : 'https://via.placeholder.com/150',
                height: 52,
                width: 52,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                // todo: modify the error widget
                errorWidget: (context, url, error) => Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
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
          child: InkWell(
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
            child: RightButton(
              text: 'Edit Profile',
              showTrailingIcon: false,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class _ProfileActions extends StatelessWidget {
  const _ProfileActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    const actions = [
      'Logout',
      'Settings',
      'TimeLine',
      'Documents',
      'Doctors & Nurses',
    ];

    const actionIcons = [
      Icons.logout,
      Icons.settings,
      Icons.timeline,
      Icons.file_copy,
      Icons.medical_services,
    ];
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            for (int i = 0; i < actions.length; i++)
              _ProfileActionTile(
                actionString: actions[i],
                actionIcon: actionIcons[i],
                onTap: () {
                  switch (i) {
                    case 0:
                      //logout
                      break;
                    case 1:
                      //navigate to settings
                      break;
                    case 2:
                      //navigate to timeline
                      break;
                    case 3:
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              //* should be rechecked
                              builder: (context) => HealthDocumentsPage(
                                    patientId: authNotifier.appUser!.uid,
                                  )));
                      //documents
                      break;
                    case 4:
                      //doctors and nurses
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
