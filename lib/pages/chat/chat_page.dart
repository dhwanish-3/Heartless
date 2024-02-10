import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:heartless/backend/services/chat/message_service.dart';
import 'package:heartless/main.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/chat/message_tile.dart';
import 'package:heartless/widgets/chat/msg_input_field.dart';

class ChatPage extends StatefulWidget {
  final ChatRoom chatRoom;
  const ChatPage({super.key, required this.chatRoom});

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

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // function to send message
    void sendMessage() async {
      if (messageController.text.isNotEmpty) {
        Message message = Message();
        message.message = messageController.text;
        message.senderId = authNotifier.appUser!.uid;
        message.time = DateTime.now();
        message.receiverId =
            widget.chatRoom.user1!.id == authNotifier.appUser!.uid
                ? widget.chatRoom.user2!.id
                : widget.chatRoom.user1!.id;
        await MessageService.sendMessage(widget.chatRoom.id, message);
        messageController.clear();
      }
    }

    // formatting the time to show in the chat with Oct 11, 20023 10:00 AM/PM format
    String formattedTime(DateTime time) {
      DateFormat formatter = DateFormat('MMM d, yyyy hh:mm a');
      return formatter.format(time);
    }

    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        //* the textInput widget does not move up in ios
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.92,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: StreamBuilder(
              stream: MessageService.getMessages(widget.chatRoom.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                  return const Center(
                    child: Text("No messages yet"),
                  );
                } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                  // mark all messages as read
                  MessageService.markMessagesAsRead(widget.chatRoom.id);
                  log("Data: ${snapshot.data.docs.length}");
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Message message =
                          Message.fromMap(snapshot.data.docs[index].data());
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: MessageTile(
                            message: message.message,
                            isSender:
                                message.senderId == authNotifier.appUser!.uid,
                            time: formattedTime(message.time),
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
            sendMessage: () {
              sendMessage();
            },
          ),
        ],
      ),
    ));
  }
}
