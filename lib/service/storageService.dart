import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

///This Method uploads a [File]
Future<String> uploadImage(
    String collectionID, File imageFile, String imagename) async {
  try {
    StorageReference ref =
        FirebaseStorage.instance.ref().child(collectionID).child(imagename);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  } catch (Excpetion) {
    print(Excpetion.toString());
  }
}

/// deletes a Image based on the eventId
Future deleteImage(String eventID) async {
  await FirebaseStorage.instance.ref().child(eventID).delete();
}
