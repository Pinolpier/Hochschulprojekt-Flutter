import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/FriendslistDummies.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/model/userProfile.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/friendlist_service.dart';
import 'package:univents/view/dialogs/Debouncer.dart';
import 'package:univents/view/dialogs/DialogHelper.dart';

/// this is a custom version of the friendslistscreen widget that should be used as a dialog for the eventinfocreate screen later to add
/// an option to directly invite friends to events and also to add new users to a group
class FriendslistdialogScreen extends StatefulWidget {
  Event event;
  bool create = false;

  FriendslistdialogScreen(Event event) {
    this.event = event;
  }

  FriendslistdialogScreen.create() {
    create = true;
  }

  @override
  _FriendlistdialogScreenState createState() => create
      ? _FriendlistdialogScreenState.create()
      : _FriendlistdialogScreenState(event);
}

/// this class creates a friendslist with a searchbar at the top to filter through the friends (not implemented yet) and a
/// button at the bottom to create a new message
class _FriendlistdialogScreenState extends State<FriendslistdialogScreen> {
  _FriendlistdialogScreenState(Event event) {
    this.event = event;
  }

  _FriendlistdialogScreenState.create() {}

  final _debouncer = new Debouncer(500);
  bool longPressFlag = false;
  bool comeFromCreateEventScreen = true;
  int selectedCount = 0;
  List<String> selected = List();
  List<FriendslistDummies> friends = new List();
  Event event;

  void longPress() {
    setState(() {
      if (friends.isEmpty) {
        longPressFlag = false;
      } else {
        longPressFlag = true;
      }
    });
  }

  var _result;

  Future<bool> loadAsyncData() async {
    Map<String, dynamic> friendsMap = await getFriends();
    if (friendsMap != null && friendsMap.containsKey('friends')) {
      List<dynamic> friend = friendsMap['friends'];
      for (String s in friend) {
        UserProfile up = await getUserProfile(s);
        print(up.toString());
        print(await getProfilePicture(s));
        Widget profilePicture = await getProfilePicture(s);
        friends.add(FriendslistDummies(
            uid: s,
            name: up.username,
            profilepic: profilePicture == null
                ? Image.asset('assets/blank_profile.png')
                : profilePicture));
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
                    hintText: "search for a friend"),
                onChanged: (string) {
                  //debouncer makes sure the user input only gets registered after 500ms to give the user time to input the full search query
                  _debouncer.run(() {
                    print(string);
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
                          onLongPress: () {
                            setState(() {
                              friends[index].isSelected =
                                  !friends[index].isSelected;
                              if (selected.contains(friends[index].uid)) {
                                selected.removeLast();
                              } else {
                                selected.add(friends[index].uid);
                              }
                            });
                          },
                          selected: friends[index].isSelected,
                          onTap: () {
                            print(friends[index].name + " was pressed");
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
                      ? showChangeGroup(context)
                      : event == null
                          ? Navigator.pop(context, selected)
                          : doStuff();
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

  void doStuff() {
    for (String a in selected) {
      List<String> newAttendees = new List();
      for (String s in event.attendeesIds) {
        newAttendees.add(s);
      }
      newAttendees.add(a);
      event.attendeesIds = newAttendees;
    }
    updateData(event);
    Navigator.pop(context);
  }
}
