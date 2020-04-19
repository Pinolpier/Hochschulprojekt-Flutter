import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:univents/Controller/authService.dart';
import 'package:univents/Model/userProfile.dart';
import 'package:univents/Model/userProfileExceptions.dart';

final firestore = Firestore.instance;
final String collection = 'profile';
Map<String, String> uidToUri = {};

Future<bool> updateProfile(UserProfile profile) async {
  if (profile == null || profile.uid == null) {
    if (await isUserSignedIn()) {
      if (getUidOfCurrentlySignedInUser() != profile.uid) {
        throw new ForeignProfileAccessForbiddenException(null,
            "Cannot update profile of another than the currently signed in user. Uid of profile that was intended to be updated: ${profile.uid}, uid of currently signed in user: ${getUidOfCurrentlySignedInUser()}");
        return false;
      } else {
        try {
          firestore
              .collection(collection)
              .document(profile.uid)
              .updateData(profile.toMap());
          return true;
        } catch (e) {
          //TODO Find out what exceptions are thrown by trying out to be able to handle them correctly!
          print(
              'An error has occured while updating the profile: $profile, the error is: ${e.toString()}');
          return false;
        }
      }
    } else {
      throw new UserNotSignedInException(null,
          "A user has to be signed in to be able to update his profile! No user is signed in right now!");
      return false;
    }
  } else {
    throw new NullArgumentException(null,
        "UserProfile Argument was null or uid was null. Cannot identify profile to change.");
    return false;
  }
  return false;
}

Future<bool> createProfile(UserProfile profile) async {}

Future<bool> updateImage(File file) async {}

Future<Widget> getProfilePicture(String uid) async {
  String uri = '';
  if (uidToUri.containsKey(uid)) {
    uri = uidToUri[uid];
  } else {
    DocumentSnapshot documentSnapshot =
        await firestore.collection(collection).document(uid).get();
    uri = documentSnapshot.data['pictureURI'].toString();
  }
  if (key != null) return Image.network(uri);
  return null;
}
