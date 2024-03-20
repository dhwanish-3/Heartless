import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/services/date/date_service.dart';
import 'package:heartless/services/enums/message_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/widgets/chat/chat_tile.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    // updating the online status of the current user
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    ChatController.updateOnlineStatus(
        authNotifier.appUser!.uid, true, authNotifier.appUser!.userType);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    // calculating the number of unread messages for the current user fot a particular chatRoom
    int calculateUnreadMessagesCount(ChatRoom chatRoom) {
      if (chatRoom.user1Ref!.id == authNotifier.appUser!.uid) {
        return chatRoom.user1UnreadMessages;
      } else {
        return chatRoom.user2UnreadMessages;
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

    return WillPopScope(
      onWillPop: () async {
        // updating the online status of the current user
        ChatController.updateOnlineStatus(
            authNotifier.appUser!.uid, false, authNotifier.appUser!.userType);
        // updating the last seen of the current user
        ChatController.updateLastSeen(authNotifier.appUser!.uid, DateTime.now(),
            authNotifier.appUser!.userType);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: StreamBuilder(
          stream: ChatController.getChatRooms(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && snapshot.data.docs.isEmpty) {
              return const Center(
                child: Text('No chats yet'),
              );
            } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  ChatRoom chatRoom =
                      ChatRoom.fromMap(snapshot.data.docs[index].data());
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
                                  stream: ChatController.getLastMessage(
                                      chatRoom.id),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    //* if the chat room has no messages
                                    if (snapshot.hasData &&
                                        snapshot.data.docs.isEmpty) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPage(
                                                        chatRoom: chatRoom,
                                                        chatUser: user1.uid ==
                                                                authNotifier
                                                                    .appUser!
                                                                    .uid
                                                            ? user2
                                                            : user1,
                                                      )));
                                        },
                                        child: ChatTile(
                                          imageUrl: getImageUrl(user1, user2),
                                          name: getChatUserName(user1,
                                              user2), // chatRoom.other.name,
                                          time: "",
                                          latestMessage: "Say Hii! 👋",
                                          unreadMessages:
                                              calculateUnreadMessagesCount(
                                                  chatRoom),
                                        ),
                                      );
                                    } else if (snapshot.hasData &&
                                        snapshot.data.docs.isNotEmpty) {
                                      Message message = Message.fromMap(
                                          snapshot.data.docs[0].data());
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPage(
                                                        chatRoom: chatRoom,
                                                        chatUser: user1.uid ==
                                                                authNotifier
                                                                    .appUser!
                                                                    .uid
                                                            ? user2
                                                            : user1,
                                                      )));
                                        },
                                        child: ChatTile(
                                          name: getChatUserName(user1,
                                              user2), // chatRoom.other.name,
                                          imageUrl: getImageUrl(user1, user2),
                                          time: DateService
                                              .getRelativeDateWithTime(
                                                  message.time),
                                          latestMessage:
                                              message.type == MessageType.image
                                                  ? "Image"
                                                  : message.message,
                                          unreadMessages:
                                              calculateUnreadMessagesCount(
                                                  chatRoom),
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
      ),
    );
  }
}
