import 'package:flutter/material.dart';
import 'package:heartless/backend/services/chat/chat_service.dart';
import 'package:heartless/pages/chat/select_chat.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/widgets/chat/chat_tile.dart';

const data = [
  {
    "name": 'Dr AnilKumar Dr Anilkumar Anilkumar Anilkumar',
    "time": '9:00 AM',
    "latestMessage":
        "Did you have dinner. If not do you want to have it with me some time or the other",
    "unreadMessages": 3
  },
];

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    // navigation to create new chat page
    void onPressed() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SelectChatPage()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      // body: ListView.builder(
      //   itemCount: data.length,
      //   itemBuilder: (context, index) {
      //     final entry = data[index];
      //     return ChatTile(
      //       name: entry['name'].toString(),
      //       time: entry['time'].toString(),
      //       latestMessage: entry['latestMessage'].toString(),
      //       unreadMessages: entry['unreadMessages'] as int,
      //     );
      //   },
      // ),
      body: StreamBuilder(
        stream: ChatService.getChatRooms(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                ChatUser chatUser = ChatUser.fromMap(snapshot.data.docs[index]);
                return ChatTile(
                  name: chatUser.name,
                  time: '9:00 AM',
                  latestMessage:
                      'Did you have dinner. If not do you want to have it with me some time or the other',
                  unreadMessages: 3,
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
