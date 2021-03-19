/// author Markus Link
///
/// Use this script's methods to upload and delete files to / from Firebase Storage
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';

///This Method uploads a [File] to Firebase
///
///parameter [collectionID] is the "path" where to safe the [File]
///The parameter [file] is the [File] to be uploaded with [filename]
Future<String> uploadFile(
    String collectionID, File file, String filename) async {
  try {
    StorageReference ref =
        FirebaseStorage.instance.ref().child(collectionID).child(filename);
    StorageUploadTask uploadTask = ref.putFile(file);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  } catch (e) {
    show_toast(e.toString());
    Log().error(
        causingClass: 'storageService',
        method: 'uploadFile',
        action: e.toString());
  }
}

/// deletes a [File] located in a [collectionID] (path) named [filename].
Future deleteFile(String collectionID, String filename) async {
  await FirebaseStorage.instance
      .ref()
      .child(collectionID)
      .child(filename)
      .delete();
}
