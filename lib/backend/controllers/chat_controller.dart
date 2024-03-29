import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/controllers/connect_users_controller.dart';
import 'package:heartless/backend/services/chat/chat_service.dart';
import 'package:heartless/backend/services/chat/message_service.dart';
import 'package:heartless/backend/services/firebase_storage/firebase_storage_service.dart';
import 'package:heartless/services/enums/message_type.dart';
import 'package:heartless/services/enums/user_type.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';

class ChatController with BaseController {
  // to get all chat rooms
  static Stream<QuerySnapshot> getChatRooms() {
    return ChatService.getChatRooms();
  }

  // to check if a chat exists if exists return the chat room
  static Future<ChatRoom?> chatExists(String chatId) {
    // ! no need handle success and error here
    return ChatService.chatExists(chatId);
  }

  static String getChatRoomId(AppUser user1, AppUser user2) {
    if (user1.uid.hashCode <= user2.uid.hashCode) {
      return '${user1.uid}_${user2.uid}';
    } else {
      return '${user2.uid}_${user1.uid}';
    }
  }

  // to create a new chat room or return the existing chat room
  Future<ChatRoom?> createChatRoom(AppUser me, AppUser user) async {
    // check if the chat room already exists
    String chatId = getChatRoomId(me, user);
    ChatRoom? chatRoom = await chatExists(chatId);
    if (chatRoom != null) {
      return chatRoom;
    }

    // create a new chat since it does not exist
    DocumentReference<Map<String, dynamic>> meRef =
        FirebaseFirestore.instance.collection('Users').doc(me.uid);
    DocumentReference<Map<String, dynamic>> other =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    chatRoom = ChatRoom(meRef, other);
    chatRoom.id = chatId;
    // creating the chat room
    bool success = await ChatService.createChatRoom(chatRoom).then((value) {
      return handleSuccess(true, "Chat Room Created Successfully");
    }).catchError((error) {
      return handleError(error);
    });
    if (success) {
      return chatRoom;
    } else {
      return null;
    }
  }

  // to delete a chat room
  Future<bool> deleteChatRoom(String chatId) {
    return ChatService.deleteChatRoom(chatId)
        .then((value) => handleSuccess(value, "Chat Room Deleted Successfully"))
        .catchError((error) => handleError(error));
  }

  // to update the online status of the user
  static Future<void> updateOnlineStatus(
      String uid, bool isOnline, UserType userType) {
    return ChatService.updateOnlineStatus(uid, isOnline, userType);
  }

  // to update the last seen of the user
  static Future<void> updateLastSeen(
      String uid, DateTime time, UserType userType) {
    return ChatService.updateLastSeen(uid, time, userType);
  }

  // to get the last message in a chat room
  static Stream<QuerySnapshot> getLastMessage(String chatId) {
    return ChatService.getLastMessage(chatId);
  }

  /* Message services */

  // to get all the messages in a chat room
  static Stream<QuerySnapshot> getMessages(String chatId) {
    return MessageService.getMessages(chatId);
  }

  // to send a message
  Future<bool> sendMessage(
      ChatRoom chatRoom, String senderId, String description,
      {File? file}) {
    Message message = Message();
    message.message = description;
    message.senderId = senderId;
    message.time = DateTime.now();
    message.receiverId = chatRoom.user1Ref!.id == senderId
        ? chatRoom.user2Ref!.id
        : chatRoom.user1Ref!.id;
    // if file is not null then it is an image
    if (file != null) {
      message.type = messageTypeFromExtension(file.path.split('.').last);
      if (message.type == MessageType.document) {
        message.message = file.path.split("/").last;
      }
      return FirebaseStorageService.uploadFile(chatRoom.id, file).then((value) {
        message.imageUrl = value;
        return MessageService.sendMessage(chatRoom, message)
            .then((value) => handleSuccess(true, "Message Sent"))
            .catchError((error) => handleError(error));
      }).catchError((error) => handleError(error));
    } else {
      message.type = MessageType.text;
      return MessageService.sendMessage(chatRoom, message)
          .then((value) => handleSuccess(true, "Message Sent"))
          .catchError((error) => handleError(error));
    }
  }

  // to delete a message
  Future<bool> deleteMessage(
      ChatRoom chatRoom, Message message, String userId) {
    // future implementation: delete only possible if message is unread
    // message only can be deleted by the sender
    if (message.senderId != userId) {
      return Future.value(false);
    }
    if (message.imageUrl != null) {
      // delete the image from storage
      FirebaseStorageService.deleteImage(message.imageUrl!);
    }

    return MessageService.deleteMessage(chatRoom, message)
        .then((value) => handleSuccess(true, "Message Deleted"))
        .catchError((error) => handleError(error));
  }

  // to edit a message
  Future<bool> editMessage(String chatId, Message message) {
    return MessageService.editMessage(chatId, message)
        .then((value) => handleSuccess(true, "Message Edited"))
        .catchError((error) => handleError(error));
  }

  // to mark all messages as read
  static Future<bool> markMessagesAsRead(ChatRoom chatRoom) {
    return MessageService.markMessagesAsRead(chatRoom);
  }

  // to get all chat users
  static Future<List<AppUser>> getChatUsers(UserType userType, String userId) {
    if (userType == UserType.patient) {
      return ConnectUsersController.getAllUsersConnectedToPatient(userId);
    } else if (userType == UserType.doctor) {
      return ConnectUsersController.getAllUsersConnectedToDoctor(userId);
    } else {
      return ConnectUsersController.getAllUsersConnectedToNurse(userId);
    }
  }
}
