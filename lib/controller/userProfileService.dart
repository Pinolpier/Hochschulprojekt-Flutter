import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/storageService.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/model/userProfileExceptions.dart';
import 'package:univents/service/friendlist_service.dart';
import 'package:univents/service/storageService.dart';

final firestore = Firestore.instance;
final String collection = 'profile';
Map<String, String> uidToUri = {};

///Use this method to update a [UserProfile]. If it does not exist already it will be created.
///All fields will be overwritten with the values from the parameter [profile].
///Only the [FirebaseUser] referenced by [profile._uid] is allowed to update his own profile.
Future<bool> updateProfile(UserProfile profile) async {
  bool uniquenessOfUsername = false;
  try {
    String uid = await getUidFromUserName(profile.username);
    uniquenessOfUsername = (uid == profile.uid);
  } on NoUserProfileFoundException {
    // this is correct "error handling", because like this we check, whether or not a username is free and can be set.
    // Don't do any more exceptionHandling here!
    // TODO implement uniqueness check on database level not client side bad impl. But for beta this is working as long as not 2 users try to choose the same name at nearly exactly one moment of time
    uniquenessOfUsername = true;
  }
  if (!uniquenessOfUsername) {
    throw UniqueConstraintViolatedException(null,
        "The username ${profile.username} is already taken by another user!");
  }
  // TODO updating email using this method? Probably yes...
  if (await _isOperationAllowed(profile)) {
    try {
      await firestore
          .collection(collection)
          .document(profile.uid)
          .setData(profile.toMap());
      return true;
    } catch (e) {
      //TODO Find out what exceptions are thrown by trying out to be able to handle them correctly!
      print(
          'An error has occurred while creating the profile: $profile, the error is: ${e
              .toString()}');
      return false;
    }
  }
  return false;
}

Future<bool> deleteProfileOfCurrentlySignedInUser() async {
  String uid = getUidOfCurrentlySignedInUser();
  UserProfile profile = await getUserProfile(uid);
  String uri = (await firestore.collection(collection).document(uid).get()).data['pictureURI'];
  if (uri != null) {
    deleteImage(collection, uri); //delete the picture if one exists
  }
  firestore.collection(collection).document(uid).delete();
  deleteAccount();
}

