import 'package:flutter/cupertino.dart';
import 'package:univents/Model/event.dart';
import 'package:univents/View/homeFeed_screen/feedItemUI.dart';
import 'package:univents/service/event_service.dart';

class Feed {
  //widget list
  static List<Widget> _feed = List<Widget>();

  static Future<List<Widget>> init() async {
    List<Event> data = await getEvents();
    if (_feed.length != data.length) {
      for (Event e in data) {
        _feed.add(FeedItemUI(e));
      }
    }
    return _feed;
  }
}
