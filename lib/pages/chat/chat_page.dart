import 'package:flutter/material.dart';
import 'package:heartless/backend/services/chat/message_service.dart';
import 'package:heartless/shared/models/message.dart';
import 'package:heartless/widgets/chat/message_tile.dart';
import 'package:heartless/widgets/chat/msg_input_field.dart';

const data = [
  {"message": "Hello", "isSender": true, "time": "9:00 AM"},
  {"message": "How are you My dear", "isSender": false, "time": "9:00 AM"},
  {"message": "I am fine", "isSender": true, "time": "9:00 AM"},
  {
    "message": "Now this is a message that is long enough",
    "isSender": false,
    "time": "9:00 AM"
  },
];

class ChatPage extends StatefulWidget {
  final String chatId;
  const ChatPage({super.key, required this.chatId});

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
            // child: ListView.builder(
            //   itemCount: data.length,
            //   itemBuilder: (context, index) {
            //     final entry = data[index];
            //     return Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 5),
            //         child: MessageTile(
            //           message: entry['message'].toString(),
            //           isSender: entry['isSender'] as bool,
            //           time: entry['time'].toString(),
            //         ));
            //   },
            // ),
            child: StreamBuilder(
              stream: MessageService.getMessages(widget.chatId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Message message =
                          Message.fromMap(snapshot.data.docs[index]);
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: MessageTile(
                            message: message.message,
                            isSender: true,
                            time: '9:00 AM',
                          ));
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
          const MessageField(),
        ],
      ),
    ));
  }
}
