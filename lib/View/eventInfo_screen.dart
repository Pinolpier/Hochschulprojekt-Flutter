import 'package:flutter/material.dart';

/**
 * This class represents a Screen for Event informations
 * The Event text is scrollable and the date and location stay always on button on screen
 */
class EventInfo extends StatelessWidget{
  @override
  DateTime now = new DateTime.fromMicrosecondsSinceEpoch(new DateTime.now().millisecondsSinceEpoch);
  bool isEventOpen = true;
  String eventAttendeesCount = "400";
  String eventDate = "24.04";
  String eventName = "EventName";
  String eventLocation = 'Hochschule Heilbronn';
  String eventText = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset("assets/loginbackground.jpg", fit: BoxFit.cover,),
          ),

          DraggableScrollableSheet(
            minChildSize: 0.1,
            initialChildSize: 0.22,
            builder: (context, scrollController){
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //for user profile header
                      Container(
                        padding : EdgeInsets.only(left: 32, right: 32, top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: ClipOval(
                                  // logo of the event
                                  child: Image.asset('assets/eventlogo.png', fit: BoxFit.cover,),
                                )
                            ),

                            SizedBox(width: 16,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(eventName, style: TextStyle(color: Colors.grey[800],
                                      fontSize: 36, fontWeight: FontWeight.w700
                                  ),),
                                  Text(eventLocation, style: TextStyle(color: Colors.grey[500],
                                      fontSize: 16, fontWeight: FontWeight.w400
                                  ),),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("event share button got pressed");
                              },
                                child: Icon(Icons.share, color: Colors.blue, size: 40,)
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),

                      //performace bar

                      SizedBox(height: 10,),
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
                                    Icon(Icons.lock, color: Colors.white, size: 30,),
                                    SizedBox(width: 4,),

                                       isEventOpen == true ? Text("open", style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24
                                        ),) : isEventOpen == false ? Text("closed", style: TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.w700,
                                         fontSize: 24
                                       ),) : null
                                  ],
                                ),
                              ],
                            ),

                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.favorite, color: Colors.white, size: 30,),
                                    SizedBox(width: 4,),
                                    Text(eventAttendeesCount, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,
                                        fontSize: 24
                                    ),)
                                  ],
                                ),

                                Text("Attendees", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,
                                    fontSize: 15
                                ),)
                              ],
                            ),

                            Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.calendar_today, color: Colors.white, size: 30,),
                                    SizedBox(width: 4,),
                                    Text(eventDate, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,
                                        fontSize: 24
                                    ),)
                                  ],
                                ),

                                Text("Startdate", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400,
                                    fontSize: 15
                                ),)
                              ],
                            ),
                          ],
                        ),
                      ),
                      //container for about me

                      SizedBox(height: 16,),

                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text("Description", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700,
                                fontSize: 18
                            ),),

                            SizedBox(height: 8,),
                            Text(eventText,
                              style: TextStyle(fontSize: 15),
                            ),

                          ],
                        ),
                      ),

                      SizedBox(height: 16,),
                      //Container for clients

                      Container(
                        padding: EdgeInsets.only(left: 32, right: 32),
                        child: Column(
                          children: <Widget>[
                            Text("Attendees", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700,
                                fontSize: 18
                            ),),

                            SizedBox(height: 8,),
                            //for list of clients
                            Container(
                              width: MediaQuery.of(context).size.width-64,
                              height: 80,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    margin: EdgeInsets.only(right: 8),
                                    child: ClipOval(child: Image.network("https://www.beautycastnetwork.com/images/banner-profile_pic.jpg", fit: BoxFit.cover,),),
                                  );
                                },
                                itemCount: 10,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                              ),
                            ),

                            SizedBox(height: 16,),

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