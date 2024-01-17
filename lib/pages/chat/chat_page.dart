import 'package:flutter/material.dart';
import 'package:heartless/shared/constants.dart';
import 'package:heartless/widgets/message_tile.dart';
import 'package:heartless/widgets/msg_input_field.dart';
import 'package:heartless/widgets/text_input.dart';

const data = [
  {"message": "Hello", "isSender": true, "time": "9:00 AM"},
  {"message": "How are you My dear", "isSender": false, "time": "9:00 AM"},
  {"message": "I am fine", "isSender": true, "time": "9:00 AM"},
  {
    "message": "Now this is a message that is long enough",
    "isSender": false,
    "time": "9:00 AM"
  },
  {
    "message": "This is also a messgage that could go beyond the screen",
    "isSender": true,
    "time": "9:00 AM"
  },
  {
    "message": '''How are you My dear
Now this has gone beyound one line''',
    "isSender": false,
    "time": "9:00 AM"
  },
  {"message": "a", "isSender": true, "time": "9:00 AM"},
  {"message": "a", "isSender": false, "time": "9:00 AM"},
  {
    "message": '''
this is a long message that is going to go beyond the screen
this is a long message that is going to go beyond the screen''',
    "isSender": true,
    "time": "11:00 PM"
  },
  {
    "message": "Now consecutive message from sender",
    "isSender": true,
    "time": "11:00 PM"
  },
  {"message": "I am fine", "isSender": true, "time": "11:00 PM"},
  {"message": "How are you My dear", "isSender": false, "time": "11:00 PM"},
  {
    "message": "consecutive messafe from the other side",
    "isSender": false,
    "time": "11:00 PM"
  },
  {"message": "I am fine", "isSender": false, "time": "11:00 PM"},
  {"message": "I am fine", "isSender": true, "time": "11:00 PM"},
];

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        //* the textInput widget does not move up in ios
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.92,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final entry = data[index];
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: MessageTile(
                      message: entry['message'].toString(),
                      isSender: entry['isSender'] as bool,
                      time: entry['time'].toString(),
                    ));
              },
            ),
          ),
          const MessageField(),
        ],
      ),
    ));
  }
}
