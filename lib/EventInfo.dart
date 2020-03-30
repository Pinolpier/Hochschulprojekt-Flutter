import 'package:flutter/material.dart';

/**
 * This class represents a Screen for Event informations
 * The Event text is scrollable and the date and location stay always on button on screen
 * @author mhaering
 */
class EventInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.fromMicrosecondsSinceEpoch(new DateTime.now().millisecondsSinceEpoch);
    String location = 'Hochschule Heilbronn';
    String eventText = 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildBody(),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Text('Event:'+'\n' + eventText,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
              ),
            ),
          ),
          Container(
            child: Text('Event Starts on Day: '+ now.day.toString()+'.'+now.month.toString()+'.'+now.year.toString() ,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),),
          ),
          Container(
            child: Text('Location: '+location,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
    );
  }

  /**
   * This widget builder creates a stack widget to put the return button
   * on top of the Event-Image
   */
  Widget buildBody(){
    return Stack(
      children: <Widget>[
        Image(
          image: NetworkImage('https://www.mch-group.com/-/media/mch-group/Images/Content/News/Blog/2017/2017-04/mch-group-live-marketing-aktivierung.jpg'),
        ),
        BackButton(
          onPressed: (){
          },
        )
      ],
    );
  }
}