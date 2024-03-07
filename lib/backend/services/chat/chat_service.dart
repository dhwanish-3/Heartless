import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';

class ChatService {
  static final _chatRoomRef =
      FirebaseFirestore.instance.collection("ChatRooms");
  static const Duration _timeLimit = Duration(seconds: 10);

  // get all the chats of the current user
  static Stream<QuerySnapshot> getChatRooms() {
    return _chatRoomRef
        .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  // check if a chat exists
  static Future<ChatRoom?> chatExists(String chatId) async {
    try {
      DocumentSnapshot chat =
          await _chatRoomRef.doc(chatId).get().timeout(_timeLimit);
      return chat.exists
          ? ChatRoom.fromMap(chat.data()! as Map<String, dynamic>)
          : null;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // update the online status of the user
  static Future<void> updateOnlineStatus(
      String uid, bool isOnline, UserType userType) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .update({'isOnline': isOnline}).timeout(_timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // update the last seen of the user
  static Future<void> updateLastSeen(
      String uid, DateTime lastSeen, UserType userType) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .update({'lastSeen': lastSeen.toString()}).timeout(_timeLimit);
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // create a new chat room
  static Future<ChatRoom> createChatRoom(ChatRoom chatRoom) async {
    try {
      await _chatRoomRef
          .doc(chatRoom.id)
          .set(chatRoom.toMap())
          .timeout(_timeLimit);
      return chatRoom;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // delete a chat room
  static Future<bool> deleteChatRoom(String chatId) async {
    try {
      await _chatRoomRef.doc(chatId).delete().timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // get the last message of a chat
  static Stream<QuerySnapshot> getLastMessage(String chatId) {
    return _chatRoomRef
        .doc(chatId)
        .collection("Messages")
        .orderBy('time', descending: true)
        .limit(1)
        .snapshots();
  }
}
