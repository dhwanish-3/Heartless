import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/backend/services/notifications/notification_services.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
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
        .collection('Messages')
        .orderBy('time')
        .limit(30)
        .snapshots();
  }

  // send a new message
  static Future<Message> sendMessage(ChatRoom chatRoom, Message message) async {
    try {
      // getting the reference of the chat to get id
      DocumentReference messageRef =
          _chatRoomRef.doc(chatRoom.id).collection('Messages').doc();
      message.id = messageRef.id;
      await messageRef.set(message.toMap()).timeout(_timeLimit);
      // increment the count of unread messages for the receiver
      const pushToken =
          'cCjBLsalSLapp-Cksbvsu3:APA91bHAvgoaUCs19OMx87bMYO2_WkFz68cUPfnSMGGdoS7tJ5Fxh8rXorE2TdysvA5czP7wsWvfPMC5-Mgnr0OCD8VyNC1SIB_7K47nJs3BEUfi0DDW2ORLnjR_J9g78aswTCzCxSBQ';
      if (message.receiverId == chatRoom.user1Ref!.id) {
        NotificationServices.sendPushNotification(
            pushToken, chatRoom.user1Ref!.id, message.message);
        chatRoom.user1UnreadMessages++;
        _chatRoomRef.doc(chatRoom.id).update({
          'user1UnreadMessages': FieldValue.increment(1),
        });
      } else if (message.receiverId == chatRoom.user2Ref!.id) {
        NotificationServices.sendPushNotification(
            pushToken, chatRoom.user2Ref!.id, message.message);
        chatRoom.user2UnreadMessages++;
        _chatRoomRef.doc(chatRoom.id).update({
          'user2UnreadMessages': FieldValue.increment(1),
        });
      }
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
  static Future<bool> markMessagesAsRead(ChatRoom chatRoom) async {
    try {
      // update the count of unread messages for the current user
      if (FirebaseAuth.instance.currentUser!.uid == chatRoom.user1Ref!.id) {
        chatRoom.user1UnreadMessages = 0;
        await _chatRoomRef.doc(chatRoom.id).update({
          'user1UnreadMessages': 0,
        });
      } else if (FirebaseAuth.instance.currentUser!.uid ==
          chatRoom.user2Ref!.id) {
        chatRoom.user2UnreadMessages = 0;
        await _chatRoomRef.doc(chatRoom.id).update({
          'user2UnreadMessages': 0,
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

  // delete a message
  static Future<bool> deleteMessage(ChatRoom chatRoom, Message message) async {
    try {
      // deleting the message
      await _chatRoomRef
          .doc(chatRoom.id)
          .collection('Messages')
          .doc(message.id)
          .delete()
          .timeout(_timeLimit);

      // decrement the count of unread messages for the receiver only if the message is unread
      if (chatRoom.user1Ref!.id == message.receiverId &&
          chatRoom.user1UnreadMessages > 0) {
        chatRoom.user1UnreadMessages--;
        await _chatRoomRef.doc(chatRoom.id).update({
          'user1UnreadMessages': FieldValue.increment(-1),
        });
      } else if (chatRoom.user2Ref!.id == message.receiverId &&
          chatRoom.user2UnreadMessages > 0) {
        chatRoom.user2UnreadMessages--;
        await _chatRoomRef.doc(chatRoom.id).update({
          'user2UnreadMessages': FieldValue.increment(-1),
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
          .collection('Messages')
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
