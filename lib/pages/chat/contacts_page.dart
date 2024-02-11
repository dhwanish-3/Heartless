import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heartless/backend/services/chat/chat_service.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/pages/chat/select_chat.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/chat/chat_tile.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    void onPressed() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SelectChatPage()));
    }

    // calculating the number of unread messages for the current user fot a particular chatRoom
    int calculateUnreadMessagesCount(ChatRoom chatRoom) {
      if (chatRoom.user1Ref!.id == authNotifier.appUser!.uid) {
        return chatRoom.user1.unreadMessages;
      } else {
        return chatRoom.user2.unreadMessages;
      }
    }

    // getting the name of the chat user
    String getChatUserName(ChatRoom chatRoom) {
      if (chatRoom.user1Ref!.id == authNotifier.appUser!.uid) {
        return chatRoom.user2.name;
      } else {
        return chatRoom.user1.name;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder(
        stream: ChatService.getChatRooms(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data.docs.isEmpty) {
            return const Center(
              child: Text('No chats yet'),
            );
          } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
            log(snapshot.data.docs.length.toString());
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                log(snapshot.data.docs[index].data().toString());
                ChatRoom chatRoom =
                    ChatRoom.fromMap(snapshot.data.docs[index].data());
                log(chatRoom.toMap().toString());
                return StreamBuilder(
                    stream: ChatService.getLastMessage(chatRoom.id),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData && snapshot.data.docs.isEmpty) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          chatRoom: chatRoom,
                                        )));
                          },
                          child: ChatTile(
                            name: getChatUserName(
                                chatRoom), // chatRoom.other.name,
                            time: "",
                            latestMessage: "",
                            unreadMessages:
                                calculateUnreadMessagesCount(chatRoom),
                          ),
                        );
                      }
                      if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                        Message message =
                            Message.fromMap(snapshot.data.docs[0].data());
                        log(message.toMap().toString());
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                          chatRoom: chatRoom,
                                        )));
                          },
                          child: ChatTile(
                            name: getChatUserName(
                                chatRoom), // chatRoom.other.name,
                            time: message.time.toString(),
                            latestMessage: message.message,
                            unreadMessages:
                                calculateUnreadMessagesCount(chatRoom),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    });
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
