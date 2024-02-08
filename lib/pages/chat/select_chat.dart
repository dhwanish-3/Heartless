import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/backend/services/chat/chat_service.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';
import 'package:heartless/shared/provider/widget_provider.dart';

class SelectChatPage extends StatefulWidget {
  const SelectChatPage({super.key});

  @override
  State<SelectChatPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SelectChatPage> {
  List<AppUser> users = []; // list of users to chat with
  @override
  void initState() {
    WidgetNotifier widgetNotifier =
        Provider.of<WidgetNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.userType == UserType.patient) {
      ConnectUsersController.getAllUsersConnectedToPatient(
              authNotifier.appUser!.uid)
          .then((value) {
        log(value.toString());
        setState(() {
          users = value;
        });
      });
    } else if (authNotifier.userType == UserType.doctor) {
      ConnectUsersController.getAllUsersConnectedToDoctor(
              authNotifier.doctor!.uid)
          .then((value) {
        log(value.toString());
        setState(() {
          users = value;
        });
      });
    } else if (authNotifier.userType == UserType.nurse) {
      ConnectUsersController.getAllUsersConnectedToNurse(
              authNotifier.nurse!.uid)
          .then((value) {
        log(value.toString());
        setState(() {
          users = value;
        });
      });
    }
    super.initState();
  }

  // navigate to chat page
  void goToChat(String chatId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  chatId: chatId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // create a new chat
    void createNewChat(AppUser user) async {
      log("message");
      // check if chat already exists
      if (await ChatService.chatExists(
          '${authNotifier.appUser!.uid}_${user.uid}')) {
        log("one");
        goToChat('${authNotifier.appUser!.uid}_${user.uid}');
        return;
      } else if (await ChatService.chatExists(
          '${user.uid}_${authNotifier.appUser!.uid}')) {
        log("two");
        goToChat('${user.uid}_${authNotifier.appUser!.uid}');
        return;
      }
      // create a new chat
      log("three");
      ChatUser me = ChatUser();
      me.id = authNotifier.appUser!.uid;
      me.name = authNotifier.appUser!.name;
      me.imageUrl = authNotifier.appUser!.imageUrl;
      me.unreadMessages = 0;
      ChatUser other = ChatUser();
      other.id = user.uid;
      other.name = user.name;
      other.imageUrl = user.imageUrl;
      other.unreadMessages = 0;
      ChatRoom chatRoom = ChatRoom(me, other);
      chatRoom.id = '${me.id}_${other.id}';
      log(chatRoom.toMap().toString());
      await ChatService().addChatRoom(chatRoom);
      goToChat(chatRoom.id);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Chat'),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            AppUser user = users[index];
            return ListTile(
              title: Text(user.name),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
              ),
              onTap: () {
                createNewChat(user);
              },
            );
          },
        ));
  }
}
