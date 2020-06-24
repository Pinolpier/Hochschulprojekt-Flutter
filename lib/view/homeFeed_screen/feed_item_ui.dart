import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/utils/utils.dart';
import 'package:univents/view/eventInfo_screen.dart';

/// @author mathias darscht
/// this class defines the design of an event in the home feed
class FeedItemUI extends StatefulWidget {
  /// date from the feed.dart class that should have been displayed
  final Event _data;

  /// constructor initializes [_data]
  FeedItemUI(this._data);

  @override
  State<StatefulWidget> createState() => FeedItemUIState(this._data);
}

class FeedItemUIState extends State<FeedItemUI> {
  /// data provided from FeedItemUI
  final Event _data;

  /// constructor initializes [_data]
  FeedItemUIState(this._data);

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
                child: _profilePicture(),
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
                        '  ' +
                            feedFormatDateTime(
                                context, this._data.eventStartDate) +
                            '  -  ' +
                            feedFormatDateTime(
                                context, this._data.eventEndDate),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 1 / 60),
                      ),
                    ],
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
                      Text(
                        ' ' + _getLocation(),
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 1 / 60),
                      )
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

  /// this method get's the location from [_data]
  String _getLocation() {
    return this._data.location;
  }

  /// loads profile picture
  ///
  /// in case of no [_profilePicture] a placholder will be displayed
  Widget _profilePicture() {
    Widget _profilePicture;
    getProfilePicture(this._data.ownerIds[0]).then((value) => setState(() {
          _profilePicture = value;
        }));
    return _profilePicture != null
        ? _profilePicture
        : Image.asset('assets/blank_profile.png');
  }

  /// navigates to the selected event
  void _navigateToEventScreen() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new EventInfo(_data)));
  }
}
