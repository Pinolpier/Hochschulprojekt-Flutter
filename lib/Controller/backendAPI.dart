import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:univents/Model/backendExceptions.dart';

/// These variables are references to our Auth plugins
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

/// This variable is used to keep a reference to the current [FirebaseUser] that is logged in or [null] otherwise.
FirebaseUser _user;

/// These variables are needed to persistently safe, whether Apple Sign In is available on the device
bool isAppleSignInAvailable;
bool _hasBeenChecked = false;

/// Call this method to get a return bool that tells whether the device supports Sign-In-With-Apple. This feature is only supported on iOS 13+ devices.
/// If this information has not been checked before this method needs time for asynchronously checking, that's why a [Future] is returned.
/// This method completely relies on a method from the [AppleSignIn] class which is provided by a plugin.
Future<bool> checkAppleSignInAvailability() async {
  if (!_hasBeenChecked) {
    _hasBeenChecked = true;
    isAppleSignInAvailable = await AppleSignIn.isAvailable();
  }
  return isAppleSignInAvailable;
}

//TODO maybe use the following plugin to keep users signed in?: https://pub.dev/packages/flutter_secure_storage#-changelog-tab-

/// used only internally (therefore _privateMethod). Used to update the reference to the currently logged in [_user].
Future<FirebaseUser> _refreshCurrentlyLoggedInUser() async {
  _user = await _auth.currentUser();
}

/// Call this method to start the process of Google Sign In. Everything is handled automatically.
/// Throws [UserDisabledException] if the user that tries to sign in is disabled e.g. because of manual action in the Firebase console
/// Throws [SignInAbortedException] if the user aborted the Google Sign In, e.g. by pressing Cancel.
/// In all cases an appropriate error should be shown by the calling UI and no user will be signed in!
/// Returns [bool] whether the sign in was successful meaning true only if a user is signed in afterwards.
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
            throw new UserDisabledException(
                platformException,
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
  } on Exception catch (error, stacktrace) {
    //TODO maybe add error type based error handling?
    //TODO log error
    print("Das hier ist der Error:");
    print(error.toString() + "\n" + stacktrace.toString());
  }
}

/// Call this method to start the process of Apple Sign In. Everything is handled automatically, except that
/// this METHOD DOES NOT CHECK, WHETHER APPLE SIGN IS AVAILABLE ON THE DEVICE, THIS HAS TO BE DONE BEFORE CALLING THIS METHOD!
/// Check for Apple Sign In availability (iOS 13 and higher) by calling [backendAPI.checkAppleSignInAvailability].
/// Throws [UserDisabledException] if the user that tries to sign in is disabled e.g. because of manual action in the Firebase console
/// Throws [SignInAbortedException] if the user aborted the Apple Sign In, e.g. by pressing Cancel.
/// In all cases an appropriate error should be shown by the calling UI and no user will be signed in!
/// Returns [bool] whether the sign in was successful meaning true only if a user is signed in afterwards.
Future<bool> appleSignIn() async {
  final result = await AppleSignIn.performRequests([
    AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  ]);
  switch (result.status) {
    case AuthorizationStatus.authorized:
      final appleIdCredential = result.credential;
      final oAuthProvider = OAuthProvider(providerId: 'apple.com');
      final _credentials = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
          String.fromCharCodes(appleIdCredential.authorizationCode));
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
            throw new UserDisabledException(
                platformException,
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
      print("AppleSignIn AuthorizationStatus Error occured: " +
          result.error.toString());
      //Throw an exception here
      break;
    case AuthorizationStatus.cancelled:
      throw SignInAbortedException(null,
          "The AppleSignIn was aborted by the user and thus no user is logged in!");
      break;
  }
}

/// Call this method to sign a [FirebaseUser] in with email and password.
/// You should check [email] for correct format (meaning that the string truly represents an email) before calling this method!
/// None of the parameters [email] & [password] can be null!
/// Throws [NotAnEmailException] if the given String for [email] was not of correct format, this should be checked before calling this method.
/// Throws [WrongPasswordException] if the given combination of [email] and [password] do not match, meaning no user could be signed in because the password is wrong.
/// Think twice, whether you tell in the error that the user exists. Should probably be catched together with:
/// Throws [UserNotFoundException] if the given user doesn't exist and should be registered first.
/// Throws [UserDisabledException] if the user that tries to sign in is disabled e.g. because of manual action in the Firebase console
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

//TODO throw a NullParameterException in Email And Password methods and also throw a WeakPasswordException.
/// Call this method to register a [FirebaseUser] with email and password.
/// You should check [email] for correct format (meaning that the string truly represents an email) before calling this method!
/// You should check [password] for strength (meaning 8 characters, containing at least one number and letter) before calling this method!
/// None of the parameters [email] & [password] can be null!
/// Throws [NotAnEmailException] if the given String for [email] was not of correct format, this should be checked before calling this method.
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

/// Call this method so Firebase can send an email for password reset.
/// Parameter [email] must be a correctly formatted email address.
/// Throws an [NotAnEmailException] if the parameter [email] was malformed.
/// Throws an [UserNotFoundException] if no user with the given email could be found. Think twice before telling a random guy entering random emails, whether or not a user can or cannot be found!
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

/// this method checks asynchronously whether a user is signed in in the firebase. Takes time because it uses the plugins method to check at firebase.
Future<bool> isUserSignedIn() async {
  await _refreshCurrentlyLoggedInUser();
  return _user != null ? true : false;
}

/// this method checks whether a user is signed in in the firebase. Is the quicker than [backendAPI.isUserSignedIn] because it only checks the internal variables.
/// Only use this if asynchronous requests are not an option for your code.
bool isUserSignedInQuickCheck() {
  return _user != null ? true : false;
}

/// Returns the [FirebaseUser.uid] of the currently signed in user or null if no user is signed in.
String getUidOfCurrentlySignedInUser() {
  if (isUserSignedInQuickCheck()) {
    return _user.uid;
  } else {
    return null;
  }
}

/// Returns the [FirebaseUser.email] of the currently signed in user or null if no user is signed in.
String getEmailOfCurrentlySignedInUser() {
  if (isUserSignedInQuickCheck()) {
    return _user.email;
  } else {
    return null;
  }
}

/// Starts the sign out process from Firebase.
void signOut() async {
  await _auth.signOut();
  await _googleSignIn.signOut();

  _user = null;
  print("SignOut done!");
}

/// auth stream to be registered of user changes, should probably only be used to display the correct screen (Login vs. App)
Stream<FirebaseUser> get user {
  return _auth.onAuthStateChanged;
}