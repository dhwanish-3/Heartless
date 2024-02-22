import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class PersonalInfoWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  const PersonalInfoWidget({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).brightness == Brightness.light
            ? Constants.cardColor
            : Constants.darkCardColor,
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
                        name,
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
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white,
              foregroundImage: NetworkImage(imageUrl),
              //* default image icon
              // child: Icon(
              //   Icons.person,
              //   size: 70,
              //   color: Colors.black,
              // ),
            ),
          )
        ],
      ),
    );
  }
}
