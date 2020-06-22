import 'package:flutter/material.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/option_model.dart';

/// todo: add author
/// todo: add documentation

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Scaffold(
        backgroundColor: univentsLightGreyBackground,
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
                color: univentsWhiteBackground,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                leading: options[index - 1].icon,
                title: Text(
                  options[index - 1].title,
                  style: TextStyle(color: univentsBlackText),
                ),
                subtitle: Text(
                  options[index - 1].subtitle,
                  style: TextStyle(color: univentsBlackText2),
                ),
                onTap: () {
                  print('pressed');
                },
              ),
            );
          },
        ),
        bottomSheet: Container(
            color: univentsWhiteBackground,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 140.0),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () => signOut(),
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: univentsWhiteBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'LOGOUT',
                    style: TextStyle(color: univentsBlackText),
                  ),
                  Icon(Icons.exit_to_app)
                ],
              ),
            )),
      ),
    );
  }
}
