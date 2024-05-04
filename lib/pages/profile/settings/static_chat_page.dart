import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heartless/pages/profile/settings/static_data.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/chat/message_tile.dart';

class StaticChatPage extends StatelessWidget {
  const StaticChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<DummyMessage> messages = StaticData.messages;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leadingWidth: 25,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  imageUrl: Uri.parse(StaticData.user.imageUrl).isAbsolute
                      ? StaticData.user.imageUrl
                      : "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png",
                  height: 40,
                  width: 40,
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Theme.of(context).canvasColor),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                      height: 40,
                      width: 40,
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
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(StaticData.user.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Text(
                    "Online",
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          )),

      //* the textInput widget does not move up in ios
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 8),
              for (var message in messages)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: MessageTile(
                    message: message.message,
                    time: message.time,
                    isSender: message.isSender,
                    chatId: '',
                    disableTouch: true,
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
          Positioned(
            bottom: 0,
            child: StaticTextInput(),
          ),
        ],
      ),
    );
  }
}

class StaticTextInput extends StatelessWidget {
  const StaticTextInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 72,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              // width: screenWidth * 0.8,
              decoration: BoxDecoration(
                color: Constants.customGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.image_outlined),
                  onPressed: () async {},
                ),
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    // controller: widget.messageController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async {},
                    icon: Icon(
                      Icons.attach_file_outlined,
                    )
                    // onPressed: () async {
                    )
              ]),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.only(
              left: 16,
              right: 14,
              top: 14,
              bottom: 14,
            ),
            child: const Icon(
              Icons.send,
              size: 26,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
