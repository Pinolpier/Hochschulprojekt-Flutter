import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/Controller/authService.dart';
import 'package:univents/Controller/userProfileService.dart';
import 'package:univents/model/friendGroup.dart';

final String COLLECTION = 'friends';
final firebaseInstance = Firestore.instance;

void addFriendbyEmail(String email) async {
  String uid = await getUidOfCurrentlySignedInUser();
  String friendID = await getUidFromEmail(email);
  Map<String, String> friendMap;
  firebaseInstance.collection(COLLECTION).document(uid).updateData(friendMap);
}

void addFriendbyUsername(String username) async {
  String uid = await getUidOfCurrentlySignedInUser();
  String friendid = await getUidFromUserName(username);
  Map<String, List<String>> dataMap;
  dataMap['friends'] = [friendid];
  firebaseInstance.collection(COLLECTION).document(uid).updateData(dataMap);
}

void removeFriend(String friendid) async {
  firebaseInstance.collection(COLLECTION).document(
      getUidOfCurrentlySignedInUser());
}

Future<List<String>> getFriends() async {
  String uid = await getUidOfCurrentlySignedInUser();
  DocumentSnapshot documentSnapshot = await firebaseInstance.collection(
      COLLECTION).document(uid).get();
}

void getFriendsbyGroups() async {

}

void groupFriend(String userID, String groupName,
    FriendGroup friendGroup) async {
  String uid = await getUidOfCurrentlySignedInUser();
  Map<String, List<String>> groupMap;
  groupMap[groupName] = [userID];
  firebaseInstance.collection(COLLECTION).document(uid).updateData(groupMap);
}
