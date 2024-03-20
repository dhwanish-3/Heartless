import 'package:heartless/backend/controllers/chat_controller.dart';
import 'package:heartless/backend/services/misc/connect_users.dart';
import 'package:heartless/services/enums/user_type.dart';
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

  static Future<void> connectUsers(AppUser user1, AppUser user2) async {
    await ChatController().createChatRoom(user1, user2);
    if ((user1.userType == UserType.doctor &&
        user2.userType == UserType.patient)) {
      await ConnectUsers.connectPatientAndDoctor(
          patientId: user2.uid, doctorId: user1.uid);
    } else if (user1.userType == UserType.patient &&
        user2.userType == UserType.doctor) {
      await ConnectUsers.connectPatientAndDoctor(
          patientId: user1.uid, doctorId: user2.uid);
    }
    // connect nurse and patient
    else if (user1.userType == UserType.nurse &&
        user2.userType == UserType.patient) {
      await ConnectUsers.connectNurseAndPatient(
          patientId: user2.uid, nurseId: user1.uid);
    } else if (user1.userType == UserType.patient &&
        user2.userType == UserType.nurse) {
      await ConnectUsers.connectNurseAndPatient(
          patientId: user1.uid, nurseId: user2.uid);
    }
    // connect doctor and nurse
    else if (user1.userType == UserType.doctor &&
        user2.userType == UserType.nurse) {
      await ConnectUsers.connectDoctorAndNurse(
          doctorId: user1.uid, nurseId: user2.uid);
    } else if (user1.userType == UserType.nurse &&
        user2.userType == UserType.doctor) {
      await ConnectUsers.connectDoctorAndNurse(
          doctorId: user2.uid, nurseId: user1.uid);
    }
  }
}
