import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/widgets/single_user_type.dart';

class UserTypeWidget extends StatefulWidget {
  UserType userType;
  UserTypeWidget({
    super.key,
    required this.userType,
  });

  @override
  _UserTypeState createState() => _UserTypeState();
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
          buildItem(UserType.doctor),
          buildItem(UserType.patient),
          buildItem(UserType.nurse),
        ],
      ),
    );
  }

  Widget buildItem(UserType userType) {
    final isSelected = widget.userType == userType;

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.userType = userType;
        });
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          // height: isSelected ? 300 : 200,
          child: SingleUserType(
            type: userType.index + 1,
            isSelected: isSelected,
          )),
    );
  }
}
