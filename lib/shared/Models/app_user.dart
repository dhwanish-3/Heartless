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
  int unreadMessages = 0;
  bool isOnline = false;
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
    unreadMessages = map['unreadMessages'] ?? 0;
    isOnline = map['isOnline'] ?? false;
    lastSeen = map['lastSeen'].toDate();
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
      'unreadMessages': unreadMessages,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
    };
  }
}
