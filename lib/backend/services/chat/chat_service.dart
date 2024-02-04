import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
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

  // add a new chat
  Future<ChatRoom> addChatRoom(ChatRoom chatRoom) async {
    try {
      // getting the reference of the chat to get id
      DocumentReference chatRef = _chatRoomRef.doc();
      chatRoom.id = chatRef.id;
      await _chatRoomRef.add(chatRoom.toMap()).timeout(_timeLimit);
      return chatRoom;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // delete a chat
  Future<bool> deleteChatRoom(String chatId) async {
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
