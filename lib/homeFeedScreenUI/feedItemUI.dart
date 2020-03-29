import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/feedActionBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//@author mdarscht
class FeedItemUI extends StatelessWidget {
/*
  final DateTime _eventStartDate;
  final DateTime _eventEndDate;
  final _duration;
  final String _details;
  final String _city;
  final bool _privateEvent;
*/
  FeedItemUI({Key key,}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: (MediaQuery.of(context).size.height*1/2),
        color: Colors.white, //TODO: get color from color class
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.imgflip.com/syi19.jpg', //TODO: set variable from avatar
                ),
              ),
              title: Text('Some Event Title'), //TODO: provide generic variable from "createEvent"
              subtitle: Text(' 12.12.2019'), //TODO: provide generic variable from "createEvent" & put in more information
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage( //TODO: provide generic image from "createEvent"
                        'https://images.eventpeppers.com/sites/default/files/imagecache/lightbox-xs/content/18-05/disco-feiern-abends.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: (MediaQuery.of(context).size.height/50),),
            FeedActionBar(),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }
}

