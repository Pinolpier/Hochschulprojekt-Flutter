import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/feedItemImpl.dart';
import 'package:aiblabswp2020ssunivents/homeFeedScreenUI/feedItemUI.dart';
import 'package:flutter/cupertino.dart';

class Feed {
  static List<Widget> _feed = List<Widget>();

  static List<Widget> get feed() => _feed;

  static addItem(String title, DateTime eventStartDate, DateTime eventEndDate, String details, String city, bool privateEvent) {
    FeedItemImpl newFeed = FeedItemImpl(title, eventStartDate, eventEndDate, details, city, privateEvent);
    FeedItemUI newFeedUI = FeedItemUI(newFeed);
    _feed.add(newFeedUI);
  }

  static removeItemByIndex(int index) {
    _feed.removeAt(index);
  }

  static removeItemByTitle(String title) {
    _feed.forEach()
  }
}