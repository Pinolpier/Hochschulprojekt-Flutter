import 'package:flutter/cupertino.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';
import 'package:univents/view/homeFeed_screen/feedItemUI.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment

class Feed {
  ///widget list
  static List<Widget> _feed;

  /// todo: DO use prose to explain parameters, return values, and exceptions
  ///inits the feed with data from firebase
  static Future<List<Widget>> init() async {
    _feed = List<Widget>(); //create new instance

    try {
      List<Event> data = await getAllEvents(); //get data from firebase
      if (_feed.length != data.length) {
        _addEventToFeed(data);
      }
    } on Exception catch (e) {
      show_toast(exceptionHandling(e));
      Log().error(
          causingClass: 'feed', method: 'init', action: exceptionHandling(e));
    }
    return _feed;
  }

  /// todo: DO use prose to explain parameters, return values, and exceptions
  ///adds the data to the FeedItemUI for showing it
  static void _addEventToFeed(List<Event> eList) {
    for (Event e in eList) {
      _feed.add(FeedItemUI(e));
    }
  }
}
