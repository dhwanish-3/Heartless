import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:heartless/services/enums/custom_file_type.dart';

class FirebaseStorageService {
  static FirebaseStorage storage = FirebaseStorage.instance;

  // function to upload image to firebase storage
  static Future<String> uploadFile(String location, File file) async {
    try {
      // getting image file extension
      final String ext = file.path.split('.').last;

      final CustomFileType fileType = customFileTypeFromExtension(ext);

      // storage file ref with path
      final Reference ref = storage.ref().child(
          '${fileType.value}s/$location/${DateTime.now().millisecondsSinceEpoch}.$ext');

      // uploading image
      await ref
          .putFile(
              file, SettableMetadata(contentType: '${fileType.value}/$ext'))
          .then((p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
      });

      // returning the download url
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  // function to delete image from firebase storage
  static Future<void> deleteImage(String imageUrl) async {
    try {
      // getting the reference of the image
      final Reference ref = storage.refFromURL(imageUrl);

      // deleting the image
      await ref.delete();
    } catch (e) {
      return;
    }
  }
}
