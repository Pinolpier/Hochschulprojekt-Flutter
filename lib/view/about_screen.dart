import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/constants.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// @author Jan Oster

///This class creates an AboutScreen which displays the Privacytext and the Impressumtext (found in assets/res/strings.json)
///there is a Button to directly send feedback via E-Mail (mailto:-link)
///also a button to share a message with the native share menu (text can be changed in assets/res/strings.json)
class AboutScreen extends StatefulWidget {
  /// todo: missing documentation
  @override
  State createState() => _AboutScreenState();
}

/// todo: missing documentation
class _AboutScreenState extends State<AboutScreen> {
  /// todo: missing documentation
  void share(BuildContext context, String text) {
    final RenderBox box = context.findRenderObject(); //fix for iPad

    Share.share(
      text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  /// todo: missing documentation
  Widget _feedbackButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _launchURL();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteBackground,
        child: Text(
          'feedback',
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

  /// todo: missing documentation
  _launchURL() async {
    const url =
        'mailto:feedback@univents.app?subject=Feedback&body=What could be better: ';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  /// todo: missing documentation
  Widget _shareButtonWidget(String text) {
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
        color: univentsWhiteBackground,
        child: Text(
          'share',
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
    return Scaffold(
        backgroundColor: primaryColor,
        body: new Container(
            height: double.infinity,
            child: SingleChildScrollView(
              //fixes pixel overflow error when keyboard is used
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Privacy',
                    style: labelStyleConstant,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("privacy"),
                    style: textStyleConstant,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'impressum',
                    style: labelStyleConstant,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("impressum"),
                    style: textStyleConstant,
                  ),
                  SizedBox(height: 20.0),
                  _feedbackButtonWidget(),
                  _shareButtonWidget(
                      AppLocalizations.of(context).translate("shareMessage")),
                ],
              ),
            )));
  }
}
