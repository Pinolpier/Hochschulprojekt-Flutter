import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';
import 'package:univents/service/utils/utils.dart';
import 'package:univents/view/dialogs/DialogHelper.dart';

/// @author Christian Henrich

/// This Eventinfoscreen shows a description of the event and also its attendees in a horizontal listview at the bottom
/// Furthermore it shows information like an event picture, how many people will attend, open or closed and also adds functionality
/// so that the user can change the event picture and set the event to private or open
class EventInfo extends StatefulWidget {
  /// matching event data that should get shown
  final Event _event;

  /// passes the matching event data of the event whose information should get shown on the screen
  EventInfo(this._event, {Key key}) : super(key: key);

  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  /// current datetime in milliseconds
  DateTime now = new DateTime.fromMicrosecondsSinceEpoch(
      new DateTime.now().millisecondsSinceEpoch);

  /// this bool is set to true if the event is public and false if the event is private
  bool isEventOpen = true;

  /// how many people promised to attend
  int eventAttendeesCount = 400;

  /// the date on which the event holds place
  String eventDate = "24.04";

  /// name of the event
  String eventName = "EventName";

  /// location of the event
  String eventLocation = 'Hochschule Heilbronn';

  /// description of the event (set by event creator)
  String eventText = 'Lorem Ipsum';

  /// event image
  File eventImage;

  /// event image retrieved from database
  File eventImageAsync;

  ///eventPicture from Firebase (if available)
  Widget eventimagewidget;

  /// result of the async data from [initState()]
  bool _result;

  /// UIDs of all users that will attend in the event
  List<dynamic> attendees;

  /// profilepictures of all users that will attend in the event
  List<Widget> profilePictureList = new List();

  ImagePickerUnivents ip = new ImagePickerUnivents();

