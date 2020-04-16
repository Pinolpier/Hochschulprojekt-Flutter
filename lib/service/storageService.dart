import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:univents/service/eventService.dart';

/// This Method starts the cameramode and returns the picture
/// as a [File]
Future<File> saveCameraImage() async {
  return await ImagePicker.pickImage(source: ImageSource.camera);
}

/// This Method starts the Gallery of the phone and returns the selected image
/// as a [File]
Future<File> saveGalleryImage() async {
  return await ImagePicker.pickImage(source: ImageSource.gallery);
}

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

/// deletes a Image based on the URL or the eventId (still testing)
Future deleteImage(String imageURL) async {
  await FirebaseStorage.instance.ref().child(imageURL).delete();
}
