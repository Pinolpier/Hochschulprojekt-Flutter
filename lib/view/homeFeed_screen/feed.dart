import 'package:flutter/cupertino.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';
import 'package:univents/view/homeFeed_screen/feed_item_ui.dart';

/// @author mathias darscht
/// this class controls the feed and get's the data from firebase
/// provides the information to feed_item_ui and let's them display it
class Feed {
  ///widget list with feed_item_ui objects
  static List<Widget> _feed;

  /// initializes the [_feed] list with data from firebase
  ///
  /// in case of any error or [exception] it will be catched and logged
  /// if there are no problems the filled list [_feed] with
  /// the data will be returned
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

  ///adds data from [eList] to [_feed]
  static void _addEventToFeed(List<Event> eList) {
    for (Event e in eList) {
      _feed.add(FeedItemUI(e));
    }
  }
}
