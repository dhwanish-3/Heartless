import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/Models/app_user.dart';

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

  // function to get user1 data
  Future<AppUser> getUser1() async {
    DocumentSnapshot<Map<String, dynamic>> user1Snapshot =
        await user1Ref!.get();
    return AppUser.fromMap(user1Snapshot.data()!);
  }

  // function to get user2 data
  Future<AppUser> getUser2() async {
    DocumentSnapshot<Map<String, dynamic>> user2Snapshot =
        await user2Ref!.get();
    return AppUser.fromMap(user2Snapshot.data()!);
  }

  // function to get user1 stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser1Stream() {
    return user1Ref!.snapshots();
  }

  // function to get user2 stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser2Stream() {
    return user2Ref!.snapshots();
  }
}
