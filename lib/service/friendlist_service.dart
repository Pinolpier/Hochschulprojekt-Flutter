import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/userProfileService.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment
/// todo: PREFER using “this” instead of “the” to refer to a member’s instance (and to methods)

/// todo: set variables private
//final collectionName for all friends in database
final String collection = 'friends';
final String friendsList = 'friends';
final firebaseInstance = Firestore.instance;

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
    for (dynamic d in friendMap[friendsList]) friendList.add(d);
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

/// removes a friendId in the database
///
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
      throw new FriendNotExistException(null,
          'the friend with uid $friendId you are looking for does not exist');
    }
  } else {
    throw new GroupNotExistException(
        null, 'the group $groupName does not exist');
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
