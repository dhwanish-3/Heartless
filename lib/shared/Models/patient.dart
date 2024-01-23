import 'package:heartless/shared/Models/app_user.dart';

class Patient extends AppUser {
  List<String> nurses = [];
  List<String> doctors = [];

  Patient() {
    userType = UserType.patient;
    // todo: add a default image for patient
    imageUrl = 'https://i.imgur.com/BoN9kdC.png';
  }

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
