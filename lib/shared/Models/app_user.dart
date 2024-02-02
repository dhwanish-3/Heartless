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
    case 'patient':
      return UserType.patient;
    case 'nurse':
      return UserType.nurse;
    case 'doctor':
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

  UserType userType = UserType.patient;

  AppUser();

  AppUser.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    imageUrl = map['imageUrl'];
    email = map['email'];
    phone = map['phone'];
    password = map['password'];
    userType = stringToUserType(map['userType']);
  }
}
