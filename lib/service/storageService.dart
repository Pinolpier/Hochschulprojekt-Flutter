import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;


class storageService{

  File _image;
  String _uploadedFileURL;
  final FirebaseStorage fb = new FirebaseStorage();



  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }


  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  String get uploadedFileURL => _uploadedFileURL;

  set uploadedFileURL(String value) {
    _uploadedFileURL = value;
  }

  File get image => _image;

  set image(File value) {
    _image = value;
  }


}