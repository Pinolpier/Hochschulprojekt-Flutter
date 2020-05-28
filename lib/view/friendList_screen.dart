import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/FriendslistDummies.dart';
import 'package:univents/model/GroupDummies.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/service/friendlist_service.dart';
import 'package:univents/view/dialogs/Debouncer.dart';
import 'package:univents/view/dialogs/DialogHelper.dart';
import 'package:univents/view/dialogs/friendList_dialog.dart';
import 'package:univents/view/profile_screen.dart';

class FriendlistScreen extends StatefulWidget {
  @override
  _FriendlistScreenState createState() => _FriendlistScreenState();
}

/**
 * this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
 * button at the bottom to add new friends, also used to display groups depending on the bool [isFriendsScreen] to avoid code duplication!
 */
class _FriendlistScreenState extends State<FriendlistScreen> {
  final _debouncer = new Debouncer(500);
  bool isFriendsScreen = true;
  List<GroupDummies> groups = new List();
  List<FriendslistDummies> friends = new List();
  Map<String, dynamic> friendsMap = new Map();
  Map<String, dynamic> profileMap = new Map();
  Map<String, dynamic> profilePicMap = new Map();

  var _result;

  Future<bool> loadAsyncData() async {
    friendsMap = await getFriends();
    for(String s in friendsMap.keys) {
      groups.add(GroupDummies(name: s, profilepic: "mango.png"));
    }
    if(friendsMap != null && friendsMap.containsKey('friends')) {
      List<dynamic> friend = friendsMap['friends'];
      for(String s in friend) {
        UserProfile up = await getUserProfile(s);
        Widget profilePicture = await getProfilePicture(s);
        profileMap[s] = up;
        profilePicMap[s] = profilePicture;
        friends.add(FriendslistDummies(uid: s, name: up.username, profilepic: profilePicture == null ? Image.asset('assets/blank_profile.png') : profilePicture));
      }
    } else {
      friends = new List();
    }

    return true;
  }

  @override
  void initState() {
    loadAsyncData().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return CircularProgressIndicator();
    } else {
      return Card(
        child: Scaffold(
          backgroundColor: univentsLightGreyBackground,
          body: Column(
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: isFriendsScreen == true ? AppLocalizations.of(
                        context)
                        .translate('search_for_friend') : AppLocalizations.of(
                        context)
                        .translate('search_for_group'),
                  ),
                  onChanged: (string) {
                    //debouncer makes sure the user input only gets registered after 500ms to give the user time to input the full search query
                    _debouncer.run(() {
                      print(string);
                    });
                  }
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: isFriendsScreen == true ? friends.length : groups
                        .length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 6.0),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                isFriendsScreen == true
                                    ? showProfileScreen(context, friends[index].uid)
                                    : doStuff(groups[index].name);
                                isFriendsScreen = true;
                              });
                            },
                            title: isFriendsScreen == true ? Text(
                                friends[index].name) : Text(groups[index].name),
                            leading: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {},
                              child: isFriendsScreen == true ? friends[index].profilepic : CircleAvatar(backgroundImage: AssetImage('assets/${groups[index].profilepic}'), //TODO Gruppenvorschaubild ändern können ? Rücksprache mit PO Markus Link
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
              isFriendsScreen == true ? Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          isFriendsScreen = false;
                        });
                      },
                      child: Icon(Icons.group),
                      backgroundColor: primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        showAddFriendsDialog(context);
                      },
                      child: Icon(Icons.group_add),
                      backgroundColor: primaryColor,
                    ),
                  ),
                ],
              )
                  : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        friends.clear();
                        if (friendsMap != null && friendsMap.containsKey('friends')) {
                          List<dynamic> friend = friendsMap['friends'];
                          for (String s in friend) {
                            UserProfile userProfile = profileMap[s];
                            Widget profilepic = profilePicMap[s];
                            friends.add(FriendslistDummies(uid: s,
                                name: userProfile.username,
                                profilepic: profilepic == null ? Image.asset(
                                    'assets/blank_profile.png') : profilepic));
                          }
                        }
                        isFriendsScreen = true;
                      });
                    },
                    child: Icon(Icons.group),
                    backgroundColor: primaryColor,
                  ),
                ),
                Padding(
                padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
                child: FloatingActionButton(
                  heroTag: "btn1",
                    onPressed: () async {
                      final Map<String, dynamic> result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FriendslistdialogScreen.create()));
                      String groupname = result.keys.elementAt(0);
                      createGroupFriend(result[groupname], groupname);
                    },
                    child: Icon(Icons.add),
                    backgroundColor: primaryColor,
                ),
              ),]
                  ),
            ],
          ),
        ),
      );
    }
  }

  void doStuff(String groupname) async {
    friends.clear();
    if (friendsMap != null && friendsMap.containsKey(groupname)) {
      List<dynamic> friend = friendsMap[groupname];
      for (String s in friend) {
        UserProfile userProfile = profileMap[s];
        Widget profilepic = profilePicMap[s];
        friends.add(FriendslistDummies(uid: s,
            name: userProfile.username,
            profilepic: profilepic == null ? Image.asset(
                'assets/blank_profile.png') : profilepic));
      }
    }
  }
}