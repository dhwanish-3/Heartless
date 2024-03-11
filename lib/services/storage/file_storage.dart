import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:heartless/shared/constants.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileStorageService {
  // dio for making network requests
  Dio dio = Dio();

  // request permission
  Future<bool> _requestPermission(Permission permission) async {
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
  Future<bool> saveFile(String url, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          if (directory != null) {
            log("External : " + directory.path);
          } else {
            return false;
          }
          // get the path of the external storage directory
          List<String> folders = directory.path.split('/');
          String newPath = "";
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/" + Constants.appName;
          directory = Directory(newPath);
          log("New Path : " + newPath);
        } else {
          return false;
        }
      } else if (Platform.isIOS) {
        //? then we can use the temporary directory then save it to photos
        if (await _requestPermission(Permission.photos)) {
          // get the path of the temporary directory
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      // check if the directory exists
      if (directory != null && !await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (directory != null && await directory.exists()) {
        File file = File("${directory.path}/$fileName");
        // download the file
        await dio.download(url, file.path,
            onReceiveProgress: (downloaded, total) {
          log("Downloaded : $downloaded, Total : $total");
        });

        // save the file to the gallery in case of ios
        if (Platform.isIOS && file.path.split(".").last != "pdf") {
          await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      log("Error : " + e.toString());
      return false;
    }
  }
}
