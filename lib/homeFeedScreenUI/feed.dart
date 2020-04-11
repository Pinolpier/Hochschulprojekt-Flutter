
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

  static addNewFeed(String title, DateTime eventStartDate, DateTime eventEndDate, String details, String city, bool privateEvent,String lat,String lng) {
    Event newFeed = Event(title, eventStartDate, eventEndDate, details, city, privateEvent,lat,lng);
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
    addNewFeed('title', DateTime.now(), DateTime.now(), 'details', 'city', false,null,null);
    addNewFeed('title', DateTime.now(), DateTime.now(), 'details', 'city', false,null,null);
    return _feed;
  }

  /*
  void _sort() {}
  */

  /*
   void update() {}
   */


}