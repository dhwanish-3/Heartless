import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectUsers {
  static final _patientRef = FirebaseFirestore.instance.collection('Patients');
  static final _doctorRef = FirebaseFirestore.instance.collection('Doctors');
  static final _nurseRef = FirebaseFirestore.instance.collection('Nurses');

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
