import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/shared/models/app_user.dart';

class ConnectUsersController {
  // Method to get all patients handled by a nurse or doctor
  static Future<List<AppUser>> getAllPatientsHandledByUser(
      String userId, UserType userType) async {
    List<AppUser> patients = [];
    if (userType == UserType.doctor) {
      await ConnectUsers.getDoctorPatients(userId).then((value) {
        patients.addAll(value);
      });
    } else if (userType == UserType.nurse) {
      await ConnectUsers.getNursePatients(userId).then((value) {
        patients.addAll(value);
      });
    }
    return patients;
  }

  // Method to get all nurses and doctors related to a patient
  static Future<List<AppUser>> getAllUsersConnectedToPatient(
      String patientId) async {
    List<AppUser> users = [];
    await ConnectUsers.getPatientDoctors(patientId).then((value) {
      users.addAll(value);
    });
    await ConnectUsers.getPatientNurses(patientId).then((value) {
      users.addAll(value);
    });
    return users;
  }

  // Method to get all patients and nurses related to a doctor
  static Future<List<AppUser>> getAllUsersConnectedToDoctor(
      String doctorId) async {
    List<AppUser> users = [];
    await ConnectUsers.getDoctorPatients(doctorId).then((value) {
      users.addAll(value);
    });
    await ConnectUsers.getDoctorNurses(doctorId).then((value) {
      users.addAll(value);
    });
    return users;
  }

  // Method to get all patients and doctors related to a nurse
  static Future<List<AppUser>> getAllUsersConnectedToNurse(
      String nurseId) async {
    List<AppUser> users = [];
    await ConnectUsers.getNursePatients(nurseId).then((value) {
      users.addAll(value);
    });
    await ConnectUsers.getNurseDoctors(nurseId).then((value) {
      users.addAll(value);
    });
    return users;
  }
}
