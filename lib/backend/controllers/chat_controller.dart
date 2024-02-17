import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/chat/chat_service.dart';
import 'package:heartless/backend/services/chat/message_service.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/chat.dart';
import 'package:heartless/shared/models/message.dart';
import 'package:heartless/shared/provider/auth_notifier.dart';

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

  // to create a new chat room or return the existing chat room
  Future<ChatRoom?> createChatRoom(
      AuthNotifier authNotifier, AppUser user) async {
    // check if the chat room already exists
    ChatRoom? chatRoom = await ChatController.chatExists(
        '${authNotifier.appUser!.uid}_${user.uid}');
    if (chatRoom != null) {
      return chatRoom;
    }
    chatRoom = await ChatController.chatExists(
        '${user.uid}_${authNotifier.appUser!.uid}');
    if (chatRoom != null) {
      return chatRoom;
    }
    // create a new chat since it does not exist
    DocumentReference<Map<String, dynamic>> me = FirebaseFirestore.instance
        .collection('${userTypeToString(authNotifier.userType)}s')
        .doc(authNotifier.appUser!.uid);
    DocumentReference<Map<String, dynamic>> other = FirebaseFirestore.instance
        .collection('${userTypeToString(user.userType)}s')
        .doc(user.uid);
    chatRoom = ChatRoom(me, other);
    chatRoom.id = '${me.id}_${other.id}';
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
      ChatRoom chatRoom, AuthNotifier authNotifier, String description) {
    Message message = Message();
    message.message = description;
    message.senderId = authNotifier.appUser!.uid;
    message.time = DateTime.now();
    message.receiverId = chatRoom.user1Ref!.id == authNotifier.appUser!.uid
        ? chatRoom.user2Ref!.id
        : chatRoom.user1Ref!.id;
    return MessageService.sendMessage(chatRoom, message)
        .then((value) => handleSuccess(true, "Message Sent Successfully"))
        .catchError((error) => handleError(error));
  }

  // to delete a message
  Future<bool> deleteMessage(ChatRoom chatRoom, Message message) {
    return MessageService.deleteMessage(chatRoom, message)
        .then((value) => handleSuccess(true, "Message Deleted Successfully"))
        .catchError((error) => handleError(error));
  }

  // to edit a message
  Future<bool> editMessage(String chatId, Message message) {
    return MessageService.editMessage(chatId, message)
        .then((value) => handleSuccess(true, "Message Edited Successfully"))
        .catchError((error) => handleError(error));
  }

  // to mark all messages as read
  static Future<bool> markMessagesAsRead(ChatRoom chatRoom) {
    return MessageService.markMessagesAsRead(chatRoom);
  }
}
