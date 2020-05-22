import 'package:flutter/material.dart';
import 'package:univents/controller/userProfileService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/utils/utils.dart';

//'https://i.imgflip.com/syi19.jpg', //TODO: set variable from avatar
class FeedItemUI extends StatefulWidget {
  final Event _data;

  FeedItemUI(this._data);

  @override
  State<StatefulWidget> createState() => FeedItemUIState(this._data);
}

class FeedItemUIState extends State<FeedItemUI> {
  final Event _data;

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
                child: profilePicture(),
              ),
              title: Text(this._data.title),
              subtitle: Text(
                _getInformation(context),
              ),
              onTap: () {
                print(_data.eventID);
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _data.imageURL != null
                        ? NetworkImage(_data.imageURL)
                        : Image.asset('assets/eventImagePlaceholder.png').image,
                    fit: BoxFit.cover,
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

  String _getInformation(BuildContext context) {
    return _data.location == null
        ? format_date_time(context, this._data.eventStartDate) +
            "\n - \n" +
            format_date_time(context, this._data.eventEndDate) +
            "\n"
        : format_date_time(context, this._data.eventStartDate) +
            "\n - \n" +
            format_date_time(context, this._data.eventEndDate) +
            "\n" +
            this._data.location;
  }

  Widget profilePicture() {
    Widget _profilePicture;
    getProfilePicture(this._data.ownerIds[0]).then((value) => setState(() {
          _profilePicture = value;
        }));
    return _profilePicture != null
        ? _profilePicture
        : Image.asset('assets/blank_profile.png');
  }
}
