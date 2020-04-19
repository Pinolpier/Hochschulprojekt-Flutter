import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

///This Method uploads a [File],
///parameter [collectionID] is the "path" where to safe the [File]
///The parameter [file] is the [File] to be uploaded with [filename]
Future<String> uploadFile(
    String collectionID, File file, String filename) async {
  try {
    StorageReference ref =
        FirebaseStorage.instance.ref().child(collectionID).child(filename);
    StorageUploadTask uploadTask = ref.putFile(file);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  } catch (Excpetion) {
    //TODO improve exception handling
    print(Excpetion.toString());
  }
}

/// deletes a [File] based on a [collectionID]
Future deleteFile(String collectionID) async {
  await FirebaseStorage.instance.ref().child(collectionID).delete();
}
