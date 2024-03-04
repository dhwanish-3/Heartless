class Diary {
  String id = '';
  String title = '';
  String body = '';
  DateTime dateCreated = DateTime.now();
  Diary({required this.title, required this.body, required this.dateCreated});

  Diary.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    body = data['body'];
    dateCreated = data['dateCreated'].toDate(); // Convert Timestamp to DateTime
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'dateCreated':
          dateCreated // Convert DateTime to Timestamp done by Firestore
    };
  }
}
