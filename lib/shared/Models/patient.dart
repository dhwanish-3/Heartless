class Patient {
  String uid = '';
  String name = 'hari';
  String imageUrl = 'https://i.imgur.com/BoN9kdC.png';
  String email = '';
  String phone = '';
  String password = '';
  List<String> nurses = [];
  List<String> doctors = [];

  Patient();

  Patient.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    imageUrl = map['imageUrl'];
    email = map['email'];
    phone = map['phone'];
    password = map['password'];
    nurses = map['nurses'] is Iterable ? List.from(map['nurses']) : [];
    doctors = map['doctors'] is Iterable ? List.from(map['doctors']) : [];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'phone': phone,
      'password': password,
      'nurses': nurses,
      'doctors': doctors,
    };
  }
}
