import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/Controller/authService.dart';
import 'package:univents/Controller/userProfileService.dart';

final String COLLECTION = 'friends';
final firebaseInstance = Firestore.instance;

void createFriendsdocument() async {}

/// adding a Friend by a [String] email-adress to the database
void addFriendbyEmail(String email) async {
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
}

void addFriendbyUsername(String username) async {
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
}

void removeFriend(String friendId, String groupName) async {
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
}

Future<Map<String, dynamic>> getFriends() async {
  String uid = await getUidOfCurrentlySignedInUser();
  DocumentSnapshot documentSnapshot =
  await firebaseInstance.collection(COLLECTION).document(uid).get();
  print(documentSnapshot.data);
  print(documentSnapshot.toString());
  return documentSnapshot.data;
}

void addUsertoGroup(String userId, String groupName) async {
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
}

void createGroupFriend(List<String> userID, String groupName) async {
  String uid = await getUidOfCurrentlySignedInUser();
  Map<String, List<String>> groupMap = new Map();
  groupMap[groupName] = userID;
  WriteBatch writeBatch = firebaseInstance.batch();
  writeBatch.setData(
      firebaseInstance.collection(COLLECTION).document(uid), groupMap,
      merge: true);
  writeBatch.commit();
}
