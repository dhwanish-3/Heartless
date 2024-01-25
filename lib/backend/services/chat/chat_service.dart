import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/chat.dart';

class ChatService {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _fireStore = FirebaseFirestore.instance.collection("ChatRooms");
  static const Duration _timeLimit = Duration(seconds: 10);

  // get all the chats of the current user
  Future<List<ChatRoom>> getChatRooms() async {
    try {
      // getting all the chats which have the current user's uid
      QuerySnapshot chats = await _fireStore
          .where('users', arrayContains: _uid)
          .get()
          .timeout(_timeLimit);
      List<ChatRoom> chatList = [];
      for (var chat in chats.docs) {
        chatList.add(ChatRoom.fromMap(chat.data() as Map<String, dynamic>));
      }
      return chatList;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // add a new chat
  Future<ChatRoom> addChatRoom(ChatRoom chatRoom) async {
    try {
      // getting the reference of the chat to get id
      DocumentReference chatRef = _fireStore.doc();
      chatRoom.id = chatRef.id;
      await _fireStore.add(chatRoom.toMap()).timeout(_timeLimit);
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
      await _fireStore.doc(chatId).delete().timeout(_timeLimit);
      return true;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }
}
