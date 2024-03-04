import 'dart:developer';
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

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  int numberOfMessages = 0;

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // function to send message
    void sendMessage() {
      if (messageController.text.isNotEmpty) {
        ChatController()
            .sendMessage(widget.chatRoom, authNotifier, messageController.text);
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
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: StreamBuilder(
                  stream: ChatController.getMessages(widget.chatRoom.id),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                      return const Center(
                        child: Text("No messages yet"),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.data.docs.isNotEmpty) {
                      int newNumberOfMessages = snapshot.data.docs.length;
                      // mark all messages as read
                      if (numberOfMessages != newNumberOfMessages) {
                        ChatController.markMessagesAsRead(widget.chatRoom);
                        numberOfMessages = newNumberOfMessages;
                      }
                      log("Data: ${snapshot.data.docs.length}");
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Message message =
                              Message.fromMap(snapshot.data.docs[index].data());
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
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
              MessageField(
                  messageController: messageController,
                  sendMessage: sendMessage),
            ],
          ),
        ));
  }
}
