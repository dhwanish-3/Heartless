import 'package:flutter/material.dart';
import 'package:heartless/pages/profile/qr_code_page.dart';
import 'package:heartless/shared/models/app_user.dart';

class PersonalInfoWidget extends StatelessWidget {
  final AppUser user;
  const PersonalInfoWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                height: 40,
                color: const Color.fromARGB(255, 225, 225, 225),
                child: Row(
                  children: [
                    Container(
                      width: 200,
                    ),
                    Flexible(
                      child: Text(
                        user.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                )),
          ),
          Positioned(
            left: 20,
            top: 30,

            //* default image icon
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.white,
                  foregroundImage: NetworkImage(user.imageUrl),
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
                        //go to qr_code page
                        showDialog(
                          context: context,
                          builder: (context) => QRPopupWidget(
                            user: user,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
