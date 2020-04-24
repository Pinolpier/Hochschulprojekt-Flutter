import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Controller/authService.dart';
import 'package:univents/Model/constants.dart';

//TODO handle exceptions thrown by authService properly by giving feedback to the user!

/**
 * this class creates a loginscreen with different textfields to put in email and username and a few
 * buttons that add functionality like logging in through social media or remember me / forgot password
 */
class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool _rememberMe = false;
  AnimationController _logoAnimationController;
  Animation<double> _logoAnimation;
  String _email = '';
  String _password = '';

  /**
   * this method is responsible for the short logo animation at the start of the app
   */
  @override
  void initState() {
    super.initState();
    _logoAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1500));
    _logoAnimation = new CurvedAnimation(
        parent: _logoAnimationController, curve: Curves.easeInOutBack);
    _logoAnimation.addListener(() => this.setState(() {}));
    _logoAnimationController.forward();
  }

  Widget _animatedLogoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image(
          image: new AssetImage("assets/eventlogo.png"),
          //should be changed to the actual univents logo in assets later
          width: _logoAnimation.value * 100,
          height: _logoAnimation.value * 100,
        )
      ],
    );
  }

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
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: textStyleConstant,
            ),
            onChanged: (text) {
              _email = text;
            },
          ),
        ),
      ],
    );
  }

  bool isEmailGood(String email) {
    RegExp regExpMail = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regExpMail.hasMatch(_email);
  }

  Widget _passwordTextfieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
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
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
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

  bool isPasswordGood(String password) {
    RegExp regExpPassword = new RegExp(
        r"([A-Z]+)([a-z]+)([0-9]+)|([A-Z]+)([0-9]+)([a-z]+)|([a-z]+)([A-Z]+)([0-9]+)|([0-9]+)([A-Z]+)([a-z]+)|([a-z]+)([0-9]+)([A-Z]+)|([0-9]+)([a-z]+)([A-Z]+)");
    return regExpPassword.hasMatch(_password) && _password.length >= 8;
  }

  Widget _forgotPasswordWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          onPressed: () => handleForgotPassword(),
          padding: EdgeInsets.only(right: 0.0),
          child: Text(
            "Forgot Password?",
            style: labelStyleConstant,
          )),
    );
  }

  handleForgotPassword() {
    if (isEmailGood(_email)) {
      sendPasswordResetEMail(email: _email);
      //TODO show appropriate confirmation.
    } else {
      print("E-Mail malformed.");
      //TODO handle bad email address.
    }
  }

  Widget _loginButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => handleLogin(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  handleLogin() {
    if (isEmailGood(_email)) {
      signInWithEmailAndPassword(_email, _password);
    } else {
      //TODO Appropriate Error handling on the loginScreen for bad emails and passwords
    }
  }

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
        color: Colors.white,
        child: Text(
          'REGISTER', //TODO internationalize
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  handleRegistration() {
    if (isEmailGood(_email) && isPasswordGood(_password)) {
      registerWithEmailAndPassword(_email, _password);
    } else {
      //TODO Appropriate Error handling on the loginScreen for bad emails and passwords
    }
  }

  Widget _appleSignInWidget() {
    //TODO check for copyright and brandmark usage wheter it is allowed, also regarding Google Sign In Button!
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: AppleSignInButton(
          style: ButtonStyle.black,
          cornerRadius: 30.0,
          onPressed: () async {
            await appleSignIn();
          },
        ));
  }

  Widget _googleSignInWidget() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
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
                      color: Colors.grey,
                    ),
                  ),
                ),
              ]),
          onPressed: () async {
            await googleSignIn();
          },
        ));
  }

//  Widget _signUpWidget() {
//    return GestureDetector(
//      onTap: () => print('Sign Up Button Pressed'),
//      child: RichText(
//        text: TextSpan(
//          children: [
//            TextSpan(
//              text: 'Don\'t have an Account? ',
//              style: TextStyle(
//                color: Colors.white,
//                fontSize: 18.0,
//                fontWeight: FontWeight.w400,
//              ),
//            ),
//            TextSpan(
//              text: 'Sign Up',
//              style: TextStyle(
//                color: Colors.white,
//                fontSize: 18.0,
//                fontWeight: FontWeight.bold,
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

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
          backgroundColor: Colors.blueAccent,
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