import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';

/// This Method uploads a [File] to Firebase Storage
Future<String> uploadImage(
    String collectionID, File imageFile, String imagename) async {
  try {
    StorageReference ref =
        FirebaseStorage.instance.ref().child(collectionID).child(imagename);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  } catch (Exception) {
    show_toast(Exception.toString());
    Log().error(causingClass: 'storageService',
        method: 'uploadImage',
        action: Exception.toString());
  }
}

/// deletes a Image based on the [String] collection_name and filename
Future deleteImage(String collection, String filename) async {
  await FirebaseStorage.instance.ref().child(collection)
      .child(filename)
      .delete();
}
