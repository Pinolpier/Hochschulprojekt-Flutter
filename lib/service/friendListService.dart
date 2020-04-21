import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/Controller/authService.dart';
import 'package:univents/Controller/userProfileService.dart';
import 'package:univents/service/eventService.dart';

//final collectionName for all friends in database
final String COLLECTION = 'friends';
final firebaseInstance = Firestore.instance;

/// adding a Friend by a [String] email-adress to the database
///  the email gets converted to a unique UserId
void addFriendbyEmail(String email) async {
  try {
    String uid = await getUidOfCurrentlySignedInUser();
    String friendID = email;
    DocumentSnapshot documentSnapshot =
    await firebaseInstance.collection(COLLECTION).document(uid).get();
    Map<String, List<dynamic>> friendMap = new Map();
    if (documentSnapshot.exists) {
      friendMap['friends'] = documentSnapshot.data['friends'];
    }
    List<dynamic> friendList = new List();
    if (friendMap['friends'] != null) friendList = friendMap['friends'];
    if (friendList.contains(friendID)) {
      print('friend is already in List');
    } else {
      friendList.add(friendID);
      friendMap['friends'] = friendList;
      WriteBatch batch = Firestore.instance.batch();
      batch.setData(
          firebaseInstance.collection(COLLECTION).document(uid), friendMap,
          merge: true);
      await batch.commit();
    }
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// adding a Friend by a [String] username to the database
/// the username gets converted to a unique UserId
void addFriendbyUsername(String username) async {
  try {
    String uid = await getUidOfCurrentlySignedInUser();
    String friendID = await getUidFromUserName(username);
    DocumentSnapshot documentSnapshot =
    await firebaseInstance.collection(COLLECTION).document(uid).get();
    Map<String, List<dynamic>> friendMap = new Map();
    if (documentSnapshot.exists) {
      friendMap['friends'] = documentSnapshot.data['friends'];
    }
    List<dynamic> friendList = new List();
    if (friendMap['friends'] != null) friendList = friendMap['friends'];
    if (friendList.contains(friendID)) {
      print('friend is already in List');
    } else {
      friendList.add(friendID);
      friendMap['friends'] = friendList;
      WriteBatch batch = Firestore.instance.batch();
      batch.setData(
          firebaseInstance.collection(COLLECTION).document(uid), friendMap,
          merge: true);
      await batch.commit();
    }
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// remove a Friend from a group by getting a [Strin] friendId and
/// a [String] groupName
void removeFriend(String friendId, String groupName) async {
  try {
    String uid = await getUidOfCurrentlySignedInUser();
    DocumentSnapshot documentSnapshot =
    await firebaseInstance.collection(COLLECTION).document(uid).get();
    Map<String, List<dynamic>> friendMap = new Map();
    if (documentSnapshot.exists) {
      friendMap['friends'] = documentSnapshot.data['friends'];
    }
    List<dynamic> friendList = new List();
    if (friendMap[groupName] != null) {
      friendList = friendMap[groupName];
      if (friendList.contains(friendId)) {
        friendList.remove(friendId);
        friendMap[groupName] = friendList;
        WriteBatch batch = Firestore.instance.batch();
        batch.setData(
            firebaseInstance.collection(COLLECTION).document(uid), friendMap,
            merge: true);
        await batch.commit();
      } else {
        print('friend not exists');
      }
    } else {
      print('Groupname not exists');
    }
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// returns a [Map] with [List]friends and their [String] grouping
Future<Map<String, dynamic>> getFriends() async {
  try {
    String uid = await getUidOfCurrentlySignedInUser();
    DocumentSnapshot documentSnapshot =
    await firebaseInstance.collection(COLLECTION).document(uid).get();
    print(documentSnapshot.data);
    print(documentSnapshot.toString());
    return documentSnapshot.data;
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// adds a User to a Group by a [String] userId and a [String] groupName
void addUsertoGroup(String userId, String groupName) async {
  try {
    String uid = await getUidOfCurrentlySignedInUser();
    DocumentSnapshot documentSnapshot =
    await firebaseInstance.collection(COLLECTION).document(uid).get();
    Map<String, List<dynamic>> friendMap = new Map();
    if (documentSnapshot.exists) {
      friendMap[groupName] = documentSnapshot.data[groupName];
    }
    List<dynamic> friendList = new List();
    if (friendMap[groupName] != null) friendList = friendMap[groupName];
    if (friendList.contains(userId)) {
      print('friend is already in List');
    } else {
      friendList.add(userId);
      friendMap[groupName] = friendList;
      WriteBatch batch = Firestore.instance.batch();
      batch.setData(
          firebaseInstance.collection(COLLECTION).document(uid), friendMap,
          merge: true);
      await batch.commit();
    }
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}

/// creates a new Group by a [List] of UserId's and a [String] for groupName
void createGroupFriend(List<String> userID, String groupName) async {
  try {
    String uid = await getUidOfCurrentlySignedInUser();
    Map<String, List<String>> groupMap = new Map();
    groupMap[groupName] = userID;
    WriteBatch writeBatch = firebaseInstance.batch();
    writeBatch.setData(
        firebaseInstance.collection(COLLECTION).document(uid), groupMap,
        merge: true);
    writeBatch.commit();
  } on Exception catch (e) {
    exceptionHandling(e);
  }
}
