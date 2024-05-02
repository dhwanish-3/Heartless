enum UserType { patient, nurse, doctor }

extension UserTypeExtension on UserType {
  String get capitalisedName {
    switch (this) {
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

// convert string to UserType
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
}
