import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/option_model.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: univentsLightGrey,
      body: ListView.builder(
        itemCount: options.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(height: 5.0);
          } else if (index == options.length + 1) {
            return SizedBox(height: 100.0);
          }
          return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10.0),
            width: double.infinity,
            height: 70.0,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              leading: options[index - 1].icon,
              title: Text(
                options[index - 1].title,
                style: TextStyle(color: univentsBlack),
              ),
              subtitle: Text(
                options[index - 1].subtitle,
                style: TextStyle(color: Colors.black45),
              ),
              onTap: () {
                print('pressed');
              },
            ),
          );
        },
      ),
      bottomSheet: Container(
          color: univentsWhite,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 140.0),
          width: double.infinity,
          child: RaisedButton(
            elevation: 5.0,
            onPressed: () => print('Logout was pressed'),
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: univentsWhite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'LOGOUT',
                  style: TextStyle(color: univentsBlack),
                ),
                Icon(Icons.exit_to_app)
              ],
            ),
          )),
    );
  }
}
