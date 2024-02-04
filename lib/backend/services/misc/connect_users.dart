import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/models/app_user.dart';

class ConnectUsers {
  static final _patientRef = FirebaseFirestore.instance.collection('Patients');
  static final _doctorRef = FirebaseFirestore.instance.collection('Doctors');
  static final _nurseRef = FirebaseFirestore.instance.collection('Nurses');

  // get user details from uid
  static Future<AppUser?> getUserDetails(String uid) {
    return _patientRef.doc(uid).get().then((value) {
      if (value.exists && value.data() != null) {
        return AppUser.fromMap(value.data()!);
      } else {
        return _doctorRef.doc(uid).get().then((value) {
          if (value.exists && value.data() != null) {
            return AppUser.fromMap(value.data()!);
          } else {
            return _nurseRef.doc(uid).get().then((value) {
              if (value.exists) {
                return AppUser.fromMap(value.data()!);
              } else {
                return null;
              }
            });
          }
        });
      }
    });
  }

  // get all the nurses related to a doctor
  static Future<List<AppUser>> getDoctorNurses(String doctorId) async {
    List<AppUser> nurses = [];
    await _doctorRef.doc(doctorId).get().then((value) async {
      if (value.exists && value.data() != null) {
        List<String> nurseIds = List<String>.from(value.data()!['nurses']);
        for (var nurseId in nurseIds) {
          await _nurseRef.doc(nurseId).get().then((value) {
            if (value.exists && value.data() != null) {
              nurses.add(AppUser.fromMap(value.data()!));
            }
          });
        }
      }
    });
    return nurses;
  }

  // get all the patients related to a doctor
  static Future<List<AppUser>> getDoctorPatients(String doctorId) async {
    List<AppUser> patients = [];
    await _doctorRef.doc(doctorId).get().then((value) async {
      if (value.exists && value.data() != null) {
        List<String> patientIds = List<String>.from(value.data()!['patients']);
        for (var patientId in patientIds) {
          await _patientRef.doc(patientId).get().then((value) {
            if (value.exists && value.data() != null) {
              patients.add(AppUser.fromMap(value.data()!));
            }
          });
        }
      }
    });
    return patients;
  }

  // get all the patients related to a nurse
  static Future<List<AppUser>> getNursePatients(String nurseId) async {
    List<AppUser> patients = [];
    await _nurseRef.doc(nurseId).get().then((value) async {
      if (value.exists && value.data() != null) {
        List<String> patientIds = List<String>.from(value.data()!['patients']);
        for (var patientId in patientIds) {
          await _patientRef.doc(patientId).get().then((value) {
            if (value.exists && value.data() != null) {
              patients.add(AppUser.fromMap(value.data()!));
            }
          });
        }
      }
    });
    return patients;
  }

  // get all the doctors related to a nurse
  static Future<List<AppUser>> getNurseDoctors(String nurseId) async {
    List<AppUser> doctors = [];
    await _nurseRef.doc(nurseId).get().then((value) async {
      if (value.exists && value.data() != null) {
        List<String> doctorIds = List<String>.from(value.data()!['doctors']);
        for (var doctorId in doctorIds) {
          await _doctorRef.doc(doctorId).get().then((value) {
            if (value.exists && value.data() != null) {
              doctors.add(AppUser.fromMap(value.data()!));
            }
          });
        }
      }
    });
    return doctors;
  }

  // get all the doctors related to a patient
  static Future<List<AppUser>> getPatientDoctors(String patientId) async {
    List<AppUser> doctors = [];
    await _patientRef.doc(patientId).get().then((value) async {
      if (value.exists && value.data() != null) {
        List<String> doctorIds = List<String>.from(value.data()!['doctors']);
        for (var doctorId in doctorIds) {
          await _doctorRef.doc(doctorId).get().then((value) {
            if (value.exists && value.data() != null) {
              doctors.add(AppUser.fromMap(value.data()!));
            }
          });
        }
      }
    });
    return doctors;
  }

  // get all the nurses related to a patient
  static Future<List<AppUser>> getPatientNurses(String patientId) async {
    List<AppUser> nurses = [];
    await _patientRef.doc(patientId).get().then((value) async {
      if (value.exists && value.data() != null) {
        List<String> nurseIds = List<String>.from(value.data()!['nurses']);
        for (var nurseId in nurseIds) {
          await _nurseRef.doc(nurseId).get().then((value) {
            if (value.exists && value.data() != null) {
              nurses.add(AppUser.fromMap(value.data()!));
            }
          });
        }
      }
    });
    return nurses;
  }

  // connect doctor and patient
  static Future<bool> connectPatientAndDoctor(
      {required String patientId, required String doctorId}) async {
    try {
      await _patientRef.doc(patientId).update({
        'doctors': FieldValue.arrayUnion([doctorId])
      });
      await _doctorRef.doc(doctorId).update({
        'patients': FieldValue.arrayUnion([patientId])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // connect nurse and patient
  static Future<bool> connectNurseAndPatient(
      {required String patientId, required String nurseId}) async {
    try {
      await _patientRef.doc(patientId).update({
        'nurses': FieldValue.arrayUnion([nurseId])
      });
      await _nurseRef.doc(nurseId).update({
        'patients': FieldValue.arrayUnion([patientId])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // connect doctor and nurse
  static Future<bool> connectDoctorAndNurse({
    required String doctorId,
    required String nurseId,
  }) async {
    try {
      await _doctorRef.doc(doctorId).update({
        'nurses': FieldValue.arrayUnion([nurseId])
      });
      await _nurseRef.doc(nurseId).update({
        'doctors': FieldValue.arrayUnion([doctorId])
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
