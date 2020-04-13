
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:univents/homeFeedScreenUI/feedItemUI.dart';
import 'package:univents/model/event.dart';

//@author
//for managing feed
class Feed {
  //widget list
  static List<Widget> _feed = List<Widget>();
  //data list
  static List<FeedItemUI> _feedOrientation = List<FeedItemUI>();

  static List<Widget> get feed => _feed;

  static addNewFeed(String title, Timestamp eventStartDate, Timestamp eventEndDate, String details, String city, bool privateEvent,String lat,String lng,String url) {
    Event newFeed = Event(title, eventStartDate, eventEndDate, details, city, privateEvent,lat,lng, new List<String>(),url);
    FeedItemUI newFeedUI = FeedItemUI(newFeed);
    _feed.add(newFeedUI);
    _feedOrientation.add(newFeedUI);
  }

  static removeFeedByIndex(int index) {
    _feed.removeAt(index);
    _feedOrientation.removeAt(index);
  }

  static removeFeedByTitle(String title) {
    for (int index = 0; index < _feedOrientation.length; index++) {
      if (_feedOrientation[index].data.title == title) {
        _feedOrientation.removeAt(index);
        _feed.removeAt(index);
      }
    }
  }

  static List<Widget> test(){
    return _feed;
  }

  /*
  void _sort() {}
  */

  /*
   void update() {}
   */


}