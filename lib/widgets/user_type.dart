import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/single_user_type.dart';

class UserType extends StatefulWidget {
  const UserType({
    super.key,
  });

  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  int selectedItemId = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildItem(1),
          buildItem(2),
          buildItem(3),
        ],
      ),
    );
  }

  Widget buildItem(int itemId) {
    final isSelected = selectedItemId == itemId;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItemId = itemId;
        });
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          // height: isSelected ? 300 : 200,
          child: SingleUserType(
            type: itemId,
            isSelected: isSelected,
          )),
    );
  }
}
