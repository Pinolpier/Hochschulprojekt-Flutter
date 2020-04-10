import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

//TODO implement fix for aborted GoogleSignIn
Future<String> googleSignIn() async {
  //the following code is from this tutorial with slight changes made: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
  final GoogleSignInAccount _googleAccountToSignIn =
      await _googleSignIn.signIn();
  final GoogleSignInAuthentication _googleSignInAuthentication =
      await _googleAccountToSignIn.authentication;
  final AuthCredential _credentials = GoogleAuthProvider.getCredential(
      idToken: _googleSignInAuthentication.idToken,
      accessToken: _googleSignInAuthentication.accessToken);
  final AuthResult _authResult = await _auth.signInWithCredential(_credentials);
  final FirebaseUser _user = _authResult.user;

  //the following code is only evaluated in debugging
  assert(!_user.isAnonymous, "After Google Sign In the user is anonymous!");
  assert(await _user.getIdToken() != null);
  final FirebaseUser _currentUser = await _auth.currentUser();
  assert(_user.uid == _currentUser.uid);

  return 'Sign In With Google was succesful: $_user';
}

void signOutGoogle() async {
  await _googleSignIn.signOut();

  print("Google user signed out");
}
