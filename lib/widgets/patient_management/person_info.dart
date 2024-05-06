import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/pages/profile/qr_code_page.dart';
import 'package:heartless/shared/models/app_user.dart';

class PersonalInfoWidget extends StatelessWidget {
  final AppUser user;
  final bool disableTouch;
  const PersonalInfoWidget({
    super.key,
    required this.user,
    this.disableTouch = false,
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
                padding: const EdgeInsets.only(
                  right: 10,
                ),
                // color: const Color.fromARGB(255, 225, 225, 225),
                color: Theme.of(context).shadowColor.withOpacity(0.2),
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
                CachedNetworkImage(
                  imageUrl: user.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.red,
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
                        if (disableTouch) return;
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
