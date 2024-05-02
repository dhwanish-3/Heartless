import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/pages/log/file_upload_preview_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/widget_provider.dart';
import 'package:provider/provider.dart';

class QRResultPage extends StatelessWidget {
  final AppUser appUser;
  QRResultPage({
    super.key,
    required this.appUser,
  });

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);

    // * addUser function
    Future<void> addUser(user) async {
      if (user != null &&
          authNotifier.appUser!.uid != user!.uid &&
          authNotifier.appUser!.userType != user!.userType) {
        widgetNotifier.setLoading(true);

        await ConnectUsersController.connectUsers(authNotifier.appUser!, user!)
            .then((_) {
          widgetNotifier.setLoading(false);
          Navigator.of(context).pop();
        });
      }
    }

    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: Uri.parse(appUser.imageUrl).isAbsolute
                ? appUser.imageUrl
                : 'https://via.placeholder.com/150',
            height: 160,
            width: 160,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
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
        const SizedBox(height: 10),
        Text(
          appUser.name,
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
              appUser.email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 60),
        CustomFormSubmitButton(
          text: 'Add ${appUser.userType.capitalisedName}',
          onTap: () {
            addUser(appUser);
          },
          padding: 60,
        ),
      ],
    )));
  }
}
