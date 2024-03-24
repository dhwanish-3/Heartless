import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heartless/backend/controllers/base_controller.dart';
import 'package:heartless/backend/services/firebase_storage/firebase_storage_service.dart';
import 'package:heartless/backend/services/misc/health_document_service.dart';
import 'package:heartless/services/enums/custom_file_type.dart';
import 'package:heartless/services/enums/event_tag.dart';
import 'package:heartless/shared/models/health_document.dart';

class HealthDocumentController with BaseController {
  // add a health document
  Future<void> addHealthDocument(String patientId, String name,
      CustomFileType fileType, List<EventTag> tags, File file) async {
    // uploading the file and getting its url
    String url = await FirebaseStorageService.uploadFile(patientId, file);
    // creating the health document
    HealthDocument healthDocument = HealthDocument(
      name: name,
      customFileType: fileType,
      tags: tags,
      url: url,
      createdAt: DateTime.now(),
    );

    // adding the health document
    await HealthDocumentService.addHealthDocument(patientId, healthDocument)
        .then((value) => handleSuccess(true, 'Added Health Document'))
        .catchError((error) => handleError(error));
  }

  // change the file of a health document
  Future<void> changeHealthDocumentFile(
      String patientId, HealthDocument healthDocument, File file) async {
    // deleting the old file
    await FirebaseStorageService.deleteImage(healthDocument.url);
    // uploading the file and getting its url
    String url = await FirebaseStorageService.uploadFile(patientId, file);
    // updating the health document
    healthDocument.url = url;
    healthDocument.createdAt = DateTime.now();
    await HealthDocumentService.editHealthDocument(patientId, healthDocument)
        .then((value) => handleSuccess(true, 'Changed Health Document File'))
        .catchError((error) => handleError(error));
  }

  // change the tags of a health document
  Future<void> changeEventTags(String patientId, HealthDocument healthDocument,
      List<EventTag> tags) async {
    // updating the health document
    healthDocument.tags = tags;
    healthDocument.createdAt = DateTime.now();
    await HealthDocumentService.editHealthDocument(patientId, healthDocument)
        .then((value) => handleSuccess(true, 'Changed Health Document Tags'))
        .catchError((error) => handleError(error));
  }

  // edit a health document
  Future<void> editHealthDocument(
      String patientId, HealthDocument healthDocument) async {
    healthDocument.createdAt = DateTime.now();
    await HealthDocumentService.editHealthDocument(patientId, healthDocument)
        .then((value) => handleSuccess(true, 'Edited Health Document'))
        .catchError((error) => handleError(error));
  }

  // delete a health document
  Future<void> deleteHealthDocument(
      String patientId, HealthDocument healthDocument) async {
    await HealthDocumentService.deleteHealthDocument(patientId, healthDocument)
        .then((value) => handleSuccess(true, 'Deleted Health Document'))
        .catchError((error) => handleError(error));
  }

  // get all health documents
  static Stream<QuerySnapshot<Map<String, dynamic>>> getHealthDocuments(
      String patientId) {
    return HealthDocumentService.getHealthDocuments(patientId);
  }

  static Future<List<HealthDocument>> getHealthDocumentsList(String patientId,
      {int? limit}) async {
    return await HealthDocumentService.getHealthDocumentsList(patientId,
        limit: limit);
  }
}
