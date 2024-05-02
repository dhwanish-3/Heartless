class Diary {
  String id = '';
  String title = '';
  String body = '';
  String patientId = '';
  DateTime time = DateTime.now();
  Diary(
      {required this.title,
      required this.body,
      required this.patientId,
      required this.time});

  Diary.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    body = data['body'];
    patientId = data['patientId'];
    time = data['time'].toDate(); // Convert Timestamp to DateTime
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'patientId': patientId,
      'time': time // Convert DateTime to Timestamp done by Firestore
    };
  }
}
