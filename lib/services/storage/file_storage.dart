import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:heartless/services/enums/file_type.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileStorageService {
  // request permission
  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      await permission.request();
      if (permission == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  // save file to storage
  static Future<String?> saveFile(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          if (directory != null) {
            log("External : " + directory.path);
          } else {
            return null;
          }
          // get the path of the external storage directory
          // List<String> folders = directory.path.split('/');
          // String newPath = "";
          // for (int x = 1; x < folders.length; x++) {
          //   String folder = folders[x];
          //   if (folder != "Android") {
          //     newPath += "/" + folder;
          //   } else {
          //     break;
          //   }
          // }
          // newPath = newPath + "/" + Constants.appName;
          // directory = Directory(d);
          // log("New Path : " + newPath);
        } else {
          return null;
        }
      } else if (Platform.isIOS) {
        //? then we can use the temporary directory then save it to photos
        if (await _requestPermission(Permission.photos)) {
          // get the path of the temporary directory
          directory = await getTemporaryDirectory();
        } else {
          return null;
        }
      }
      // check if the directory exists
      if (directory != null && !await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (directory != null && await directory.exists()) {
        File file = File("${directory.path}/$fileName");
        if (await file.exists()) {
          return file.path;
        }
        // download the file
        await Dio().download(url, file.path,
            onReceiveProgress: (downloaded, total) {
          log("Downloaded : $downloaded, Total : $total");
        });

        // save the file to the gallery in case of ios
        if (Platform.isIOS &&
            fileTypeFromExtension(fileName.split('.').last) == FileType.image) {
          await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: true);
        }
        return file.path;
      }
      return null;
    } catch (e) {
      log("Error : " + e.toString());
      return null;
    }
  }

  // open file from storage
  static Future<bool> openFile(String path) async {
    try {
      File file = File(path);
      if (await file.exists()) {
        await OpenFile.open(path);
        return true;
      }
      return false;
    } catch (e) {
      log("Error : " + e.toString());
      return false;
    }
  }

  // delete file from storage
  static Future<bool> deleteFile(String path) async {
    try {
      // File file = File("$path/$fileName");
      File file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      log("Error : " + e.toString());
      return false;
    }
  }
}
