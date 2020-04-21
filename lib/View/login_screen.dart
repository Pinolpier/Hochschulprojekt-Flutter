import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:univents/Model/constants.dart';

/**
 * this class creates a loginscreen with different textfields to put in email and username and a few
 * buttons that add functionality like logging in through social media or remember me / forgot password
 */
class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {

  bool _rememberMe = false;
  AnimationController _logoAnimationController;
  Animation<double> _logoAnimation;

  /**
   * this method is responsible for the short logo animation at the start of the app
   */
  @override
  void initState(){
    super.initState();
    _logoAnimationController = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 1500)
    );
    _logoAnimation = new CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOutBack
    );
    _logoAnimation.addListener(()=> this.setState((){}));
    _logoAnimationController.forward();
  }

  Widget _animatedLogoWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image(
          image: new AssetImage("assets/eventlogo.png"),  //should be changed to the actual univents logo in assets later
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
          ),
        ),
      ],
    );
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
          ),
        ),
      ],
    );
  }

  Widget _forgotPasswordWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print("Forgot password Button Pressed"),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          "Forgot Password?",
          style: labelStyleConstant,
        )
      ),
    );
  }

  Widget _loginButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => print('Login Button Pressed'),

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

  Widget _socialMediaButtonsWidget() {
    return GestureDetector(
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       children: <Widget>[
         new Container(
             width:  50,
             height: 50,
             decoration: BoxDecoration(
               color: Colors.black,
               shape: BoxShape.circle,
               image: DecorationImage(
                   image:AssetImage("assets/google.jpg"),
                   fit:BoxFit.cover
               ),
             )
         ),
         new Container(
             width:  50,
             height: 50,
             decoration: BoxDecoration(
               color: Colors.black,
               shape: BoxShape.circle,
               image: DecorationImage(
                   image:AssetImage("assets/facebook.jpg"),
                   fit:BoxFit.cover
               ),
             )
         ),
         new Container(
             width:  50,
             height: 50,
             decoration: BoxDecoration(
               color: Colors.black,
               shape: BoxShape.circle,
               image: DecorationImage(
                   image:AssetImage("assets/twitter.webp"),
                   fit:BoxFit.cover
               ),
             )
         ),
       ],
     ),
    );
  }

  Widget _signUpWidget() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: new Container(
        height: double.infinity,
        child: SingleChildScrollView(     //fixes pixel overflow error when keyboard is used
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120.0,
          ),
          child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _animatedLogoWidget(),
                  SizedBox(height: 30.0),
                  _emailTextfieldWidget(),
                  SizedBox(height: 20.0),
                  _passwordTextfieldWidget(),
                  _forgotPasswordWidget(),
                  _loginButtonWidget(),
                  _socialMediaButtonsWidget(),
                  SizedBox(height: 20.0),
                  _signUpWidget()
                ],
          ),
        ),
      ),
    );
  }
}
