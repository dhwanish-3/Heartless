import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/models/app_user.dart';
import 'package:heartless/shared/models/doctor.dart';
import 'package:heartless/shared/models/nurse.dart';

class UserDetails {
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
}
