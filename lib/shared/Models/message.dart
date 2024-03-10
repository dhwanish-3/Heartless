enum MessageType { text, image, audio }

enum MessageStatus { sending, delivered, read }

class Message {
  String id = '';
  String senderId = '';
  String receiverId = '';
  String message = '';
  String? imageUrl;
  DateTime time = DateTime.now();
  MessageType type = MessageType.text;
  MessageStatus status = MessageStatus.sending;

  Message();

  Message.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    senderId = map['senderId'];
    receiverId = map['receiverId'];
    message = map['message'];
    imageUrl = map['imageUrl'];
    time = map['time'].toDate(); // Convert Timestamp to DateTime
    type = MessageType.values[map['type']];
    status = MessageStatus.values[map['status']];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'imageUrl': imageUrl,
      'time': time, // Convert DateTime to Timestamp done by Firestore
      'type': type.index,
      'status': status.index,
    };
  }
}
