import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/utils/utils.dart';

class FeedItemUI extends StatelessWidget {
  final Event _data;

  FeedItemUI(this._data);

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
                backgroundImage: NetworkImage(
                  'https://i.imgflip.com/syi19.jpg', //TODO: set variable from avatar
                ),
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
                        : NetworkImage(
                            'https://images.eventpeppers.com/sites/default/files/imagecache/lightbox-xs/content/18-05/disco-feiern-abends.jpg',
                          ),
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
}
