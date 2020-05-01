import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Model/event.dart';

class FeedItemUI extends StatelessWidget {
  final Event _data;

  FeedItemUI(this._data);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: (MediaQuery.of(context).size.height * 1 / 2),
        color: Colors.white, //TODO: get color from color class
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://i.imgflip.com/syi19.jpg', //TODO: set variable from avatar
                ),
              ),
              title: Text(this._data.title),
              subtitle: Text(this._data.eventStartDate.toString() +
                  "\n - \n" +
                  this._data.eventEndDate.toString() +
                  "\n" +
                  this._data.location),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      //TODO: provide generic image from "createEvent"
                      'https://images.eventpeppers.com/sites/default/files/imagecache/lightbox-xs/content/18-05/disco-feiern-abends.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height / 50),
            ),
            // FeedActionBar(),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Event get data => data;
}
