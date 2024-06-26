import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/services/storage/file_storage.dart';
import 'package:heartless/shared/constants.dart';

// ! if message is a document, then the message will be the file name
class MessageTile extends StatelessWidget {
  final String? imageUrl;
  final String message;
  final bool isSender;
  final String? documentUrl;
  final String time;
  final String chatId;
  final bool disableTouch;
  final callback;

  const MessageTile({
    super.key,
    this.imageUrl,
    this.documentUrl,
    required this.message,
    this.isSender = true,
    required this.chatId,
    required this.time,
    this.callback,
    this.disableTouch = false,
  });

  @override
  Widget build(BuildContext context) {
    Future<dynamic> showDeleteConfirmationDialog(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Message'),
            content: Text('Are you sure you want to delete this message?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }

    double screenWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: InkWell(
        highlightColor: Theme.of(context).cardColor,
        onLongPress: () {
          if (disableTouch || !isSender) return;
          showDeleteConfirmationDialog(context).then((value) {
            if (value != null && value) {
              callback();
            }
          });
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.8,
            minHeight: 30,
            minWidth: 115,
          ),
          padding: imageUrl != null && documentUrl == null
              ? const EdgeInsets.symmetric(horizontal: 5, vertical: 4)
              : EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSender
                ? (Theme.of(context).brightness == Brightness.dark)
                    ? Theme.of(context).primaryColor.withOpacity(0.7)
                    : Theme.of(context).primaryColor.withOpacity(0.8)
                : Constants.customGray,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isSender
                  ? const Radius.circular(16)
                  : const Radius.circular(4),
              bottomRight: isSender
                  ? const Radius.circular(4)
                  : const Radius.circular(16),
            ),
          ),
          child: Stack(
            children: [
              Container(
                  padding: imageUrl != null && documentUrl == null
                      ? const EdgeInsets.only(top: 0, bottom: 0, right: 0)
                      : const EdgeInsets.only(top: 2, bottom: 10, right: 10),
                  child: documentUrl == null
                      ? Column(
                          children: [
                            imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              backgroundColor: Colors.black,
                                              body: Center(
                                                child: Hero(
                                                  tag: 'imageHero' + imageUrl!,
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: Uri.parse(
                                                                imageUrl!)
                                                            .isAbsolute
                                                        ? imageUrl!
                                                        : 'https://via.placeholder.com/150',
                                                    height: 250,
                                                    width: 250,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                                color: Theme.of(
                                                                        context)
                                                                    .canvasColor),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                            height: 52,
                                                            width: 52,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color: Theme.of(
                                                                      context)
                                                                  .shadowColor,
                                                            ),
                                                            child: const Icon(
                                                              Icons
                                                                  .person_2_outlined,
                                                              color:
                                                                  Colors.black,
                                                              size: 30,
                                                            )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: 'imageHero' + imageUrl!,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: Uri.parse(imageUrl!)
                                                  .isAbsolute
                                              ? imageUrl!
                                              : 'https://via.placeholder.com/150',
                                          height: 250,
                                          width: 250,
                                          placeholder: (context, url) => Center(
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .canvasColor),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  height: 52,
                                                  width: 52,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Theme.of(context)
                                                        .shadowColor,
                                                  ),
                                                  child: const Icon(
                                                    Icons.person_2_outlined,
                                                    color: Colors.black,
                                                    size: 30,
                                                  )),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            Container(
                              width: imageUrl != null ? 250 : null,
                              padding: imageUrl != null && message.isNotEmpty
                                  ? const EdgeInsets.only(
                                      top: 2,
                                      bottom: 10,
                                      right: 10,
                                      left: 4,
                                    )
                                  : const EdgeInsets.all(0),
                              child: Text(
                                message,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        )
                      //! if the message is a document
                      : GestureDetector(
                          onTap: () async {
                            if (imageUrl != null) {
                              String? path = await FileStorageService.saveFile(
                                  imageUrl!, chatId, message);
                              if (path != null)
                                FileStorageService.openFile(path);
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/Icons/chat/pdf_icon.png',
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  message,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      height: 1.2,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )),
              Positioned(
                right: 0,
                bottom: 0,
                child: Text(
                  time,
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
