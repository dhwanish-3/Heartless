enum UserType { patient, nurse, doctor }

class AppUser {
  String uid = '';
  String email = '';
  String name = '';
  String imageUrl = '';
  String phone = '';
  String password = '';

  UserType userType = UserType.patient;

  AppUser();
}
