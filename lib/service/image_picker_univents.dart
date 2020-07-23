import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:univents/constants/constants.dart';

/// @author Jan Oster
/// This class displays an image picker dialog
///
/// To use the image picker create an instance of it at your desired location and then call its method [chooseImage]
class ImagePickerUnivents {
  /// selected image, can be null if nothing is selected
  dynamic _image;

  /// This Function is used to get an image from the camera of the device
  ///
  /// Returns [pickedImage]
  Future<File> getImageFromCamera() async {
    File pickedImage = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: imageQuality);
    return pickedImage;
  }

  /// This function is used to get an image from the gallery of the device
  ///
  /// Returns [pickedImage]
  Future<File> getImageFromGallery() async {
    File pickedImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: imageQuality);
    return pickedImage;
  }

  /// This Function opens a dialog where you can choose from where you want to pick the image (Gallery, Camera) or you can remove the image or close the Dialog
  ///
  /// Returns the selected image, if no image is selected/remove pressed/cancel pressed then null is returned
  Future<dynamic> chooseImage(BuildContext context) async {
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
                Navigator.of(context).pop();
                _image = null;
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                _image = 1;
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
