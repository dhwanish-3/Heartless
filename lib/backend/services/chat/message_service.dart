import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heartless/services/exceptions/app_exceptions.dart';
import 'package:heartless/shared/models/message.dart';

class MessageService {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _fireStore = FirebaseFirestore.instance.collection("ChatRooms");
  static const Duration _timeLimit = Duration(seconds: 10);

  // get all the messages of a chat
  Stream<Message> getMessages(String chatId) {
    return _fireStore
        .doc(chatId)
        .collection('messages')
        .orderBy('time')
        .limit(30)
        .snapshots()
        .map((event) => Message.fromMap(event.docs.first.data()));
  }

  // send a new message
  Future<Message> sendMessage(String chatId, Message message) async {
    try {
      // getting the reference of the chat to get id
      DocumentReference messageRef =
          _fireStore.doc(chatId).collection('messages').doc();
      message.id = messageRef.id;
      await messageRef.set(message.toMap()).timeout(_timeLimit);
      return message;
    } on FirebaseAuthException {
      throw UnAutherizedException();
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ApiNotRespondingException('Server is not responding');
    }
  }

  // delete a message
  Future<bool> deleteMessage(String chatId, String messageId) async {
    try {
      await _fireStore
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .delete()
          .timeout(_timeLimit);
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
  Future<Message> editMessage(String chatId, Message message) async {
    try {
      await _fireStore
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
