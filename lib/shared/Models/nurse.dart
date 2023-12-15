class Nurse {
  String uid = '';
  String name = 'chechi';
  // todo: add a default image for nurse
  String imageUrl = 'https://i.imgur.com/BoN9kdC.png';
  String email = '';
  String phone = '';
  String password = '';
  List<String> patients = []; // list of patients handled
  List<String> doctors = []; // list of doctors reporting

  Nurse();

  Nurse.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    imageUrl = map['imageUrl'];
    email = map['email'];
    phone = map['phone'];
    password = map['password'];
    patients = map['patients'] is Iterable ? List.from(map['patients']) : [];
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
      'patients': patients,
      'doctors': doctors,
    };
  }
}
