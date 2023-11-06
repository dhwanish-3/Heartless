class Patient {
  String uid = '';
  String name = 'hari';
  String imageUrl = 'https://i.imgur.com/BoN9kdC.png';
  String? email = 'harikrishnannavath@gmail.com';
  String? phone;
  String? password;

  Patient();

  // named constructor
  Patient.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    imageUrl = map['imageUrl'];
    email = map['email'];
    phone = map['phone'];
    password = map['password'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}
