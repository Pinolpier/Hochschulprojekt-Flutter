import 'package:aiblabswp2020ssunivents/View/homeFeed_screen/feedItemImpl.dart';
import 'package:aiblabswp2020ssunivents/View/homeFeed_screen/feedItemUI.dart';
import 'package:flutter/cupertino.dart';

//@author
//for managing feed
class Feed {
  //widget list
  static List<Widget> _feed = List<Widget>();
  //data list
  static List<FeedItemUI> _feedOrientation = List<FeedItemUI>();

  static List<Widget> get feed => _feed;

  static addNewFeed(String title, DateTime eventStartDate, DateTime eventEndDate, String details, String city, bool privateEvent) {
    FeedItemImpl newFeed = FeedItemImpl(title, eventStartDate, eventEndDate, details, city, privateEvent);
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
    addNewFeed('title', DateTime.now(), DateTime.now(), 'details', 'city', false);
    addNewFeed('title', DateTime.now(), DateTime.now(), 'details', 'city', false);
    return _feed;
  }

  /*
  void _sort() {}
  */

  /*
   void update() {}
   */


}