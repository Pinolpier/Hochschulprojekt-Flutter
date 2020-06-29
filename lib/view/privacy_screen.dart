import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/constants/constants.dart';
import 'package:univents/service/app_localizations.dart';

///This class creates an AboutScreen which displays the privacy statement and the imprint (found in assets/res/strings.json)
///@author: Jan Oster

class PrivacyScreen extends StatefulWidget {
  @override
  State createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  Widget _backButtonWidget() {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('privacy_settings'),
          style: textStyleConstant,
        ),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: univentsBlackText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: primaryColor,
        elevation: 0.0,
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
                vertical: 20.0,
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _backButtonWidget(),
                  SizedBox(height: 20.0),
                  Text(
                    AppLocalizations.of(context).translate('privacy_statement'),
                    style: labelStyleConstant,
                  ),
                  Text(
                    AppLocalizations.of(context).translate('privacy_text'),
                    style: textStyleConstant,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    AppLocalizations.of(context).translate('imprint'),
                    style: labelStyleConstant,
                  ),
                  Text(
                    AppLocalizations.of(context).translate("imprint_text"),
                    style: textStyleConstant,
                  ),
                ],
              ),
            )));
  }
}
