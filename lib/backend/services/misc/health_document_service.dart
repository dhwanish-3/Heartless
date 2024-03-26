import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/shared/models/health_document.dart';

class HealthDocumentService {
  static CollectionReference<Map<String, dynamic>> _getHealthCollection(
      String patientId) {
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
      await documentReference.set(healthDocument.toMap());
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
    return _getHealthCollection(patientId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<List<HealthDocument>> getHealthDocumentsList(String patientId,
      {int? limit}) async {
    return await _getHealthCollection(patientId)
        .orderBy('createdAt', descending: true)
        .limit(limit ?? 30)
        .get()
        .then((value) =>
            value.docs.map((e) => HealthDocument.fromMap(e.data())).toList());
  }
}
