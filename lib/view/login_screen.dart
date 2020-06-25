import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/model/authExceptions.dart';
import 'package:univents/model/colors.dart';
import 'package:univents/model/constants.dart';
import 'package:univents/service/app_localizations.dart';
import 'package:univents/service/log.dart';
import 'package:univents/service/utils/toast.dart';

//TODO handle exceptions thrown by authService properly by giving feedback to the user!

/// @author Christian Henrich, Markus Link
///
/// this class represents the UI for the loginscreen where the user can login via email address and password, google/apple sign in or create a new profile
/// if he doesn't have an existing one
class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  /// for the animation of the univents logo at the start of opening the screen
  AnimationController _logoAnimationController;
  Animation<double> _logoAnimation;
  String _email = '';
  String _password = '';

  /// this method is responsible for the short logo animation at the start of the app
  @override
  void initState() {
    super.initState();
    _logoAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 5000));
    _logoAnimation = new CurvedAnimation(
        parent: _logoAnimationController, curve: Curves.easeInOutBack);
    _logoAnimation.addListener(() => this.setState(() {}));
    _logoAnimationController.forward();
  }

  /// widget for the animated logo at the beginning, currently used image is a univents logo from the assets
  Widget _animatedLogoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image(
          image: new AssetImage("assets/univentslogo.png"),
          width: _logoAnimation.value * 100,
          height: _logoAnimation.value * 100,
        )
      ],
    );
  }

  /// Widget for the textfield where the user can put in his email address
  Widget _emailTextfieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxStyleConstant,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: univentsWhiteText,
              ),
              hintText: AppLocalizations.of(context).translate('enter_email'),
              hintStyle: textStyleConstant,
            ),
            onChanged: (text) {
              text = text.trim();
              _email = text;
            },
          ),
        ),
      ],
    );
  }

  /// This method checks whether the given parameter [email] of type [String] is a valid e-mail-address using regex.
  /// The regex is copied from StackOverflow. Returns true only if a valid email address has been passed as argument.
  bool _isEmailGood(String email) {
    RegExp regExpMail = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regExpMail.hasMatch(_email);
  }

  /// Widget for the textfield where the user can put in his password
  Widget _passwordTextfieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppLocalizations.of(context).translate('password'),
          style: labelStyleConstant,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxStyleConstant,
          height: 60.0,
          child: TextField(
            obscureText: true,
            style: TextStyle(
              color: univentsWhiteText,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: univentsWhiteText,
              ),
              hintText:
                  AppLocalizations.of(context).translate('enter_password'),
              hintStyle: textStyleConstant,
            ),
            onChanged: (text) {
              _password = text;
            },
          ),
        ),
      ],
    );
  }

  /// This method checks whether a given parameter [password] of type [String] is a secure password. Secure is defined as:
  /// Contains lower- and uppercase letters and a digit from 0-9 in any random order and has a minimum length of 8
  /// Returns true only if the password is safe.
  bool _isPasswordGood(String password) {
    RegExp regExpPassword = new RegExp(
        r"([A-Z]+)([a-z]+)([0-9]+)|([A-Z]+)([0-9]+)([a-z]+)|([a-z]+)([A-Z]+)([0-9]+)|([0-9]+)([A-Z]+)([a-z]+)|([a-z]+)([0-9]+)([A-Z]+)|([0-9]+)([a-z]+)([A-Z]+)");
    return regExpPassword.hasMatch(_password) && _password.length >= 8;
  }

  /// widget for the button that gives the user the ability to retrieve help in case he forgot his own password
  Widget _forgotPasswordWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () => _handleForgotPassword(),
          padding: EdgeInsets.only(right: 0.0),
          child: Text(
            AppLocalizations.of(context).translate('forgot_password'),
            style: labelStyleConstant,
          )),
    );
  }

  /// This method uses the [authService.dart] to send a password Reset E-Mail if the email address is valid.
  _handleForgotPassword() {
    if (_isEmailGood(_email)) {
      sendPasswordResetEMail(email: _email);
      show_toast(AppLocalizations.of(context)
              .translate('loginscreen_forgot_password_send') +
          _email);
    } else {
      show_toast(AppLocalizations.of(context).translate(
          'loginscreen_bad_email')); //TODO maybe change to little red warning text under email field ?
    }
  }

  /// widget for the button that gives the user the ability to start the login process after putting in a valid email address and password in the respective textfields
  Widget _loginButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => _handleLogin(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteBackground,
        child: Text(
          'LOGIN',
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

  /// Sign a user in if the [_email] is valid.
  _handleLogin() {
    if (_isEmailGood(_email)) {
      try {
        signInWithEmailAndPassword(_email, _password);
      } on AuthException catch (e) {
        show_toast(e.toString());
        Log().error(
            causingClass: 'login_screen',
            method: '_handleLogin',
            action: e.toString());
      }
    } else {
      show_toast(AppLocalizations.of(context).translate(
          'loginscreen_bad_email')); //TODO little red warning under email field ?!
    }
  }

  /// widget for the button that gives the user the ability to start the registration process after putting in a valid email address
  /// that is not bound to any existing account yet
  Widget _registerButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => handleRegistration(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: univentsWhiteBackground,
        child: Text(
          'REGISTER', //TODO internationalize
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

  /// Registers a new user&password combination if [_isPasswordGood] and if [_isEmailGood].
  handleRegistration() {
    if (_isEmailGood(_email) && _isPasswordGood(_password)) {
      try {
        registerWithEmailAndPassword(_email, _password);
      } on AuthException catch (e) {
        show_toast(e.toString());
        Log().error(
            causingClass: 'login_screen',
            method: 'handleRegistration',
            action: e.toString());
      }
    } else {
      //TODO maybe better with red text under the fields ?
      if (!_isEmailGood(_email)) {
        show_toast(
            AppLocalizations.of(context).translate('loginscreen_bad_email'));
      } else if (!_isPasswordGood(_password)) {
        show_toast(AppLocalizations.of(context)
            .translate('loginscreen_bad_password')); //TODO red text or Dialog ?
      } else {
        show_toast(AppLocalizations.of(context)
            .translate('unknown_Exception')); //Should never be reached
      }
    }
  }

  /// widget for the button that gives the user the ability to log in via Apple ID
  Widget _appleSignInWidget() {
    //TODO check for copyright and brandmark usage wheter it is allowed, also regarding Google Sign In Button!
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: AppleSignInButton(
          style: ButtonStyle.black,
          cornerRadius: 30.0,
          onPressed: () async {
            try {
              await appleSignIn();
            } on Exception catch (e) {
              show_toast(e.toString());
              Log().error(
                  causingClass: 'Loginscreen',
                  method: 'applesigninWIdget',
                  action: e.toString());
            }
          },
        ));
  }

  /// widget for the button that gives the user the ability to log in with his google account
  Widget _googleSignInWidget() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: univentsWhiteBackground,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/google_logo.png"), height: 18.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 18,
                      color: textButtonDarkBlue,
                    ),
                  ),
                ),
              ]),
          onPressed: () async {
            try {
              await googleSignIn();
            } on Exception catch (e) {
              show_toast(e.toString());
              Log().error(
                  causingClass: 'Loginscreen',
                  method: 'googleSigninWIdget',
                  action: e.toString());
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    var widgetList = <Widget>[
      _animatedLogoWidget(),
      SizedBox(height: 30.0),
      _emailTextfieldWidget(),
      SizedBox(height: 20.0),
      _passwordTextfieldWidget(),
      _forgotPasswordWidget(),
      _loginButtonWidget(),
      _registerButtonWidget(),
    ];
    bool alreadyAdded = false;
    bool alreadyAddedApple = false;
    child:
    return FutureBuilder<bool>(
      future: checkAppleSignInAvailability(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            if (!alreadyAddedApple) {
              widgetList.add(
                _appleSignInWidget(),
              );
              alreadyAddedApple = true;
            }
          }
          if (!alreadyAdded) {
            widgetList.add(_googleSignInWidget());
            widgetList.add(SizedBox(height: 20.0));
//            widgetList.add(_signUpWidget());
            alreadyAdded = true;
          }
        } else if (snapshot.hasError) {
          //TODO add error handling whatever should be done in this case.
        } else {
          //TODO maybe improve this with loading animation.
          return Container(
            width: 0.0,
            height: 0.0,
          );
        }

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
                  children: widgetList),
            ),
          ),
        );
      },
    );
  }
}
