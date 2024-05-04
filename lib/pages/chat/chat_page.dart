import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/message_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/chat/message_input_field.dart';
import 'package:heartless/widgets/chat/message_tile.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final ChatRoom chatRoom;
  final AppUser chatUser;
  const ChatPage({super.key, required this.chatRoom, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final ChatController _chatController = ChatController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int numberOfMessages = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // function to delete message
  void deleteMessage(Message message, String userId) {
    _chatController.deleteMessage(widget.chatRoom, message, userId);
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // function to send message
    void sendMessage({File? file}) {
      String trimmedMessage = _messageController.text.trim();
      if (file != null) {
        _chatController.sendMessage(
            widget.chatRoom, authNotifier.appUser!.uid, trimmedMessage,
            file: file);
      } else {
        if (trimmedMessage.isNotEmpty) {
          _chatController.sendMessage(
              widget.chatRoom, authNotifier.appUser!.uid, trimmedMessage);
        }
      }
      _messageController.clear();
    }

    Set<DateTime> chatDates = {};
    Set<int> chatDatesIndex = {};
    ;
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
                  imageUrl: Uri.parse(widget.chatUser.imageUrl).isAbsolute
                      ? widget.chatUser.imageUrl
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
                  Text(widget.chatUser.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Text(
                    widget.chatUser.isOnline
                        ? "Online"
                        : "Last seen ${DateService.getRelativeDateWithTime(widget.chatUser.lastSeen)}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          )),

      //* the textInput widget does not move up in ios
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: Container(
              // height: screenHeight * 0.8,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: StreamBuilder(
                stream: ChatController.getMessages(widget.chatRoom.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Say Hii! 👋',
                      ),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data.docs.isNotEmpty) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    int newNumberOfMessages = snapshot.data.docs.length;
                    // mark all messages as read
                    if (numberOfMessages != newNumberOfMessages) {
                      ChatController.markMessagesAsRead(widget.chatRoom);
                      numberOfMessages = newNumberOfMessages;
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.docs.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Message message =
                            Message.fromMap(snapshot.data.docs[index].data());
                        // check if the message is the first message of the day
                        if (!chatDates.contains(
                            DateService.getStartOfDay(message.time))) {
                          chatDatesIndex.add(index);
                          chatDates
                              .add(DateService.getStartOfDay(message.time));
                        }

                        // if first message of the day, show date then build message tile
                        if (chatDatesIndex.contains(index)) {
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: IntrinsicHeight(
                                  child: Container(
                                    // height: 22,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Theme.of(context).highlightColor,
                                          spreadRadius: 0,
                                          blurRadius: 0.2,
                                          offset: const Offset(0, 0.2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateService.getRelativeDate(
                                              message.time),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _buildMessageTile(widget.chatRoom, message,
                                  authNotifier.appUser!.uid),
                            ],
                          );
                        } else {
                          return _buildMessageTile(widget.chatRoom, message,
                              authNotifier.appUser!.uid);
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          MessageField(
            messageController: _messageController,
            sendMessage: sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile(ChatRoom chatRoom, Message message, String userId) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: MessageTile(
          chatId: widget.chatRoom.id,
          imageUrl: message.imageUrl,
          documentUrl:
              message.type == MessageType.document ? message.imageUrl : null,
          message: message.message,
          callback: () {
            deleteMessage(message, userId);
          },
          isSender: message.senderId == userId,
          time: DateService.getFormattedTime(message.time),
        ));
  }
}
