import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:univents/controller/screenManager.dart';
import 'package:univents/model/colors.dart';

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
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
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
