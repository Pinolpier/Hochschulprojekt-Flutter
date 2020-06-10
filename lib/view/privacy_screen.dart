import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/constants.dart';
import 'package:univents/service/app_localizations.dart';

///This class creates an AboutScreen which displays the Privacytext and the Impressumtext (found in assets/res/strings.json)
///there is a Button to directly send feedback via E-Mail (mailto:-link)
///also a butto to share a message with the native share menu (text can be changed in assets/res/strings.json)

class AboutScreen extends StatefulWidget {
  @override
  State createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
                ],
              ),
            )));
  }
}
