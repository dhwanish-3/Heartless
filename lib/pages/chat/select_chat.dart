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
    if (widgetNotifier.userType == UserType.patient) {
      ConnectUsersController.getAllUsersConnectedToPatient(
              authNotifier.patient!.uid)
          .then((value) {
        log(value.toString());
        setState(() {
          users = value;
        });
      });
    } else if (widgetNotifier.userType == UserType.doctor) {
      ConnectUsersController.getAllUsersConnectedToDoctor(
              authNotifier.doctor!.uid)
          .then((value) {
        log(value.toString());
        setState(() {
          users = value;
        });
      });
    } else if (widgetNotifier.userType == UserType.nurse) {
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
      // check if chat already exists
      if (await ChatService.chatExists(
          '${authNotifier.patient!.uid}_${user.uid}')) {
        goToChat('${authNotifier.patient!.uid}_${user.uid}');
        return;
      } else if (await ChatService.chatExists(
          '${user.uid}_${authNotifier.patient!.uid}')) {
        goToChat('${user.uid}_${authNotifier.patient!.uid}');
        return;
      }
      // create a new chat
      ChatUser me = ChatUser();
      me.id = authNotifier.patient!.uid;
      me.name = authNotifier.patient!.name;
      me.imageUrl = authNotifier.patient!.imageUrl;
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
