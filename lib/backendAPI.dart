import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:univents/backendExceptions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
FirebaseUser _user;

Future<FirebaseUser> _refreshCurrentlyLoggedInUser() async {
  _user = await _auth.currentUser();
}

Future<bool> googleSignIn() async {
  //the following code is from this tutorial with slight changes made: https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/
  try {
    final GoogleSignInAccount _googleAccountToSignIn =
    await _googleSignIn.signIn();
    if (_googleAccountToSignIn != null) {
      final GoogleSignInAuthentication _googleSignInAuthentication =
      await _googleAccountToSignIn.authentication;
      final AuthCredential _credentials = GoogleAuthProvider.getCredential(
          idToken: _googleSignInAuthentication.idToken,
          accessToken: _googleSignInAuthentication.accessToken);
      try {
        final AuthResult _authResult =
        await _auth.signInWithCredential(_credentials);
        _user = _authResult.user;
      } on PlatformException catch (platformException) {
        switch (platformException.code) {
          case "ERROR_INVALID_CREDENTIAL":
          //If the credential data is malformed or has expired.
            break;
          case "ERROR_USER_DISABLED":
          //If the user has been disabled (for example, in the Firebase console)
            throw new UserDisabledException(platformException,
                "The userAccount that tried to sign in with Google was disabled. Credentilas were: " +
                    _credentials.toString());
            break;
          case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          //If there already exists an account with the email address asserted by Google. Resolve this case by calling [fetchSignInMethodsForEmail]and then asking
          // the user to sign in using one of them. This error will only be thrown if the "One account per email address" setting is enabled in the Firebase console (recommended).
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          //Indicates that Google accounts are not enabled.
            break;
          case "ERROR_INVALID_ACTION_CODE":
          //If the action code in the link is malformed, expired, or has already been used. This can only occur when using [EmailAuthProvider.getCredentialWithLink] to obtain the credential.
            break;
        }
      }
    } else {
      //TODO handle that the sign in with Google process was aborted
      print("GoogleSign in was aborted!");
      throw new SignInAbortedException(
          null, "The Google Sign In Prcess has been aborted!");
    }

    return await isUserSignedIn();
  } on Exception catch (error) {
    //TODO maybe add error type based error handling?
    //TODO log error
    print("Das hier ist der Error:");
    print(error);
  }
}

Future<bool> appleSignIn() async {
  final result = await AppleSignIn.performRequests(
      [AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);
  switch (result.status) {
    case AuthorizationStatus.authorized:
      final appleIdCredential = result.credential;
      final oAuthProvider = OAuthProvider(providerId: 'apple.com');
      final _credentials = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken: String.fromCharCodes(
              appleIdCredential.authorizationCode));
      try {
        final authResult = await _auth.signInWithCredential(_credentials);
        _user = authResult.user;
        final updateUser = UserUpdateInfo();
        updateUser.displayName =
        '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName
            .familyName}';
        await _user.updateProfile(updateUser);
        return true;
      } on PlatformException catch (platformException) {
        switch (platformException.code) {
          case "ERROR_INVALID_CREDENTIAL":
          //If the credential data is malformed or has expired.
            break;
          case "ERROR_USER_DISABLED":
          //If the user has been disabled (for example, in the Firebase console)
            throw new UserDisabledException(platformException,
                "The userAccount that tried to sign in with Apple was disabled. Credentilas were: " +
                    _credentials.toString());
            break;
          case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
          //If there already exists an account with the email address asserted by Google. Resolve this case by calling [fetchSignInMethodsForEmail]and then asking
          // the user to sign in using one of them. This error will only be thrown if the "One account per email address" setting is enabled in the Firebase console (recommended).
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
          //Indicates that Google accounts are not enabled.
            break;
          case "ERROR_INVALID_ACTION_CODE":
          //If the action code in the link is malformed, expired, or has already been used. This can only occur when using [EmailAuthProvider.getCredentialWithLink] to obtain the credential.
            break;
        }
      }
      break;
    case AuthorizationStatus.error:
    //TODO good exception handling here
      print(result.error.toString());
      //Throw an exception here
      break;
    case AuthorizationStatus.cancelled:
      throw SignInAbortedException(null,
          "The AppleSignIn was aborted by the user and thus no user is logged in!");
      break;
  }
}