/// Use this method to change a user's profile picture. The parameter [file] should be the new file to upload as the [profile]'s profile picture.
/// The user is referenced by [profile.uid] and the parameter [file] may be null to delete the (existing) profile picture.
Future<bool> updateProfilePicture(File file, UserProfile profile) async {
  if (await _isOperationAllowed(profile)) {
    String uri = '';
    if (uidToUri.containsKey(profile.uid)) {
      //The uri of the picture is known
      uri = uidToUri[profile.uid];
      uidToUri.remove(profile.uid);
    } else {
      //The uri of the picture has to be requested from Firestore
      DocumentSnapshot documentSnapshot =
      await firestore.collection(collection).document(profile.uid).get();
      uri = documentSnapshot.data['profilePicture'].toString();
    }
    if (uri != null && uri.trim() != "")
      deleteImage(collection, uri); //delete the picture if one exists
    if (file != null) {
      //if a not null picture has been given to the method upload it
      uidToUri[profile.uid] = await uploadFile(collection, file, profile.uid);
      try {
        //and after uploading write the new uri to the database
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
        //if no picture is given to upload update the database
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
  return false;
}

/// Use this method to retrieve an [Image] ([Widget]) with the profile picture of the [FirebaseUser] that is referenced by [uid]
Future<Widget> getProfilePicture(String uid) async {
  String uri = '';
  if (uidToUri.containsKey(uid)) {
    uri = uidToUri[uid];
  } else {
    DocumentSnapshot documentSnapshot =
    await firestore.collection(collection).document(uid).get();
    uri = documentSnapshot.data['profilePicture'].toString();
  }
  if (uri != null && (uri.trim() != "")) return Image.network(uri);
  return null;
}

/// Use this method to retrieve a [UserProfile] referenced by a [uid].
///
/// All privacy settings are evaluated locally! If access to some of the information is forbidden the value will be set to null
Future<UserProfile> getUserProfile(String uid) async {
  if (!await isUserSignedIn()) {
    throw new UserNotSignedInException(null,
        "A user has to be signed in to be able to update his/her profile! No user is signed in right now!");
  }
  try {
    UserProfile userProfile = UserProfile.fromDocumentSnapshot(
        (await firestore.collection(collection).document(uid).get()).data, uid);

    if (uid != getUidOfCurrentlySignedInUser()) {
      Map<String, dynamic> i = await getFriends();
      List<dynamic> friends = i['friends'];
      if (userProfile.emailVisibility == PRIVATE ||
          (userProfile.emailVisibility == FRIENDS &&
              !friends.contains(getUidOfCurrentlySignedInUser()))) {
        userProfile.setEmail(null);
      }
      if (userProfile.nameVisibility == PRIVATE ||
          (userProfile.nameVisibility == FRIENDS &&
              !friends.contains(getUidOfCurrentlySignedInUser()))) {
        userProfile.surname = null;
        userProfile.forename = null;
      }
      if (userProfile.tagsVisibility == PRIVATE ||
          (userProfile.tagsVisibility == FRIENDS &&
              !friends.contains(getUidOfCurrentlySignedInUser()))) {
        userProfile.tags = null;
      }
    }
    return userProfile;
  } on PlatformException catch (platformException) {
    throw new PermissionDeniedException(platformException,
        "Cannot retrieve the User profile with uid: $uid, probably because permission is denied.");
  }
}

/// Use this method to be informed wheter a userProfile exists for the given [uid].
Future<bool> existsUserProfile(String uid) async {
  if (!await isUserSignedIn()) {
    throw new UserNotSignedInException(null,
        "A user has to be signed in to be able to update his/her profile! No user is signed in right now!");
  }
  try {
    final snapShot = await firestore.collection(collection).document(uid).get();
    if (snapShot == null || !snapShot.exists) return false;
    return true;
  } on PlatformException catch (platformException) {
    throw new PermissionDeniedException(platformException,
        "Cannot retrieve the User profile with uid: $uid, probably because permission is denied.");
  }
}

Future<String> getUidFromUserName(String username) async {
  var x = firestore
      .collectionGroup(collection)
      .reference()
      .where('username', isEqualTo: username.toLowerCase());
  QuerySnapshot querySnapshot = await x.getDocuments();
  switch (querySnapshot.documents.length) {
    case 0:
      throw new NoUserProfileFoundException(
          null, "No user with the given username: $username could be found.");
      break;
    case 1:
      DocumentSnapshot documentSnapshot = querySnapshot.documents[0];
      return documentSnapshot.documentID;
      break;
    default:
      throw new IllegalDatabaseStateException(null,
          "More than 1 or less than 0 users with username: $username have been returned from database! Length og List is: ${querySnapshot
              .documents.length}");
  }
}

Future<String> getUidFromEmail(String email) async {
  var x = firestore
      .collectionGroup(collection)
      .reference()
      .where('email', isEqualTo: email.toLowerCase());
  QuerySnapshot querySnapshot = await x.getDocuments();
  switch (querySnapshot.documents.length) {
    case 0:
      throw new NoUserProfileFoundException(
          null, "No user with the given email address: $email could be found.");
      break;
    case 1:
      DocumentSnapshot documentSnapshot = querySnapshot.documents[0];
      return documentSnapshot.documentID;
      break;
    default:
      throw new IllegalDatabaseStateException(null,
          "More than 1 or less than 0 users with email adress: $email have been returned from database! Length og List is: ${querySnapshot
              .documents.length}");
  }
}

///this method is used twice internally to check that only a signed in user can change his own profile.
Future<bool> _isOperationAllowed(UserProfile profile) async {
  if (profile == null || profile.uid == null) {
    throw new NullArgumentException(null,
        "UserProfile Argument was null or uid was null. Cannot identify profile to change.");
    return false;
  }
  if (!await isUserSignedIn()) {
    throw new UserNotSignedInException(null,
        "A user has to be signed in to be able to update his/her profile! No user is signed in right now!");
    return false;
  }
  if (getUidOfCurrentlySignedInUser() != profile.uid) {
    throw new ForeignProfileAccessForbiddenException(null,
        "Cannot update profile of another than the currently signed in user. Uid of profile that was intended to be updated: ${profile
            .uid}, uid of currently signed in user: ${getUidOfCurrentlySignedInUser()}");
    return false;
  }
  return true;
}
