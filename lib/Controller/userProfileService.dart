import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:univents/Controller/authService.dart';
import 'package:univents/Controller/storageService.dart';
import 'package:univents/Model/userProfile.dart';
import 'package:univents/Model/userProfileExceptions.dart';

final firestore = Firestore.instance;
final String collection = 'profile';
Map<String, String> uidToUri = {};

///Use this method to update a [UserProfile]. If it does not exist already it will be created.
///All field will be overwritten with the values from the parameter [profile].
///Only the [FirebaseUser] references by [profile.uid] is allowed to update his own profile.
Future<bool> updateProfile(UserProfile profile) async {
  if (profile == null || profile.uid == null) {
    if (await isUserSignedIn()) {
      if (getUidOfCurrentlySignedInUser() != profile.uid) {
        throw new ForeignProfileAccessForbiddenException(null,
            "Cannot update profile of another than the currently signed in user. Uid of profile that was intended to be updated: ${profile.uid}, uid of currently signed in user: ${getUidOfCurrentlySignedInUser()}");
        return false;
      } else {
        try {
          await firestore.collection(collection).document(profile.uid).setData(
              profile.toMap());
          return true;
        } catch (e) {
          //TODO Find out what exceptions are thrown by trying out to be able to handle them correctly!
          print(
              'An error has occured while crea ting the profile: $profile, the error is: ${e
                  .toString()}');
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

/// Use this method to change a user's profile picture. The parameter [file] should be the new file to upload as the [profile]'s profile picture.
/// The user is referenced by [profile.uid] and the parameter [file] may be null to delete the (existing) profile picture.
Future<bool> updateImage(File file, UserProfile profile) async {
  // TODO check that user profile exists before uploading. Write extra private method for this and use everywhere where needed.
  String uri = '';
  if (uidToUri.containsKey(profile.uid)) {
    uri = uidToUri[profile.uid];
    uidToUri.remove(profile.uid);
  } else {
    DocumentSnapshot documentSnapshot =
    await firestore.collection(collection).document(profile.uid).get();
    uri = documentSnapshot.data['pictureURI'].toString();
  }
  //TODO test / improve the storage service. I think that deleting doesn't work and possibly also uploading maybe fails. The naming and reference to different files seems to be wrong.
  deleteFile(
      uri); //TODO if uri != null, maybe no profile picture was uploaded before.
  if (file != null) {
    uidToUri[profile.uid] = await uploadFile(collection, file, profile.uid);
    try {
      firestore
          .collection(collection)
          .document(profile.uid)
          .updateData({'profilePicture': uidToUri[profile.uid]});
      return true;
    } catch (e) {
      //TODO Find out what exceptions are thrown by trying out to be able to handle them correctly!
      print(
          'An error has occured while updating the profile: $profile, the error is: ${e
              .toString()}');
      return false;
    }
  } else {
    try {
      firestore
          .collection(collection)
          .document(profile.uid)
          .updateData({'profilePicture': null});
      return true;
    } catch (e) {
      //TODO Find out what exceptions are thrown by trying out to be able to handle them correctly!
      print(
          'An error has occured while updating the profile: $profile, the error is: ${e
              .toString()}');
      return false;
    }
  }
}

/// Use this method to retrieve an [Image] ([Widget]) with the profile picture of the [FirebaseUser] that is referenced by [uid]
Future<Widget> getProfilePicture(String uid) async {
  String uri = '';
  if (uidToUri.containsKey(uid)) {
    uri = uidToUri[uid];
  } else {
    DocumentSnapshot documentSnapshot =
        await firestore.collection(collection).document(uid).get();
    uri = documentSnapshot.data['pictureURI'].toString();
  }
  if (uri != null) return Image.network(uri);
  return null;
}

/// Use this method to retrieve a [UserProfile] referenced by a [uid].
Future<UserProfile> getUserProfile(String uid) async {
  return UserProfile.fromDocumentSnapshot(
      (await firestore.collection(collection).document(uid).get()).data, uid);
}