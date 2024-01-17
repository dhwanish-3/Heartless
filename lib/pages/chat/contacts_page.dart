import 'package:flutter/material.dart';
import 'package:heartless/widgets/chat_tile.dart';

const data = [
  {
    "name": 'Dr AnilKumar Dr Anilkumar Anilkumar Anilkumar',
    "time": '9:00 AM',
    "latestMessage":
        "Did you have dinner. If not do you want to have it with me some time or the other",
    "unreadMessages": 3
  },
  {
    "name": 'Dr Hari ',
    "time": '9:00 AM',
    "latestMessage": "Did you have dinner",
    "unreadMessages": 0
  },
  {
    "name": 'Dr Hari ',
    "time": '9:00 AM',
    "latestMessage": "HIiiiiii",
    "unreadMessages": 3
  },
  {
    "name": 'Dr Hari ',
    "time": '9:00 AM',
    "latestMessage": "HIiiiiii",
    "unreadMessages": 3
  },
  {
    "name": 'Dr Hari ',
    "time": '9:00 AM',
    "latestMessage": "HIiiiiii",
    "unreadMessages": 2
  },
  {
    "name": 'Dr AnilKumar ',
    "time": '9:00 AM',
    "latestMessage": "HIiiiiii",
    "unreadMessages": 2
  },
  {
    "name": 'Dr AnilKumar ',
    "time": '9:00 AM',
    "latestMessage": "HIiiiiii",
    "unreadMessages": 0
  },
  {
    "name": "Mr HariKrishnan",
    "time": "11:00 AM",
    "latestMessage": "Wanna hook up",
    "unreadMessages": 0
  },
  {
    "name": 'Dr AnilKumar ',
    "time": '9:00 AM',
    "latestMessage": "HIiiiiii",
    "unreadMessages": 0
  },
  {
    "name": 'Dr AnilKumar Gay',
    "time": '9:00 AM',
    "latestMessage": "HIiiiiii",
    "unreadMessages": 3
  },
  {
    "name": "Dhwanish",
    "time": "12:00 PM",
    "latestMessage": "Shift njekkada",
    "unreadMessages": 2
  }
];

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final entry = data[index];
            print(entry['name']);
            // debugPrint(entry.toString());
            return ChatTile(
              name: entry['name'].toString(),
              time: entry['time'].toString(),
              latestMessage: entry['latestMessage'].toString(),
              unreadMessages: entry['unreadMessages'] as int,
            );
          },
        ));
  }
}
