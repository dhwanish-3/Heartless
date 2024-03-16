import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/models/health_document.dart';

class HealthDocumentService {
  static _getHealthCollection(String patientId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(patientId)
        .collection('HealthDocuments');
  }

  // add a health document
  static Future<void> addHealthDocument(
      String patientId, HealthDocument healthDocument) async {
    try {
      // get the document reference
      DocumentReference documentReference =
          await _getHealthCollection(patientId).doc();
      // set the document id
      healthDocument.id = documentReference.id;
      await _getHealthCollection(patientId).set(healthDocument.toMap());
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  // edit a health document
  static Future<void> editHealthDocument(
      String patientId, HealthDocument healthDocument) async {
    try {
      if (healthDocument.id.isEmpty) {
        return;
      }
      await _getHealthCollection(patientId)
          .doc(healthDocument.id)
          .update(healthDocument.toMap());
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  // delete a health document
  static Future<void> deleteHealthDocument(
      String patientId, HealthDocument healthDocument) async {
    try {
      if (healthDocument.id.isEmpty) {
        return;
      }
      await _getHealthCollection(patientId).doc(healthDocument.id).delete();
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  // get all health documents
  static Stream<QuerySnapshot<Map<String, dynamic>>> getHealthDocuments(
      String patientId) {
    return _getHealthCollection(patientId).snapshots();
  }
}
