import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/Models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';

class MessageService {
  static final _chatRoomRef =
      FirebaseFirestore.instance.collection("ChatRooms");
  static const Duration _timeLimit = Duration(seconds: 10);

  // get all the messages of a chat
  static Stream<QuerySnapshot> getMessages(String chatId) {
    return _chatRoomRef
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .limit(30)
        .snapshots();
  }

  // send a new message
  static Future<Message> sendMessage(String chatId, Message message) async {
    try {
      // getting the reference of the chat to get id
      DocumentReference messageRef =
          _chatRoomRef.doc(chatId).collection('messages').doc();
      message.id = messageRef.id;
      await messageRef.set(message.toMap()).timeout(_timeLimit);

      // increment the count of unread messages for the receiver
      await _chatRoomRef.doc(chatId).get().then((value) async {
        if (value.exists) {
          if (value.data() != null) {
            DocumentReference user1Ref = value.data()!['user1Ref'];
            DocumentReference user2Ref = value.data()!['user2Ref'];
            if (user1Ref.id == message.receiverId) {
              await user1Ref.update({
                'unreadMessages': FieldValue.increment(1),
              });
            } else if (user2Ref.id == message.receiverId) {
              await user2Ref.update({
                'unreadMessages': FieldValue.increment(1),
              });
            }
          }
        }
      });
      return message;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // mark all messages as read
  static Future<bool> markMessagesAsRead(String chatId) async {
    try {
      await _chatRoomRef.doc(chatId).get().then((value) async {
        if (value.exists) {
          if (value.data() != null) {
            DocumentReference user1Ref = value.data()!['user1Ref'];
            DocumentReference user2Ref = value.data()!['user2Ref'];
            // update the count of unread messages for the receiver
            if (user1Ref.id == FirebaseAuth.instance.currentUser!.uid) {
              await user1Ref.update({
                'unreadMessages': 0,
              });
            } else if (user2Ref.id == FirebaseAuth.instance.currentUser!.uid) {
              await user2Ref.update({
                'unreadMessages': 0,
              });
            }
          }
        }
      });
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // delete a message
  static Future<bool> deleteMessage(ChatRoom chatRoom, Message message) async {
    try {
      // deleting the message
      await _chatRoomRef
          .doc(chatRoom.id)
          .collection('messages')
          .doc(message.id)
          .delete()
          .timeout(_timeLimit);

      // update the count of unread messages for the receiver
      // getting the user's details in the chat
      AppUser user1 = await chatRoom.getUser1();
      AppUser user2 = await chatRoom.getUser2();
      // decrement the count of unread messages for the receiver only if the message is unread
      if (user1.uid == message.receiverId && user1.unreadMessages > 0) {
        await chatRoom.user1Ref!.update({
          'unreadMessages': FieldValue.increment(-1),
        });
      } else if (user2.uid == message.receiverId && user2.unreadMessages > 0) {
        await chatRoom.user2Ref!.update({
          'unreadMessages': FieldValue.increment(-1),
        });
      }
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // edit a message
  static Future<Message> editMessage(String chatId, Message message) async {
    try {
      await _chatRoomRef
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .update(message.toMap())
          .timeout(_timeLimit);
      return message;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }
}
