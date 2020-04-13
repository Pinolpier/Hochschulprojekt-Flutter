import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

///This class represents the interface for image storage
class storage {

  ///This Method starts the cameramode and uploads the chosen picture
    Future<String>saveCameraImage(String imageId)async{
     return await uploadImage(imageId,await ImagePicker.pickImage(source: ImageSource.camera));
  }
///This Method starts the Gallery of the phone and uploads the selected image
  Future<String> saveGalleryImage(String imageId)async{
    return await uploadImage(imageId,await ImagePicker.pickImage(source: ImageSource.gallery));
  }

  ///This Method uploads a File
  Future<String> uploadImage(String imageId,File imageFile) async {
    StorageReference ref =
    FirebaseStorage.instance.ref().child(imageId).child("image.jpg");
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }



}