import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailVisibility = false;
  bool _nameVisibility = false;
  bool _tagsVisibility = false;

  void share(BuildContext context, String text) {
    final RenderBox box = context.findRenderObject(); //fix for iPad
    Share.share(
      text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  Widget _deleteProfileButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {},
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
        child: Text(
          AppLocalizations.of(context).translate("delete_profile"),
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _shareAppButtonWidget(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => Share.share(text),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
        child: Text(
          AppLocalizations.of(context).translate("share"),
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _feedbackButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          const url =
              'mailto:feedback@univents.app?subject=Feedback&body=What could be better: ';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            print('Could not launch $url');
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
        child: Text(
          AppLocalizations.of(context).translate("feedback"),
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _privacyButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {},
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
        child: Text(
          AppLocalizations.of(context).translate("privacy_settings"),
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _signOutButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => signOut(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteText,
        child: Text(
          AppLocalizations.of(context).translate("sign_out"),
          style: TextStyle(
            color: textButtonDarkBlue,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Scaffold(
        backgroundColor: univentsLightGreyBackground,
        body: new Container(
          height: double.infinity,
          child: SingleChildScrollView(
            //fixes pixel overflow error when keyboard is used
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 20.0,
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  AppLocalizations.of(context).translate('main_settings'),
                  style: TextStyle(
                    color: univentsBlackText,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                  ),
                ),
                new SwitchListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate("email_visibility")),
                  value: _emailVisibility,
                  onChanged: (bool value) {
                    setState(() {
                      _emailVisibility = value;
                    });
                  },
                  secondary: Icon(Icons.mail_outline),
                ),
                new SwitchListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate("name_visibility")),
                  value: _nameVisibility,
                  onChanged: (bool value) {
                    setState(() {
                      _nameVisibility = value;
                    });
                  },
                  secondary: Icon(Icons.mail_outline),
                ),
                new SwitchListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate("tags_visibility")),
                  value: _tagsVisibility,
                  onChanged: (bool value) {
                    setState(() {
                      _tagsVisibility = value;
                    });
                  },
                  secondary: Icon(Icons.mail_outline),
                ),
                _deleteProfileButtonWidget(),
                new Text(
                  AppLocalizations.of(context).translate('misc_settings'),
                  style: TextStyle(
                    color: univentsBlackText,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                  ),
                ),
                _shareAppButtonWidget(
                    AppLocalizations.of(context).translate("shareMessage")),
                _feedbackButtonWidget(),
                _privacyButtonWidget(),
                _signOutButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
