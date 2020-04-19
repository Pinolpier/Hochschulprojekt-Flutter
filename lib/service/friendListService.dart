import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/Controller/backendAPI.dart';

final firebaseInstance = Firestore.instance
    .collection(COLLECTION)
    .document(getUidOfCurrentlySignedInUser());
final String COLLECTION = 'friends';

void addFriend(String nutzerID) async {}

List<String> getFriends() {}

void getFriendsbyGroups() {}

void groupFriend(String userID) {}
