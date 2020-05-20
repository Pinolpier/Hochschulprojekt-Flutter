import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';
import 'package:univents/view/dialogs/DialogHelper.dart';

/// This Eventinfoscreen shows a description of the event and also its attendees in a horizontal listview at the bottom
/// Furthermore it shows stuff like an event picture, how many people will attend, open or closed and also adds functionality
/// so that the user can change the event picture and set the event to private or open
class EventInfo extends StatefulWidget {
  final Event event;

  EventInfo(this.event, {Key key}) : super(key: key);

  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  DateTime now = new DateTime.fromMicrosecondsSinceEpoch(
      new DateTime.now().millisecondsSinceEpoch);

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

  /// eventpicture
  File eventImage;

  File eventImageAsync;

  ///eventPicture from Firebase (if available)
  Widget eventimagewidget;

  bool _result;

  ImagePickerUnivents ip = new ImagePickerUnivents();

  Widget _eventImagePlaceholder() {
    return GestureDetector(
        onTap: () async {
          eventimagewidget = null;
          eventImageAsync = await ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
            updateImage(eventImage, widget.event);
          }); // handle your image tap here
        }, // handle your image tap here
        child: Image.asset('assets/eventImagePlaceholder.png', height: 150));
  }

  Widget _eventImage() {
    return GestureDetector(
        onTap: () async {
          eventimagewidget = null;
          eventImageAsync = await ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
            updateImage(eventImage, widget.event);
          }); // handle your image tap here
        },
        child: Image.file(eventImage, height: 150));
  }

  Widget _eventImageFromDatabase() {
    return GestureDetector(
        onTap: () async {
          eventimagewidget = null;
          eventImageAsync = await ip.chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
            updateImage(eventImage, widget.event);
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

  void share(BuildContext context, String text) {
    final RenderBox box = context.findRenderObject(); //fix for iPad

    Share.share(
      text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future<bool> loadAsyncData() async {
    await signInWithEmailAndPassword("j.oster@gmx.net", "pass1234");
    if (widget.event.imageURL != null) {
      try {
        eventimagewidget = await getImage(widget.event.eventID);
      } on Exception catch (e) {
        print(e);
      }
    } else {
      eventimagewidget = null;
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
    isEventOpen = !widget.event.privateEvent;
    eventAttendeesCount = widget.event.attendeesIds.length;
    eventDate = widget.event.eventStartDate.toIso8601String();
    eventName = widget.event.title;
    eventLocation = widget.event.location;
    eventText = widget.event.description;

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
                  color: Colors.white,
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
                                        color: Colors.grey[800],
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    eventLocation,
                                    style: TextStyle(
                                        color: Colors.grey[500],
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
                                      'Eventtitel: ' + widget.event.title + '\n' +
                                          'Eventort: ' + widget.event.location + '\n' +
                                          'Eventinfo: ' + widget.event.description + '\n' +
                                          'Start: ' + widget.event.eventStartDate.toString() + '\n' +
                                          'Ende: ' + widget.event.eventEndDate.toString() + '\n');
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
                        color: Colors.blue,
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
                                          });
                                        },
                                        child: isEventOpen == true
                                            ? Icon(
                                                Icons.lock_open,
                                                color: Colors.white,
                                                size: 30,
                                              )
                                            : isEventOpen == false
                                                ? Icon(
                                                    Icons.lock,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )
                                                : null),
                                    SizedBox(width: 4.0),
                                    isEventOpen == true
                                        ? Text("open",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24))
                                        : Text("closed",
                                            style: TextStyle(
                                                color: Colors.white,
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
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      eventAttendeesCount.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24),
                                    )
                                  ],
                                ),
                                Text(
                                  "Attendees",
                                  style: TextStyle(
                                      color: Colors.white,
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
                        color: Colors.blue,
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
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      eventDate,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24),
                                    )
                                  ],
                                ),
                                Text(
                                  "Startdate",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                  //TODO maybe add start time and end date + time @Christian Henrich
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
                                  color: Colors.grey[800],
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
                                  color: Colors.grey[800],
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
                                      child: ClipOval(
                                        child: Image.network(
                                          "https://www.beautycastnetwork.com/images/banner-profile_pic.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
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
                                  DialogHelper.showFriendsDialog(context);
                                },
                                child: Icon(Icons.group_add),
                                backgroundColor: Colors.blueAccent,
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
