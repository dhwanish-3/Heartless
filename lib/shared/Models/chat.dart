import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/models/app_user.dart';

class ChatRoom {
  String id = '';
  List<String> users = []; // List of user ids for quick access in queries
  // reference to the users in the chat
  DocumentReference<Map<String, dynamic>>? user1Ref;
  DocumentReference<Map<String, dynamic>>? user2Ref;

  ChatRoom(DocumentReference<Map<String, dynamic>> user1,
      DocumentReference<Map<String, dynamic>> user2) {
    user1Ref = user1;
    user2Ref = user2;
    users.add(user1.id);
    users.add(user2.id);
  }

  ChatRoom.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    users = List<String>.from(map['users']);
    user1Ref = map['user1Ref'];
    user2Ref = map['user2Ref'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'users': users,
      'user1Ref': user1Ref,
      'user2Ref': user2Ref,
    };
  }

  // function to get user1 data as AppUser
  AppUser get user1 {
    log("get user 1");
    return AppUser.fromMap(user1Ref!.get().then((value) {
      log(value.data().toString());
      return value.data() as Map<String, dynamic>;
    }) as Map<String, dynamic>);
  }

  // function to get user2 data as AppUser
  AppUser get user2 => AppUser.fromMap(user2Ref!.get().then((value) {
        return value.data() as Map<String, dynamic>;
      }) as Map<String, dynamic>);
}
