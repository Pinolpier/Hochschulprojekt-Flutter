import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/service/event_service.dart';

//final collectionName for all friends in database
final String collection = 'friends';
final String friendsList = 'friends';
final firebaseInstance = Firestore.instance;

/// adding a Friend by a [E-mail-address] to the database
///  the email gets converted to a unique UserId
void addFriendByEmail(String email) async {
  try {
    String friendId = await getUidFromEmail(email);
    if (friendId != null) {
      addFriend(friendId);
    } else {
      throw new FriendNotExistException(
          null, 'no user with this email address found');
    }
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// adding a Friend by a [username] to the database
/// the username gets converted to a unique UserId
void addFriendByUsername(String username) async {
  try {
    String friendId = await getUidFromUserName(username);
    if (friendId != null) {
      addFriend(friendId);
    } else {
      throw new FriendNotExistException(
          null, 'No user found with this username');
    }
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// adding a Friend to database by a [friendId]
void addFriend(String friendId) async {
  try {
    String uid = getUidOfCurrentlySignedInUser();
    String friendID = friendId;
    DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection(collection).document(uid).get();
    Map<String, List<dynamic>> friendMap = new Map();
    if (documentSnapshot.exists) {
      friendMap[friendsList] = documentSnapshot.data[friendsList];
    }
    List<dynamic> friendList = new List();
    if (friendMap[friendsList] != null) friendList = friendMap[friendsList];
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
  } on Exception catch (exception) {
    exceptionHandling(exception);
  }
}

/// remove a Friend from a group by getting a [friendId] and
/// a [groupName]
void removeFriend(String friendId, String groupName) async {
  try {
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
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// returns a [Map] with [friends] and their [String] grouping
Future<Map<String, dynamic>> getFriends() async {
  try {
    String uid = getUidOfCurrentlySignedInUser();
    DocumentSnapshot documentSnapshot =
        await firebaseInstance.collection(collection).document(uid).get();
    return documentSnapshot.data;
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// adds a User to a Group by a [userId]  and a [groupName]
void addUserToGroup(String userId, String groupName) async {
  try {
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
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// creates a new Group by a [userId] and a [groupName]
void createGroupFriend(List<String> userId, String groupName) async {
  try {
    String uid = await getUidOfCurrentlySignedInUser();
    Map<String, List<String>> groupMap = new Map();
    groupMap[groupName] = userId;
    WriteBatch writeBatch = firebaseInstance.batch();
    writeBatch.setData(
        firebaseInstance.collection(collection).document(uid), groupMap,
        merge: true);
    writeBatch.commit();
  } on Exception catch (e) {
    exceptionHandling(e);
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
