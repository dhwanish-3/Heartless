import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';

class ChatTile extends StatefulWidget {
  final String name;
  final String latestMessage;
  final String imageUrl;
  final int unreadMessages;
  final String time;
  const ChatTile({
    super.key,
    required this.name,
    this.latestMessage = '',
    this.imageUrl = '',
    required this.time,
    required this.unreadMessages,
  });

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: 75,
        width: screenWidth,
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage:
                      const NetworkImage("https://i.pravatar.cc/150?img=3")),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).shadowColor,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            widget.time,
                            style: TextStyle(
                              color: widget.unreadMessages > 0
                                  ? Theme.of(context).primaryColor
                                  : Constants.customGray,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              widget.latestMessage,
                              style: const TextStyle(
                                color: Constants.customGray,
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          widget.unreadMessages > 0
                              ? Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.unreadMessages.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
