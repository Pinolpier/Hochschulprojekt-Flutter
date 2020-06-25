import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/utils.dart';
import 'package:univents/view/eventInfo_screen.dart';

//'https://i.imgflip.com/syi19.jpg', //TODO: set variable from avatar
class FeedItemUI extends StatefulWidget {
  final Event _data;

  FeedItemUI(this._data);

  @override
  State<StatefulWidget> createState() => FeedItemUIState(this._data);
}

class FeedItemUIState extends State<FeedItemUI> {
  final Event _data;

  Widget _pPicture;

  FeedItemUIState(this._data);

  @override
  void initState() {
    super.initState();
    getProfilePicture(this._data.ownerIds[0]).then((value) {
      if (mounted) {
        setState(() {
          this._pPicture = value;
        });
      } else {
        Log().error(
            causingClass: 'feedItemUI',
            method: '_profilePicture',
            action: 'Memoryleak while loading profile pictures');
      }
    });
    this._pPicture =
        _pPicture != null ? _pPicture : Image.asset('assets/blank_profile.png');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: (MediaQuery.of(context).size.height * 1 / 2),
        color: univentsWhiteBackground,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: this._pPicture,
              ),
              title: Text(
                this._data.title,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 1 / 50),
              ),
              subtitle: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 200,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today,
                        size: MediaQuery.of(context).size.height * 1 / 50,
                      ),
                      Text(
                        _breakString(
                            '  ' +
                                feed_format_date_time(
                                    context, this._data.eventStartDate) +
                                '  -  ' +
                                feed_format_date_time(
                                    context, this._data.eventEndDate),
                            '-'),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 1 / 60),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 100,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        size: MediaQuery.of(context).size.height * 1 / 50,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1 / 150,
                      ),
                      SingleChildScrollView(
                        child: Text(
                          _breakString(' ' + _getLocation(context), ','),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 1 / 60),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        _breakString(_getTags(), ','),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 1 / 60),
                      ),
                    ],
                  )
                ],
              ),
              onTap: () async {
                _navigateToEventScreen();
              },
            ),
            Expanded(
              child: InkWell(
                onTap: _navigateToEventScreen,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _data.imageURL != null
                          ? NetworkImage(_data.imageURL)
                          : Image.asset('assets/eventImagePlaceholder.png')
                              .image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height / 50),
            ),
            // FeedActionBar(),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  String _breakString(String text, String sep) {
    String newText = "";
    if (text.length > 30) {
      int sum = 0;
      var sList = text.split(sep);
      for (String t in sList) {
        sum += t.length;
        if (sum < 30) {
          newText = newText + t + ', ';
        } else {
          newText = newText + '\n$t, ';
          sum = t.length;
        }
      }
    } else {
      newText = text;
    }
    return newText;
  }

  String _getLocation(BuildContext context) {
    return this._data.location;
  }

  /// _getTags displays tags of event in home feed as [Text]
  String _getTags() {
    String tags = "";
    if (this._data.tagsList != null && this._data.tagsList.length != 0) {
      tags = this
          ._data
          .tagsList
          .toString()
          .substring(1, this._data.tagsList.toString().length - 1);
    }
    return tags;
  }

  void _navigateToEventScreen() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new EventInfo(_data)));
  }
}
