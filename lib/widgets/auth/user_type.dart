import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/auth/single_user_type.dart';

class UserTypeWidget extends StatefulWidget {
  const UserTypeWidget({
    super.key,
  });

  @override
  State<UserTypeWidget> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildChooseUserTypeWidget(UserType.doctor, context),
          buildChooseUserTypeWidget(UserType.patient, context),
          buildChooseUserTypeWidget(UserType.nurse, context),
        ],
      ),
    );
  }

  Widget buildChooseUserTypeWidget(UserType userType, BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final isSelected = authNotifier.userType == userType;

    return GestureDetector(
      onTap: () {
        setState(() {
          authNotifier.setUserType(userType);
        });
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          // height: isSelected ? 110 : 90,
          child: SingleUserType(
            type: userType.index + 1,
            isSelected: isSelected,
          )),
    );
  }
}
