import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/service/screen_manager.dart';
import 'package:univents/view/login_screen.dart';

/// @author Jan Oster
/// Displays a loading screen for 1.2 seconds and then displays the [ScreenManager]
/// It is used to avoid various animation errors at the [LoginScreen]

class LoadingScreen extends StatefulWidget {
  @override
  State createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var _result;

  Future<bool> loadAsyncData() async {
    await new Future.delayed(const Duration(milliseconds: 1200));
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
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    if (_result == null) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: primaryColor,
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 75.0,
              ),
              Center(
                child: Container(
                  width: 300,
                  child: Image.asset(
                    'assets/univentslogo.png',
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      univentsWhiteBackground),
                ),
              )
            ],
          ));
    } else {
      return ScreenManager();
    }
  }
}
