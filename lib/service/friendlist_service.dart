import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/userProfileService.dart';

/// Markus Häring
///
/// the file handles everything for add, delete or group friends of a user
/// in the firebase database
/// therefore a own exception class is created when an error occurs

/// final collectionName for all friends in database
final String _collection = 'friends';

/// final name for the main List of all friends
final String _friendsList = 'friends';

/// final instance of FireStore
final _firebaseInstance = Firestore.instance;

/// Searches for a friend by a email address and adds it to the friendsList
///
/// adding a Friend by a String [email] with the E-Mail address to the database
/// the email gets converted to a unique UserId
/// throws [FriendNotExistException] when no User were
/// found by the email address
void addFriendByEmail(String email) async {
  String friendId = await getUidFromEmail(email);
  if (friendId != null) {
    addFriend(friendId);
  } else {
    throw new FriendNotExistException(
        null, 'no user with this email address found');
  }
}

/// Adds a Friend to the friendsList in the database
///
/// adding a Friend by a [username] to the database
/// the username gets converted to a unique UserId
void addFriendByUsername(String username) async {
  String friendId = await getUidFromUserName(username);
  if (friendId != null) {
    addFriend(friendId);
  } else {
    throw new FriendNotExistException(null, 'No user found with this username');
  }
}

/// adds a friend to a users friendsList in the database
///
/// adding a Friend to database by a [friendId]
/// throws [FriendAlreadyInListException] if a friend is
/// already in the friendsList
void addFriend(String friendId) async {
  String uid = getUidOfCurrentlySignedInUser();
  String friendID = friendId;
  DocumentSnapshot documentSnapshot =
      await _firebaseInstance.collection(_collection).document(uid).get();
  Map<String, List<dynamic>> friendMap = new Map();
  if (documentSnapshot.exists) {
    friendMap[_friendsList] = documentSnapshot.data[_friendsList];
  }
  List<dynamic> friendList = new List();
  if (friendMap[_friendsList] != null) {
    for (dynamic d in friendMap[_friendsList]) friendList.add(d);
  }
  if (friendList.contains(friendID)) {
    throw new FriendAlreadyInListException(
        null, 'The friend is already on the list');
  } else {
    friendList.add(friendID);
    friendMap[_friendsList] = friendList;
    WriteBatch batch = Firestore.instance.batch();
    batch.setData(
        _firebaseInstance.collection(_collection).document(uid), friendMap,
        merge: true);
    await batch.commit();
  }
}

/// removes a friendId in the database
///
/// remove a Friend from a group by getting a [friendId] and
/// a [groupName]
void removeFriend(String friendId, String groupName) async {
  String uid = getUidOfCurrentlySignedInUser();
  DocumentSnapshot documentSnapshot =
  await _firebaseInstance.collection(_collection).document(uid).get();
  Map<String, List<dynamic>> friendMap = new Map();
  if (documentSnapshot.exists) {
    friendMap[_friendsList] = documentSnapshot.data[_friendsList];
  }
  List<dynamic> friendList = new List();
  if (friendMap[groupName] != null) {
    friendList = friendMap[groupName];
    if (friendList.contains(friendId)) {
      friendList.remove(friendId);
      friendMap[groupName] = friendList;
      WriteBatch batch = Firestore.instance.batch();
      batch.setData(
          _firebaseInstance.collection(_collection).document(uid), friendMap,
          merge: true);
      await batch.commit();
    } else {
      throw new FriendNotExistException(null,
          'the friend with uid $friendId you are looking for does not exist');
    }
  } else {
    throw new GroupNotExistException(
        null, 'the group $groupName does not exist');
  }
}

/// returns all friends of the currently signed in user
///
/// returns a [Map] with [friends] and their [String] grouping
/// throws [PlatformException] when an error occurs while fetching data
Future<Map<String, dynamic>> getFriends() async {
  String uid = getUidOfCurrentlySignedInUser();
  DocumentSnapshot documentSnapshot =
  await _firebaseInstance.collection(_collection).document(uid).get();
  return documentSnapshot.data;
}

