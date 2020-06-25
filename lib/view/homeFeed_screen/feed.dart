import 'package:flutter/cupertino.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/event_service.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';
import 'package:univents/view/homeFeed_screen/feedItemUI.dart';

class Feed {
  ///widget list
  static List<Widget> _feed;

  ///inits the feed with data from firebase
  static Future<List<Widget>> init() async {
    _feed = List<Widget>(); //create new instance
    try {
      List<Event> data = point != null
          ? await get_events_near_location_and_filters(point, radius)
          : await getAllEvents(); //get data from firebase
      if (_feed.length != data.length) {
        _addEventToFeed(data);
      }
    } on Exception catch (e) {
      show_toast(exceptionHandling(e));
      Log().error(
          causingClass: 'feed', method: 'init', action: exceptionHandling(e));
    }
    //rint(point == null);
    return _feed;
  }

  ///adds the data to the FeedItemUI for showing it
  static void _addEventToFeed(List<Event> eList) {
    for (Event e in eList) {
      _feed.add(FeedItemUI(e));
    }
  }
}
