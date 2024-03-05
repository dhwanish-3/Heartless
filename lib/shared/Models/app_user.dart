import 'package:heartless/shared/models/doctor.dart';
import 'package:heartless/shared/models/nurse.dart';
import 'package:heartless/shared/models/patient.dart';

enum UserType { patient, nurse, doctor }

// convert enum to string
String userTypeToString(UserType userType) {
  switch (userType) {
    case UserType.patient:
      return 'Patient';
    case UserType.nurse:
      return 'Nurse';
    case UserType.doctor:
      return 'Doctor';
    default:
      return 'Patient';
  }
}

// convert string to enum
UserType stringToUserType(String userType) {
  switch (userType) {
    case 'Patient':
      return UserType.patient;
    case 'Nurse':
      return UserType.nurse;
    case 'Doctor':
      return UserType.doctor;
    default:
      return UserType.patient;
  }
}

class AppUser {
  String uid = '';
  String email = '';
  String name = '';
  String imageUrl = '';
  String? phone;
  String password = '';
  bool isOnline = false;
  String pushToken = '';
  DateTime lastSeen = DateTime.now();
  UserType userType = UserType.patient;

  AppUser();

  AppUser.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    imageUrl = map['imageUrl'];
    email = map['email'];
    phone = map['phone'];
    password = map['password'];
    userType = UserType.values[map['userType']];
    isOnline = map['isOnline'] ?? false;
    pushToken = map['pushToken'] ?? '';
    lastSeen = DateTime.parse(map['lastSeen'] ?? DateTime.now());
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'phone': phone,
      'password': password,
      'userType': userType.index,
      'isOnline': isOnline,
      'pushToken': pushToken,
      'lastSeen': lastSeen.toString(),
    };
  }

  static dynamic getInstance(UserType userType) {
    if (userType == UserType.patient) {
      return Patient();
    } else if (userType == UserType.nurse) {
      return Nurse();
    } else if (userType == UserType.doctor) {
      return Doctor();
    } else {
      return AppUser();
    }
  }

  static dynamic getInstanceFromMap(
      UserType userType, Map<String, dynamic> map) {
    if (userType == UserType.patient) {
      return Patient.fromMap(map);
    } else if (userType == UserType.nurse) {
      return Nurse.fromMap(map);
    } else if (userType == UserType.doctor) {
      return Doctor.fromMap(map);
    } else {
      return AppUser.fromMap(map);
    }
  }
}
