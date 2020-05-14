import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/View/dialogs/DialogHelper.dart';
import 'package:univents/service/utils/imagePickerUnivents.dart';

/// This Eventinfoscreen shows a description of the event and also its attendees in a horizontal listview at the bottom
/// Furthermore it shows stuff like an event picture, how many people will attend, open or closed and also adds functionality
/// so that the user can change the event picture and set the event to private or open
class EventInfo extends StatefulWidget {
  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  DateTime now = new DateTime.fromMicrosecondsSinceEpoch(
      new DateTime.now().millisecondsSinceEpoch);

  /// if the event is open for everyone or private
  bool isEventOpen = true;

  /// how many people promised to attend
  String eventAttendeesCount = "400";

  /// the date on which the event holds place
  String eventDate = "24.04";

  /// name of the event
  String eventName = "EventName";

  /// location of the event
  String eventLocation = 'Hochschule Heilbronn';

  /// description of the event (set by event creator)
  String eventText =
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';

  /// eventpicture
  File eventImage;

  Widget _eventImagePlaceholder() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
          });
        }, // handle your image tap here
        child: Image.asset('assets/eventImagePlaceholder.png', height: 150));
  }

  Widget _eventImage() {
    return GestureDetector(
        onTap: () async {
          File eventImageAsync = await chooseImage(context);
          setState(() {
            print(eventImageAsync);
            eventImage = eventImageAsync;
          }); // handle your image tap here
        },
        child: Image.file(eventImage, height: 150));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset(
              "assets/loginbackground.jpg",
              fit: BoxFit.cover,
            ),
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
                              child: eventImage == null
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
                                  print("event share button got pressed");
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
                                      eventAttendeesCount,
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
                                itemCount: int.parse(eventAttendeesCount),
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
