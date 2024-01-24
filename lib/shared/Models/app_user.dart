enum UserType { patient, nurse, doctor }

// convert enum to string
String userTypeToString(UserType userType) {
  switch (userType) {
    case UserType.patient:
      return 'patient';
    case UserType.nurse:
      return 'nurse';
    case UserType.doctor:
      return 'doctor';
    default:
      return 'patient';
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
}
