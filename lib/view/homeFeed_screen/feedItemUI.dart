import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/utils/utils.dart';
import 'package:univents/view/eventInfo_screen.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment

class FeedItemUI extends StatefulWidget {
  /// todo: add documentation of variable
  final Event _data;

  /// todo: missing documentation of constructor
  FeedItemUI(this._data);

  /// todo: missing documentation
  @override
  State<StatefulWidget> createState() => FeedItemUIState(this._data);
}

/// todo: missing documentation
class FeedItemUIState extends State<FeedItemUI> {
  /// todo: add documentation of variables
  final Event _data;

  /// todo: missing documentation of constructor
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
                        ' ' + _getLocation(context),
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

  /// todo: missing documentation
  String _getLocation(BuildContext context) {
    return this._data.location;
  }

  /// todo: DO separate the first sentence of a doc comment into its own paragraph.
  /// todo: DO use prose to explain parameters, return values, and exceptions
  /// loads profile picture
  /// if no profile picture in the backend, show placeholder
  Widget _profilePicture() {
    Widget _profilePicture;
    getProfilePicture(this._data.ownerIds[0]).then((value) => setState(() {
          _profilePicture = value;
        }));
    return _profilePicture != null
        ? _profilePicture
        : Image.asset('assets/blank_profile.png');
  }

  /// todo: missing documentation
  void _navigateToEventScreen() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new EventInfo(_data)));
  }
}