  /// gets displayed if no eventImage is specified or eventImage is deleted
  Widget _eventImagePlaceholder() {
    return GestureDetector(
        onTap: () async {
          eventimagewidget = null;
          eventImageAsync = await ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
            updateImage(eventImage, widget._event);
          });
        },
        child: Image.asset('assets/eventImagePlaceholder.png',
            height: 150)); // placeholder image if no event image was set yet
  }

  ///gets displaced if eventImage gets changed
  Widget _eventImage() {
    return GestureDetector(
        onTap: () async {
          eventimagewidget = null;
          eventImageAsync = await ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
            updateImage(eventImage, widget._event);
          }); // handle your image tap here
        },
        child: Image.file(eventImage, height: 150));
  }

  ///gets displayed if Event has an eventImage in Database
  Widget _eventImageFromDatabase() {
    return GestureDetector(
        onTap: () async {
          eventimagewidget = null;
          eventImageAsync = await ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
            updateImage(eventImage, widget._event);
          }); // handle your image tap here
        },
        child: eventimagewidget != null
            ? eventimagewidget
            : eventImage == null
                ? Image.asset('assets/eventImagePlaceholder.png', height: 150)
                : Image.file(
                    eventImage,
                    height: 150.0,
                  ));
  }

  ///adds share functionality to share event
  void share(BuildContext context, String text) {
    final RenderBox box = context.findRenderObject(); //fix for iPad

    Share.share(
      text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  /// async method that retrieves all needed data from the backend before Widget Build runs and shows the screen to the user
  Future<bool> loadAsyncData() async {
    if (widget._event.imageURL != null) {
      try {
        eventimagewidget = await getImage(widget._event.eventID);
      } on Exception catch (e) {
        Log().error(
            causingClass: 'eventInfo_screen',
            method: 'loadAsyncData',
            action: e.toString());
      }
    } else {
      eventimagewidget = null;
    }

    attendees = widget._event.attendeesIds;
    try {
      int index = 0;
      for (String uid in attendees) {
        //TODO maybe don't load all profilepictures
        if (index < attendees.length) {
          Widget pp = await getProfilePicture(uid);
          if (pp != null) {
            profilePictureList
                .add(ClipOval(child: await getProfilePicture(uid)));
            index++;
          } else {
            profilePictureList
                .add(ClipOval(child: Image.asset('assets/blank_profile.png')));
            index++;
          }
        } else {
          break;
        }
      }
    } on Exception catch (e) {
      Log().error(
          causingClass: 'eventInfo_screen',
          method: 'loadAsyncData',
          action: e.toString());
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
    isEventOpen = !widget._event.privateEvent;
    eventAttendeesCount = widget._event.attendeesIds.length;
    eventDate = format_date_time(context, widget._event.eventStartDate);
    //widget.event.eventStartDate.toIso8601String();
    eventName = widget._event.title;
    eventLocation = widget._event.location;
    eventText = widget._event.description;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: _result == null
                ? CircularProgressIndicator()
                : _eventImageFromDatabase() != null
                    ? _eventImageFromDatabase()
                    : eventImage == null
                        ? _eventImagePlaceholder()
                        : _eventImage(),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.1,
            initialChildSize: 0.22,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  color: univentsWhiteBackground,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32, top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: _result == null
                                  ? CircularProgressIndicator()
                                  : _eventImageFromDatabase() != null
                                      ? _eventImageFromDatabase()
                                      : eventImage == null
                                          ? _eventImagePlaceholder()
                                          : _eventImage(),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    eventName,
                                    style: TextStyle(
                                        color: univentsBlackText,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    eventLocation,
                                    style: TextStyle(
                                        color: univentsGreyText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  share(
                                      context,
                                      'Eventtitel: ' +
                                          widget._event.title +
                                          '\n' +
                                          'Eventort: ' +
                                          widget._event.location +
                                          '\n' +
                                          'Eventinfo: ' +
                                          widget._event.description +
                                          '\n' +
                                          'Start: ' +
                                          widget._event.eventStartDate
                                              .toString() +
                                          '\n' +
                                          'Ende: ' +
                                          widget._event.eventEndDate
                                              .toString() +
                                          '\n');
                                },
                                child: Icon(
                                  Icons.share,
                                  color: Colors.blue,
                                  size: 40,
                                ))
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(32),
                        color: primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isEventOpen = !isEventOpen;
                                            widget._event.privateEvent =
                                                isEventOpen;
                                            try {
                                              updateData(widget._event);
                                            } on Exception catch (e) {
                                              Log().error(
                                                  causingClass:
                                                      'eventInfo_screen',
                                                  method: 'build',
                                                  action: e.toString());
                                            }
                                          });
                                        },
                                        child: isEventOpen == true
                                            ? Icon(
                                                Icons.lock_open,
                                                color: univentsWhiteBackground,
                                                size: 30,
                                              )
                                            : isEventOpen == false
                                                ? Icon(
                                                    Icons.lock,
                                                    color:
                                                        univentsWhiteBackground,
                                                    size: 30,
                                                  )
                                                : null),
                                    SizedBox(width: 4.0),
                                    isEventOpen == true
                                        ? Text("open",
                                            style: TextStyle(
                                                color: univentsWhiteText,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24))
                                        : Text("closed",
                                            style: TextStyle(
                                                color: univentsWhiteText,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24))
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.favorite,
                                      color: univentsWhiteBackground,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      eventAttendeesCount.toString(),
                                      style: TextStyle(
                                          color: univentsWhiteText,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24),
                                    )
                                  ],
                                ),
                                Text(
                                  "Attendees",
                                  style: TextStyle(
                                      color: univentsWhiteText,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(32),
                        color: primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.calendar_today,
                                      color: univentsWhiteBackground,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      eventDate,
                                      style: TextStyle(
                                          color: univentsWhiteText,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24),
                                    )
                                  ],
                                ),
                                Text(
                                  "Startdate",
                                  style: TextStyle(
                                      color: univentsWhiteText,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      //container for about me

                      SizedBox(
                        height: 16,
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Description",
                              style: TextStyle(
                                  color: univentsBlackText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              eventText,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 16,
                      ),
                      //Container for clients

                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Attendees",
                              style: TextStyle(
                                  color: univentsBlackText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),

                            SizedBox(
                              height: 8,
                            ),
                            //for list of clients
                            Container(
                              width: MediaQuery.of(context).size.width - 64,
                              height: 80,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      //TODO: Open profile of clicked user and show if he promised to attened the event, denied or hasnt decided yet
                                    },
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      margin: EdgeInsets.only(right: 8),
                                      child: _result == null
                                          ? null
                                          : profilePictureList[index],
                                    ),
                                  );
                                },
                                itemCount: eventAttendeesCount,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                              ),
                            ),

                            SizedBox(
                              height: 16,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: FloatingActionButton(
                                onPressed: () {
                                  showFriendsDialogEvent(
                                      context, widget._event);
                                },
                                child: Icon(Icons.group_add),
                                backgroundColor: primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
