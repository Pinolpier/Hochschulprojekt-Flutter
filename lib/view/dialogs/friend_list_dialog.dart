import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/backend/event_service.dart';
import 'package:univents/backend/friend_list_service.dart';
import 'package:univents/backend/user_profile_service.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/model/frontend/friend_model.dart';
import 'package:univents/model/user_profile.dart';
import 'package:univents/service/debouncer.dart';
import 'package:univents/service/dialog_helper.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/toast.dart';

/// @author Christian Henrich
///
/// this is a custom version of the [friendsList_screen] that should be used as a dialog for the [eventInfo_screen] screen later to add
/// an option to directly invite friends to events and also to add new users to a group in the [friendsList_screen]
class FriendslistdialogScreen extends StatefulWidget {
  /// data of the event where this dialog got called from
  Event event;

  /// helper bool to distinct between the 2 constructors that get used dependent on where they got called from
  bool create = false;

  List<String> preSelectedAttendeeIDs;

  /// this constructor gets called whenever you want to add users to an event and gets called from [eventInfo_screen] or [createEvent_screen]
  FriendslistdialogScreen(Event event, [List<String> preSelectedAttendeeIDs]) {
    this.event = event;
    this.preSelectedAttendeeIDs =
        preSelectedAttendeeIDs == null ? List() : preSelectedAttendeeIDs;
  }

  /// this constructor gets called whenever you want to add friends to a group in [friendsList_screen]
  FriendslistdialogScreen.create() {
    create = true;
  }

  /// todo: missing documentation
  @override
  _FriendlistdialogScreenState createState() => create
      ? _FriendlistdialogScreenState.create()
      : _FriendlistdialogScreenState(event, preSelectedAttendeeIDs);
}

/// this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
/// the option to mark several friends from your friends list via LongPress and confirm your choice through a button at the bottom right
class _FriendlistdialogScreenState extends State<FriendslistdialogScreen> {
  /// this constructor gets called whenever you want to add users to an event and gets called from [eventInfo_screen] or [createEvent_screen]
  _FriendlistdialogScreenState(Event event,
      [List<String> preSelectedAttendeeIDs]) {
    this.event = event;
    this.preSelectedAttendeeIDs = preSelectedAttendeeIDs;
    this.selectedFriends = List();
    this.selectedCount = 0;
  }

  /// this constructor gets called whenever you want to add friends to a group in [friendsList_screen]
  _FriendlistdialogScreenState.create() {
    comeFromCreateEventScreen = false;
  }

  /// debouncer makes sure the query in the searchbar doesn't get read out until 500ms of no new user input
  final _debouncer = new Debouncer(500);

  /// this bool only gets set to true when the screen was called in the context of adding a user into an event, it gets set to false if it was called in the
  /// context of adding a user to a group of the [friendsList_screen]
  bool comeFromCreateEventScreen = true;

  /// amount of friends that got selected
  int selectedCount = 0;

  /// UIDs of all the selected friends to pass to the next screen
  Map<String, dynamic> friendsInGroup = new Map();
  List<FriendModel> friends = new List();
  List<FriendModel> selectedFriends;
  List<String> preSelectedAttendeeIDs;
  Event event;
  String groupname;

  /// result of the async data from [initState()]
  var _result;

  /// async method that retrieves all needed data from the backend before Widget Build runs and shows the screen to the user
  Future<bool> loadAsyncData() async {
    Map<String, dynamic> friendsMap = new Map();
    try {
      friendsMap = await getFriends();
    } on Exception catch (e) {
      show_toast(e.toString());
      Log().error(
          causingClass: 'friendList_dialog',
          method: 'loadAsyncData',
          action: e.toString());
    }
    if (friendsMap != null && friendsMap.containsKey('friends')) {
      List<dynamic> friend = friendsMap['friends'];
      try {
        for (String s in friend) {
          UserProfile up = await getUserProfile(s);
          print(up.toString());
          print(await getProfilePicture(s));
          Widget profilePicture = await getProfilePicture(s);

          bool isFriendModelSelected = preSelectedAttendeeIDs.contains(s);
          FriendModel friendModel = FriendModel(
              uid: s,
              name: up.username,
              isSelected: isFriendModelSelected,
              profilepic: profilePicture == null
                  ? Image.asset('assets/blank_profile.png')
                  : profilePicture);

          friends.add(friendModel);
          if (isFriendModelSelected) {
            selectedFriends.add(friendModel);
          }
        }
      } on Exception catch (e) {
        show_toast(e.toString());
        Log().error(
            causingClass: 'friendList_dialog',
            method: 'loadAsyncData',
            action: e.toString());
      }
    } else {
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
    } else {
      // when all the data was collected (_result != null) show the screen
      return Scaffold(
        backgroundColor: univentsLightGreyBackground,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text("Your Friendslist"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: comeFromCreateEventScreen == true
                        ? "search for a friend"
                        : "Enter a group name"),
                onChanged: (string) {
                  //debouncer makes sure the user input only gets registered after 500ms to give the user time to input the full search query
                  _debouncer.run(() {
                    print(string);
                    groupname = string;
                  });
                }),
            Expanded(
              child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        child: ListTile(
                          selected: friends[index].isSelected,
                          onTap: () {
                            setState(() {
                              friends[index].isSelected =
                              !friends[index].isSelected;
                              if (selectedFriends
                                  .contains(friends[index].uid)) {
                                selectedFriends.removeLast();
                              } else {
                                selectedFriends.add(friends[index]);
                              }
                            });
                          },
                          title: Text(friends[index].name),
                          trailing: (friends[index].isSelected)
                              ? Icon(Icons.check_box)
                              : Icon(Icons.check_box_outline_blank),
                          leading: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {},
                            child: friends[index].profilepic,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 340.0, bottom: 5.0),
              child: FloatingActionButton(
                onPressed: () {
                  comeFromCreateEventScreen == false
                      ? goBackToGroupScreen()
                      : event == null
                      ? Navigator.pop(context, selectedFriends)
                      : goBackToEventScreen();
                },
                child: Icon(Icons.check),
                backgroundColor: primaryColor,
              ),
            ),
          ],
        ),
      );
    }
  }

  /// this method gets called when all the friends got selected and the user confirms his choice through the button at the bottom right and updates
  /// the data of the matching event with all the new attendees
  void goBackToEventScreen() {
    for (FriendModel friendModel in selectedFriends) {
      List<String> newAttendees = new List();
      for (String s in event.attendeesIds) {
        newAttendees.add(s);
      }
      newAttendees.add(friendModel.uid);
      event.attendeesIds = newAttendees;
    }
    updateData(event);
    Navigator.pop(context);
  }

  /// this method gets called when all the friends got selected and the user confirms his choice through the button at the bottom right and requests the user
  /// to put in a group name for the group he just created with all the selected friends and sends him back to the group screen of [friendsList_screen] when done with
  /// the freshly created group shown in the screen now
  void goBackToGroupScreen() {
    if (groupname != null &&
        groupname.isNotEmpty &&
        selectedFriends.isNotEmpty) {
      friendsInGroup[groupname] = selectedFriends;
      Navigator.pop(context, friendsInGroup);
    } else if (groupname == null || groupname.isEmpty) {
      showErrorDialog(context, "Groupname invalid!",
          "Please enter a valid Group name", true);
    } else if (selectedFriends.isEmpty) {
      showErrorDialog(context, "invalid amount of friends!",
          "Please add at least 1 friend to the group", true);
    }
  }
}
