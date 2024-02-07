import 'package:flutter/material.dart';
import 'package:heartless/backend/services/chat/chat_service.dart';
import 'package:heartless/pages/chat/chat_page.dart';
import 'package:heartless/pages/chat/select_chat.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/widgets/chat/chat_tile.dart';

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
      body: StreamBuilder(
        stream: ChatService.getChatRooms(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData && snapshot.data.docs.isEmpty) {
            return const Center(
              child: Text('No chats yet'),
            );
          } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                // log(snapshot.data.docs[index].data().toString());
                ChatRoom chatRoom =
                    ChatRoom.fromMap(snapshot.data.docs[index].data());
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  chatId: chatRoom.id,
                                )));
                  },
                  child: ChatTile(
                    name: chatRoom.user2!.name, // chatRoom.other.name,
                    time: '9:00 AM',
                    latestMessage:
                        'Did you have dinner. If not do you want to have it with me some time or the other',
                    unreadMessages: 3,
                  ),
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
