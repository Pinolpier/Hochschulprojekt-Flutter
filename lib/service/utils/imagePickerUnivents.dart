import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// @author Jan Oster
/// todo: CONSIDER writing a library-level doc comment
class ImagePickerUnivents {
  /// todo: add documentation to variable
  File _image;

  /// todo: missing documentation
  Future<File> getImageFromCamera() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    return pickedImage;
  }

  /// todo: missing documentation
  Future<File> getImageFromGallery() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }

  /// todo: missing documentation
  Future<File> chooseImage(BuildContext context) async {
    await showDialog<File>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload an Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Choose from where you want to upload the iamge'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Camera'),
              onPressed: () async {
                _image = await getImageFromCamera();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Gallery'),
              onPressed: () async {
                _image = await getImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Remove'),
              onPressed: () {
                _image = null;
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return _image;
  }
}