Future<bool> signInWithEmailAndPassword(String email, String password) async {
  try {
    _user = (await _auth.signInWithEmailAndPassword(
        email: email, password: password))
        .user;
  } on PlatformException catch (platformException) {
    switch (platformException.code) {
      case "ERROR_INVALID_EMAIL": //If the [email] address is malformed.
        throw new NotAnEmailException(platformException,
            "The email ($email) is not an email. This should have been checked by the login screen BEFORE submitting a sign in request!");
        break;
      case "ERROR_WRONG_PASSWORD": //If the [password] is wrong.
        throw new WrongPasswordException(platformException,
            "The entered password does not match with the user account's password identified by the given email.");
        break;
      case "ERROR_USER_NOT_FOUND": //If there is no user corresponding to the given [email] address, or if the user has been deleted.
        throw new UserNotFoundException(platformException,
            "No user account matching the given email ($email) could be found. Try registrating the user first!");
        break;
      case "ERROR_USER_DISABLED": //If the user has been disabled (for example, in the Firebase console)
        throw new UserDisabledException(platformException,
            "The user account with the given email ($email) was disabled (e.g. in the Firebase console).");
        break;
      case "ERROR_TOO_MANY_REQUESTS": //If there was too many attempts to sign in as this user.
        break;
      case "ERROR_OPERATION_NOT_ALLOWED": //Indicates that Email & Password accounts are not enabled.
        break;
    }
  } on Exception catch (e) {
    print("An unknown Exception has occured! Exception is : $e");
  } catch (fatal) {
    print(
        "SomeWTFthing has happend! Object of type ${fatal
            .runtimeType} has been thrown. Trying to print it: $fatal");
  }
  return _user != null ? true : false;
}

Future<bool> registerWithEmailAndPassword(String email, String password) async {
  try {
    _user = (await _auth.createUserWithEmailAndPassword(
        email: email, password: password))
        .user;
  } on PlatformException catch (platformException) {
    print(platformException);
    switch (platformException.code) {
      case "ERROR_WEAK_PASSWORD":
      //at least 6 characters needed
        break;
      case "ERROR_INVALID_EMAIL":
        throw new NotAnEmailException(platformException,
            "The email ($email) is not an email. This should have been checked by the login screen BEFORE submitting a registration request!");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        print("MailAlreadyInUseError");
        //TODO correct Error Handling, maybe offer to reset password or if an gmail address try google sign in?
        break;
    }
  } on Exception catch (e) {
    print("An unknown Exception has occured! Exception is : $e");
  } catch (fatal) {
    print(
        "SomeWTFthing has happend! Object of type ${fatal
            .runtimeType} has been thrown. Trying to print it: $fatal");
  }
  return _user != null ? true : false;
}

Future<void> sendPasswordResetEMail({@required String email}) async {
  try {
    await _auth.sendPasswordResetEmail(email: email);
  } on PlatformException catch (platformException) {
    switch (platformException.code) {
    //TODO correct error handling
      case "ERROR_INVALID_EMAIL":
        throw new NotAnEmailException(platformException,
            "The email ($email) is not an email. This should have been checked by the login screen BEFORE submitting a password reset email request!");
        break;
      case "ERROR_USER_NOT_FOUND":
        print("The user with email ($email) could not be found!");
        break;
    }
  } on Exception catch (e) {
    print("An unknown Exception has occured! Exception is : $e");
  } catch (fatal) {
    print(
        "SomeWTFthing has happend! Object of type ${fatal
            .runtimeType} has been thrown. Trying to print it: $fatal");
  }
}

Future<bool> isUserSignedIn() async {
  await _refreshCurrentlyLoggedInUser();
  return _user != null ? true : false;
}

bool isUserSignedInQuickCheck() {
  return _user != null ? true : false;
}

String getUidOfCurrentlySignedInUser() {
  if (isUserSignedInQuickCheck()) {
    return _user.uid;
  } else {
    return null;
  }
}

String getEmailOfCurrentlySignedInUser() {
  if (isUserSignedInQuickCheck()) {
    return _user.email;
  } else {
    return null;
  }
}

void signOut() async {
  await _auth.signOut();
  await _googleSignIn.signOut();
  _user = null;
  print("SignOut done!");
}

//auth stream to be registered of user changes
Stream<FirebaseUser> get user {
  return _auth.onAuthStateChanged;
}