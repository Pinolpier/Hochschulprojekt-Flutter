import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:univents/backend/auth_service.dart';
import 'package:univents/backend/user_profile_service.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/model/user_profile.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/view/privacy_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// @author Christian Henrich, Jan Oster
/// This screen represents the UI for the settings screen view where the user can choose between different app settings

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _emailVisibility;
  bool _nameVisibility;
  bool _tagsVisibility;
  UserProfile _profile;
  var _result;

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
        onPressed: () async {
          await showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('delete account' //TODO Fix Bug002
                    //AppLocalizations.of(context).translate('delete_profile')
                    ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('you\'re about to delete your profile, are you sure?'
                          //AppLocalizations.of(context).translate('delete_profile_text')
                          ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () async {
                      await deleteProfileOfCurrentlySignedInUser(context);
                      print('next step is sign out');
                      signOut();
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
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
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new PrivacyScreen(),
              ));
        },
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

  Future<bool> loadAsyncData() async {
    _profile = await getUserProfile(getUidOfCurrentlySignedInUser());
    _profile.emailVisibility == PRIVATE
        ? _emailVisibility = false
        : _emailVisibility = true;
    _profile.nameVisibility == PRIVATE
        ? _nameVisibility = false
        : _nameVisibility = true;
    _profile.tagsVisibility == PRIVATE
        ? _tagsVisibility = false
        : _tagsVisibility = true;
    return true;
  }

  @override
  void initState() {
    loadAsyncData().then((result) {
      setState(() {
        _result = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return CircularProgressIndicator();
    } else {
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
                        _emailVisibility == true
                            ? _profile.emailVisibility = FRIENDS
                            : _profile.emailVisibility = PRIVATE;
                        updateProfile(_profile);
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
                        _nameVisibility == true
                            ? _profile.nameVisibility = FRIENDS
                            : _profile.nameVisibility = PRIVATE;
                        updateProfile(_profile);
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
                        _tagsVisibility == true
                            ? _profile.tagsVisibility = FRIENDS
                            : _profile.tagsVisibility = PRIVATE;
                        updateProfile(_profile);
                      });
                    },
                    secondary: Icon(Icons.mail_outline),
                  ),
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
                  _deleteProfileButtonWidget(),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
