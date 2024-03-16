import 'package:flutter/material.dart';
import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/main.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

class SelectChatPage extends StatefulWidget {
  const SelectChatPage({super.key});

  @override
  State<SelectChatPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SelectChatPage> {
  List<AppUser> users = []; // list of users to chat with
  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.userType == UserType.patient) {
      ConnectUsersController.getAllUsersConnectedToPatient(
              authNotifier.appUser!.uid)
          .then((value) {
        setState(() {
          users = value;
        });
      });
    } else if (authNotifier.userType == UserType.doctor) {
      ConnectUsersController.getAllUsersConnectedToDoctor(
              authNotifier.appUser!.uid)
          .then((value) {
        setState(() {
          users = value;
        });
      });
    } else if (authNotifier.userType == UserType.nurse) {
      ConnectUsersController.getAllUsersConnectedToNurse(
              authNotifier.appUser!.uid)
          .then((value) {
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
      ChatRoom? chatRoom =
          await ChatController().createChatRoom(authNotifier, user);
      if (chatRoom != null) {
        goToChat(chatRoom, user);
      }
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
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
      ),
    );
  }
}
