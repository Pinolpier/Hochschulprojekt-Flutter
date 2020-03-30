import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/feedItemImpl.dart';
import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/feedItemUI.dart';
import 'package:flutter/cupertino.dart';

class Feed {
  static List<Widget> _feed = List<Widget>();
  static List<FeedItemUI> _feedOrientation = List<FeedItemUI>();

  static List<Widget> get feed => _feed;

  static addItem(String title, DateTime eventStartDate, DateTime eventEndDate, String details, String city, bool privateEvent) {
    FeedItemImpl newFeed = FeedItemImpl(title, eventStartDate, eventEndDate, details, city, privateEvent);
    FeedItemUI newFeedUI = FeedItemUI(newFeed);
    _feed.add(newFeedUI);
    _feedOrientation.add(newFeedUI);
  }

  static removeItemByIndex(int index) {
    _feed.removeAt(index);
    _feedOrientation.removeAt(index);
  }

  static removeItemByTitle(String title) {
    for (int index = 0; index < _feedOrientation.length; index++) {
      if (_feedOrientation[index].data.title == title) {
        _feedOrientation.removeAt(index);
        _feed.removeAt(index);
      }
    }
  }

  static List<Widget> test() {
    addItem('title', DateTime.now(), DateTime.now(), 'blabla', 'blabla', true);
    addItem('title', DateTime.now(), DateTime.now(), 'blabla', 'blabla', true);
    addItem('title', DateTime.now(), DateTime.now(), 'blabla', 'blabla', true);
    print(_feed.length);
    return _feed;
  }
}