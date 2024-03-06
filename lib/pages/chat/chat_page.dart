import 'dart:developer';
import 'package:flutter/scheduler.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/chat/message_tile.dart';
import 'package:heartless/widgets/chat/msg_input_field.dart';

class ChatPage extends StatefulWidget {
  final ChatRoom chatRoom;
  final AppUser chatUser;
  const ChatPage({super.key, required this.chatRoom, required this.chatUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final messageController = TextEditingController();
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
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    _scrollToBottom();
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // function to send message
    void sendMessage() {
      String trimmedMessage = messageController.text.trim();
      if (trimmedMessage.isNotEmpty) {
        ChatController()
            .sendMessage(widget.chatRoom, authNotifier, trimmedMessage);
        messageController.clear();
      }
    }

    // function to delete message
    void deleteMessage(Message message) {
      ChatController().deleteMessage(widget.chatRoom, message);
    }

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: Column(
        children: [
          Text(widget.chatUser.name, style: const TextStyle(fontSize: 18)),
          Text(
            widget.chatUser.isOnline
                ? "Online"
                : "Last seen ${DateService.getFormattedTimeWithAMPM(widget.chatUser.lastSeen)}",
            style: const TextStyle(fontSize: 12),
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
                    int newNumberOfMessages = snapshot.data.docs.length;
                    // mark all messages as read
                    if (numberOfMessages != newNumberOfMessages) {
                      ChatController.markMessagesAsRead(widget.chatRoom);
                      numberOfMessages = newNumberOfMessages;
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });
                    }
                    log("Data: ${snapshot.data.docs.length}");

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data.docs.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Message message =
                            Message.fromMap(snapshot.data.docs[index].data());
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: GestureDetector(
                              onDoubleTap: () {
                                deleteMessage(message);
                              },
                              child: MessageTile(
                                message: message.message,
                                isSender: message.senderId ==
                                    authNotifier.appUser!.uid,
                                time: DateService.getFormattedTimeWithAMPM(
                                    message.time),
                              ),
                            ));
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
            messageController: messageController,
            sendMessage: sendMessage,
          ),
        ],
      ),
    );
  }
}
