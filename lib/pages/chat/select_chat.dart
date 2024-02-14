import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
              authNotifier.appUser!.uid)
          .then((value) {
        log(value.toString());
        setState(() {
          users = value;
        });
      });
    } else if (authNotifier.userType == UserType.nurse) {
      ConnectUsersController.getAllUsersConnectedToNurse(
              authNotifier.appUser!.uid)
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
  void goToChat(ChatRoom chatRoom, AppUser chatUser) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatPage(chatRoom: chatRoom, chatUser: chatUser),
        ));
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // create a new chat
    void createNewChat(AppUser user) async {
      ChatRoom? chatRoom = await ChatService.chatExists(
          '${authNotifier.appUser!.uid}_${user.uid}');
      // check if chat already exists
      if (chatRoom != null) {
        goToChat(chatRoom, user);
        return;
      }
      chatRoom = await ChatService.chatExists(
          '${user.uid}_${authNotifier.appUser!.uid}');
      if (chatRoom != null) {
        goToChat(chatRoom, user);
        return;
      }
      // create a new chat
      DocumentReference<Map<String, dynamic>> me = FirebaseFirestore.instance
          .collection('${userTypeToString(authNotifier.userType)}s')
          .doc(authNotifier.appUser!.uid);
      DocumentReference<Map<String, dynamic>> other = FirebaseFirestore.instance
          .collection('${userTypeToString(user.userType)}s')
          .doc(user.uid);
      chatRoom = ChatRoom(me, other);
      chatRoom.id = '${me.id}_${other.id}';
      log(chatRoom.toMap().toString());
      await ChatService().addChatRoom(chatRoom);
      goToChat(chatRoom, user);
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
