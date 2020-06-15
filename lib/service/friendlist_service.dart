import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/userProfileService.dart';

//final collectionName for all friends in database
final String collection = 'friends';
final String friendsList = 'friends';
final firebaseInstance = Firestore.instance;

/// adding a Friend by a [E-mail-address] to the database
///  the email gets converted to a unique UserId
void addFriendByEmail(String email) async {
    String friendId = await getUidFromEmail(email);
    if (friendId != null) {
      addFriend(friendId);
    } else {
      throw new FriendNotExistException(
          null, 'no user with this email address found');
  }
}

/// adding a Friend by a [username] to the database
/// the username gets converted to a unique UserId
void addFriendByUsername(String username) async {
    String friendId = await getUidFromUserName(username);
    if (friendId != null) {
      addFriend(friendId);
    } else {
      throw new FriendNotExistException(
          null, 'No user found with this username');
  }
}

/// adding a Friend to database by a [friendId]
void addFriend(String friendId) async {
    String uid = getUidOfCurrentlySignedInUser();
    String friendID = friendId;
    DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection(collection).document(uid).get();
    Map<String, List<dynamic>> friendMap = new Map();
    if (documentSnapshot.exists) {
      friendMap[friendsList] = documentSnapshot.data[friendsList];
    }
    List<dynamic> friendList = new List();
    if (friendMap[friendsList] != null) {
      for (dynamic d in friendMap[friendsList])
        friendList.add(d);
    }
    if (friendList.contains(friendID)) {
      throw new FriendAlreadyInListException(
          null, 'The friend is already on the list');
    } else {
      friendList.add(friendID);
      friendMap[friendsList] = friendList;
      WriteBatch batch = Firestore.instance.batch();
      batch.setData(
          firebaseInstance.collection(collection).document(uid), friendMap,
          merge: true);
      await batch.commit();
  }
}

/// remove a Friend from a group by getting a [friendId] and
/// a [groupName]
void removeFriend(String friendId, String groupName) async {
    String uid = getUidOfCurrentlySignedInUser();
    DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection(collection).document(uid).get();
    Map<String, List<dynamic>> friendMap = new Map();
    if (documentSnapshot.exists) {
      friendMap[friendsList] = documentSnapshot.data[friendsList];
    }
    List<dynamic> friendList = new List();
    if (friendMap[groupName] != null) {
      friendList = friendMap[groupName];
      if (friendList.contains(friendId)) {
        friendList.remove(friendId);
        friendMap[groupName] = friendList;
        WriteBatch batch = Firestore.instance.batch();
        batch.setData(
            firebaseInstance.collection(collection).document(uid), friendMap,
            merge: true);
        await batch.commit();
      } else {
        throw new FriendNotExistException(
            null, 'the friend with uid $friendId you are looking for does not exist');
      }
    } else {
      throw new GroupNotExistException(null, 'the group $groupName does not exist');
  }
}

/// returns a [Map] with [friends] and their [String] grouping
Future<Map<String, dynamic>> getFriends() async {
    String uid = getUidOfCurrentlySignedInUser();
    DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection(collection).document(uid).get();
    return documentSnapshot.data;
}

/// adds a User to a Group by a [userId]  and a [groupName]
void addUserToGroup(String userId, String groupName) async {
    String uid = getUidOfCurrentlySignedInUser();
    DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection(collection).document(uid).get();
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
          firebaseInstance.collection(collection).document(uid), friendMap,
          merge: true);
      await batch.commit();
  }
}

/// creates a new Group by a [userId] and a [groupName]
void createGroupFriend(List<String> userId, String groupName) async {
  String uid = getUidOfCurrentlySignedInUser();
  Map<String, List<String>> groupMap = new Map();
  groupMap[groupName] = userId;
  WriteBatch writeBatch = firebaseInstance.batch();
  writeBatch.setData(
      firebaseInstance.collection(collection).document(uid), groupMap,
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
      List<String> keyList = friendMap.keys;
      for (int x = 0; x < keyList.length; x++) {
        List<String> friendsList = friendMap[keyList[x]];
        if (friendsList.contains(uid)) {
          friendsList.remove(uid);
        }
      }
      firebaseInstance
          .collection(collection)
          .document(documentSnapshotList[x].documentID)
          .updateData(friendMap);
    }
  }
}

class FriendsException implements Exception {
  final Exception _originalException;
  final String _message;

  const FriendsException(this._originalException, this._message);

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

class FriendNotExistException extends FriendsException {
  const FriendNotExistException(Exception originalException, String message)
      : super(originalException, message);
}

class FriendAlreadyInListException extends FriendsException {
  const FriendAlreadyInListException(
      Exception originalException, String message)
      : super(originalException, message);
}

class GroupNotExistException extends FriendsException {
  const GroupNotExistException(Exception originalException, String message)
      : super(originalException, message);
}
