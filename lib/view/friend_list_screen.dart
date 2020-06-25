import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/user_profile_service.dart';
import 'package:univents/model/friend_model.dart';
import 'package:univents/model/group_model.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/user_profile.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/service/friendlist_service.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';
import 'package:univents/view/dialogs/debouncer.dart';
import 'package:univents/view/dialogs/dialog_helper.dart';
import 'package:univents/view/dialogs/friend_list_dialog.dart';

/// @author Christian Henrich
///
/// this screen represents the UI for the friendslist of a user and also the list of groups in which you can organize your friends

class FriendlistScreen extends StatefulWidget {
  @override
  _FriendlistScreenState createState() => _FriendlistScreenState();
}

/// this class creates a screen with a searchbar at the top to filter through your friends (not implemented yet) and a
/// button at the bottom to add new friends, and a button used to display groups depending on the bool [isFriendsScreen] to avoid code duplication!
/// you can also create new groups through a button that only gets shown in the groups screen and add friends to it
class _FriendlistScreenState extends State<FriendlistScreen> {
  /// debouncer makes sure the query in the searchbar doesn't get read out until 500ms of no new user input
  final _debouncer = new Debouncer(500);

  /// if this bool is set to true it shows a list of all friends of the currently signed in user, if it is set to false it shows a list of all the
  /// groups the user has created to organize his friends
  bool isFriendsScreen = true;

  /// group models for visualization purposes
  List<GroupModel> groups = new List();

  /// friend models for visualization purposes
  List<FriendModel> friends = new List();

  /// map that holds all UIDs of the friends of currently signed in user retrieved from backend
  Map<String, dynamic> friendsMap = new Map();

  /// map that holds all [userprofiles] of the friends of currently signed in user retrieved from backend
  Map<String, dynamic> profileMap = new Map();

  /// map that holds all [profilepictures] of the friends of currently signed in user retrieved from backend
  Map<String, dynamic> profilePicMap = new Map();

  /// result of the async data from [initState()]
  var _result;

  /// async method that retrieves all needed data from the backend before Widget Build runs and shows the screen to the user
  Future<bool> loadAsyncData() async {
    try {
      friendsMap =
      await getFriends(); // save all UIDs of friends into [friendsMap] from backend
    } on Exception catch (e) {
      show_toast(e.toString());
      Log().error(
          causingClass: 'friendList_screen',
          method: 'loadAsyncData',
          action: e.toString());
    }
    if (friendsMap !=
        null) { // if the user has friends, retrieve all groupings from backend and save into the list [groups]
      for (String s in friendsMap.keys) {
        groups.add(GroupModel(name: s, grouppicture: "mango.png"));
      }
    }
    if (friendsMap != null && friendsMap.containsKey('friends')) {
      List<dynamic> friend = friendsMap['friends'];
      for (String s in friend) {
        try {
          // create all the different user profiles from the UIDs of the retrieved friends
          UserProfile up = await getUserProfile(s);
          Widget profilePicture = await getProfilePicture(s);
          profileMap[s] = up;
          profilePicMap[s] = profilePicture;
          friends.add(FriendModel(
              uid: s,
              name: up.username,
              profilepic: profilePicture == null
                  ? Image.asset('assets/blank_profile.png')
                  : profilePicture));
        } on Exception catch (e) {
          show_toast(e.toString());
          Log().error(
              causingClass: 'friendList_screen',
              method: 'loadAsyncData',
              action: e.toString());
        }
      }
    } else {
      // if you dont have any friends added yet an empty list is created and the user sees an empty friends list as well, the user still has the
      // option to add new friends
      friends = new List();
    }
    return true;
  }

  @override
  void initState() {
    loadAsyncData().then((result) {
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // while the needed data to fill the screen gets retrieved from the backend by [loadAsyncData()] show a CircularProgressIndicator loading circle
    if (_result == null) {
      return CircularProgressIndicator();
    } else { // when all the data was collected (_result != null) show the screen
      return Card(
        child: Scaffold(
          backgroundColor: univentsLightGreyBackground,
          body: Column(
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: isFriendsScreen == true
                        ? AppLocalizations.of(context)
                            .translate('search_for_friend')
                        : AppLocalizations.of(context)
                            .translate('search_for_group'),
                  ),
                  onChanged: (string) {
                    //debouncer makes sure the user input only gets registered after 500ms to give the user time to input the full search query
                    _debouncer.run(() {
                      print(string);
                    });
                  }),
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
                                    ? showProfileScreen(
                                        context, friends[index].uid)
                                    : fillGroupWithFriends(groups[index].name);
                                isFriendsScreen = true;
                              });
                            },
                            title: isFriendsScreen == true
                                ? Text(friends[index].name)
                                : Text(groups[index].name),
                            leading: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {},
                              child: isFriendsScreen == true
                                  ? friends[index].profilepic
                                  : CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/${groups[index].grouppicture}'),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              isFriendsScreen == true
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 340.0, bottom: 5.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                isFriendsScreen =
                                false; // switch between friendslistscreen and group screen
                              });
                            },
                            child: Icon(Icons.group),
                            backgroundColor: primaryColor,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 340.0, bottom: 5.0),
                          child: FloatingActionButton(
                            onPressed: () {
                              showAddFriendsDialog(
                                  context); // calls [addFriends_dialog] where the user can add new friends
                            },
                            child: Icon(Icons.group_add),
                            backgroundColor: primaryColor,
                          ),
                        ),
                      ],
                    )
                  : Column(children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 340.0, bottom: 5.0),
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              friends.clear();
                              if (friendsMap != null &&
                                  friendsMap.containsKey('friends')) {
                                List<dynamic> friend = friendsMap['friends'];
                                for (String s in friend) {
                                  UserProfile userProfile = profileMap[s];
                                  Widget profilepic = profilePicMap[s];
                                  friends.add(FriendModel(
                                      uid: s,
                                      name: userProfile.username,
                                      profilepic: profilepic == null
                                          ? Image.asset(
                                              'assets/blank_profile.png')
                                          : profilepic));
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
                        padding:
                            const EdgeInsets.only(left: 340.0, bottom: 5.0),
                        child: FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: () async {
                            try {
                              final Map<String, dynamic> result =
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FriendslistdialogScreen
                                                  .create())); // create a new group and add friends to it
                              String groupname = result.keys.elementAt(0);
                              createGroupFriend(result[groupname], groupname);
                            } on Exception catch (e) {
                              show_toast(e.toString());
                              Log().error(
                                  causingClass: 'friendList_screen',
                                  method: 'build',
                                  action: e.toString());
                            }
                          },
                          child: Icon(Icons.add),
                          backgroundColor: primaryColor,
                        ),
                      ),
                    ]),
            ],
          ),
        ),
      );
    }
  }

  /// this method gets called when the user taps on a group. All the friends of the list [friends] get deleted and the list gets filled with only the friends
  /// of the group that got tapped on so the screen now shows a filtered friendslist with only the friends that are a port of the respective group
  void fillGroupWithFriends(String groupname) async {
    friends.clear();
    if (friendsMap != null && friendsMap.containsKey(groupname)) {
      List<dynamic> friend = friendsMap[groupname];
      for (String s in friend) {
        UserProfile userProfile = profileMap[s];
        Widget profilepic = profilePicMap[s];
        friends.add(FriendModel(
            uid: s,
            name: userProfile.username,
            profilepic: profilepic == null
                ? Image.asset('assets/blank_profile.png')
                : profilepic));
      }
    }
  }
}