/// adds a User to a specific Group
///
/// adds a User to a Group by a [userId]  and a [groupName]
/// if the group not exists, the group will be created
/// throws [PlatformException] when a error occurs while working with database
/// to get a useful message the exception can be
/// handled by the [exceptionHandling(platformException)]
/// from eventService
void addUserToGroup(String userId, String groupName) async {
  String uid = getUidOfCurrentlySignedInUser();
  DocumentSnapshot documentSnapshot =
  await _firebaseInstance.collection(_collection).document(uid).get();
  Map<String, List<dynamic>> friendMap = new Map();
  if (documentSnapshot.exists) {
    friendMap[groupName] = documentSnapshot.data[groupName];
  }
  List<dynamic> friendList = new List();
  if (friendMap[groupName] != null) friendList = friendMap[groupName];
  if (friendList.contains(userId)) {
    throw new FriendAlreadyInListException(
        null, 'The friend is already on the list');
  } else {
    friendList.add(userId);
    friendMap[groupName] = friendList;
    WriteBatch batch = Firestore.instance.batch();
    batch.setData(
        _firebaseInstance.collection(_collection).document(uid), friendMap,
        merge: true);
    await batch.commit();
  }
}

/// Creates a new Group of friends with many friends
///
/// creates a new Group by a [userId] and a [groupName]
/// throws [PlatformException] when a error occurs while writing data
/// into database
/// to get a useful message the exception can be
/// handled by the [exceptionHandling(platformException)]
/// from eventService
void createGroupFriend(List<String> userId, String groupName) async {
  String uid = getUidOfCurrentlySignedInUser();
  Map<String, List<String>> groupMap = new Map();
  groupMap[groupName] = userId;
  WriteBatch writeBatch = _firebaseInstance.batch();
  writeBatch.setData(
      _firebaseInstance.collection(_collection).document(uid), groupMap,
      merge: true);
  writeBatch.commit();
}

/// This method should be used by [userProfileService.dart] when a User
/// deletes his/her/its Account
/// remove a User from all Lists of all People by a String [uid]
/// throws [PlatformException] when an Error occurs while delete data
void deleteUidFromFriendsLists(String uid) async {
  QuerySnapshot qShot = await firebaseInstance
      .collection(collection)
      .where(friendsList, arrayContains: uid)
      .getDocuments();
  List<DocumentSnapshot> documentSnapshotList = qShot.documents;
  if (documentSnapshotList != null && documentSnapshotList.length > 0) {
    for (int x = 0; x < documentSnapshotList.length; x++) {
      Map<String, dynamic> friendMap = new Map();
      friendMap = documentSnapshotList[x].data;
      List<String> keyList = friendMap.keys.toList();
      for (int x = 0; x < keyList.length; x++) {
        List<dynamic> friendsList = friendMap[keyList[x]];
        List<dynamic> friendsListCopy = new List();
        if (friendsList != null && friendsList.length > 0) {
          for (int i = 0; i < friendsList.length; i++) {
            friendsListCopy.add(friendsList[i]);
          }
          if (friendsListCopy.contains(uid)) {
            friendsListCopy.remove(uid);
          }
        }
        friendMap[keyList[x]] = friendsListCopy;
      }
      firebaseInstance
          .collection(collection)
          .document(documentSnapshotList[x].documentID)
          .updateData(friendMap);
    }
  }
}

/// FriendsException to handle Exceptions while working with
/// friendIds in database
class FriendsException implements Exception {

  /// dataField for the original exception
  final Exception _originalException;

  /// datafield for the message of the exception that should be thrown
  final String _message;

  /// constructor for the FriendsException
  ///
  /// where the original Exception [_originalException] and the [_message]
  /// that should be shown were given
  const FriendsException(this._originalException, this._message);

  /// provides a sensible output for the exception
  String toString() {
    return (_message != null
        ? _message
        : "no Message has been provided when this instance of Backend Exception was created.") +
        " " +
        (_originalException != null
            ? (_originalException.toString() != null &&
                    _originalException.toString() != ""
                ? "Originale exception's message was :" +
                    _originalException.toString()
                : "Original exception had no or an empty message.")
            : "no original exception has been provided when this instance of Backend exception was created.");
  }
}

/// Exception when a Friend should be added which does not exists
class FriendNotExistException extends FriendsException {
  const FriendNotExistException(Exception originalException, String message)
      : super(originalException, message);
}

/// Exception when a Friend is already in the List he should be added
class FriendAlreadyInListException extends FriendsException {
  const FriendAlreadyInListException(
      Exception originalException, String message)
      : super(originalException, message);
}

/// Exception when a Group not exists a user asked for
class GroupNotExistException extends FriendsException {
  const GroupNotExistException(Exception originalException, String message)
      : super(originalException, message);
}
