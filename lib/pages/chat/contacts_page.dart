import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heartless/backend/services/chat/chat_service.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/pages/chat/select_chat.dart';
import 'package:heartless/shared/models/app_user.dart';
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
    int calculateUnreadMessagesCount(AppUser user1, AppUser user2) {
      if (user1.uid == authNotifier.appUser!.uid) {
        return user1.unreadMessages;
      } else {
        return user2.unreadMessages;
      }
    }

    // getting the name of the chat user
    String getChatUserName(AppUser user1, AppUser user2) {
      if (user1.uid == authNotifier.appUser!.uid) {
        return user2.name;
      } else {
        return user1.name;
      }
    }

    // getting the image url of the chat user
    String getImageUrl(AppUser user1, AppUser user2) {
      if (user1.uid == authNotifier.appUser!.uid) {
        return user2.imageUrl;
      } else {
        return user1.imageUrl;
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
                  stream: chatRoom.getUser1Stream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot1) {
                    if (snapshot1.hasData) {
                      AppUser user1 = AppUser.fromMap(snapshot1.data.data());
                      return StreamBuilder(
                        stream: chatRoom.getUser2Stream(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot2) {
                          if (snapshot2.hasData) {
                            AppUser user2 =
                                AppUser.fromMap(snapshot2.data.data());
                            return StreamBuilder(
                                stream: ChatService.getLastMessage(chatRoom.id),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.docs.isEmpty) {
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
                                        imageUrl: getImageUrl(user1, user2),
                                        name: getChatUserName(user1,
                                            user2), // chatRoom.other.name,
                                        time: "",
                                        latestMessage: "",
                                        unreadMessages:
                                            calculateUnreadMessagesCount(
                                                user1, user2),
                                      ),
                                    );
                                  }
                                  if (snapshot.hasData &&
                                      snapshot.data.docs.isNotEmpty) {
                                    Message message = Message.fromMap(
                                        snapshot.data.docs[0].data());
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
                                        name: getChatUserName(user1,
                                            user2), // chatRoom.other.name,
                                        imageUrl: getImageUrl(user1, user2),
                                        time: message.time.toString(),
                                        latestMessage: message.message,
                                        unreadMessages:
                                            calculateUnreadMessagesCount(
                                                user1, user2),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
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
