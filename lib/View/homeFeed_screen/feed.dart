import 'package:flutter/cupertino.dart';
import 'package:univents/Model/event.dart';
import 'package:univents/View/homeFeed_screen/feedItemUI.dart';
import 'package:univents/service/event_service.dart';

class Feed {
  ///widget list
  static List<Widget> _feed;

  ///inits the feed with data from firebase
  static Future<List<Widget>> init() async {
    _feed = List<Widget>(); //create new instance
    List<Event> data = await getEvents(); //get data from firebase
    if (_feed.length != data.length) {
      _addEventToFeed(data);
    }
    return _feed;
  }

  ///adds the data to the FeedItemUI for showing it
  static void _addEventToFeed(List<Event> eList) {
    for (Event e in eList) {
      _feed.add(FeedItemUI(e));
    }
  }
}
