import 'package:heartless/shared/Models/app_user.dart';

class Doctor extends AppUser {
  List<String> patients = []; // list of patients handled
  List<String> doctors = []; // list of nurses reporting

  Doctor() {
    userType = UserType.doctor;
    // todo: add a default image for doctor
    imageUrl = 'https://i.imgur.com/BoN9kdC.png';
  }

  Doctor.fromMap(Map<String, dynamic> map) {
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
