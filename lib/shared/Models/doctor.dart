import 'package:heartless/shared/models/app_user.dart';

class Doctor extends AppUser {
  List<String> patients = []; // list of patients handled
  List<String> nurses = []; // list of nurses reporting

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
    userType = UserType.values[map['userType']];
    isOnline = map['isOnline'];
    pushToken = map['pushToken'] ?? '';
    lastSeen = DateTime.parse(map['lastSeen'] ?? DateTime.now());
    patients = map['patients'] is Iterable ? List.from(map['patients']) : [];
    nurses = map['nurses'] is Iterable ? List.from(map['nurses']) : [];
  }

  @override
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
      'patients': patients,
      'nurses': nurses,
    };
  }
}
