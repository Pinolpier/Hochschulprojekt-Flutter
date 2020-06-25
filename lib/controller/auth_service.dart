/// author: Markus Link
///
/// Use the methods provided in this script to do all operations regarding user authentication and user account management.
/// For user profile related things use [user_profile_service.dart].
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:univents/controller/user_profile_service.dart';
import 'package:univents/model/auth_exceptions.dart';
import 'package:univents/model/user_profile.dart';
import 'package:univents/service/log.dart';

/// These variables are references to our Auth plugins
final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

/// This variable is used to keep a reference to the current [FirebaseUser] that is logged in or [null] otherwise.
FirebaseUser _user;

/// These variables are needed to persistently safe, whether Apple Sign In is available on the device
bool isAppleSignInAvailable;
bool _hasBeenChecked = false;

/// Call this method to get a return bool that tells whether the device supports Sign-In-With-Apple.
///
/// This feature is only supported on iOS 13+ devices.
/// If this information has not been checked before this method needs time for asynchronously checking, that's why a [Future] is returned.
/// If this check was done before a value is returned instantly.
/// This method completely relies on a method from the [AppleSignIn] class which is provided by a plugin.
Future<bool> checkAppleSignInAvailability() async {
  if (!_hasBeenChecked) {
    isAppleSignInAvailable = await AppleSignIn.isAvailable();
    _hasBeenChecked = true;
  }
  return isAppleSignInAvailable;
}

/// used only internally (therefore _privateMethod). Used to update the reference to the currently logged in [_user].
Future<FirebaseUser> _refreshCurrentlyLoggedInUser() async {
  _user = await _auth.currentUser();
}

/// Call this method to start the process of Google Sign In. Everything is handled automatically.
///
/// Throws [UserDisabledException] if the user who tries to sign in is disabled e.g. because of manual action in the Firebase console
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
      Log().error(
          causingClass: "auth_service.dart",
          method: "googleSignIn()",
          action: "Google Sign In was aborted.");
      throw new SignInAbortedException(
          null, "The Google Sign In Process has been aborted!");
    }
    return await isUserSignedIn();
  } on Exception catch (error, stacktrace) {
    //TODO maybe add error type based error handling?
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action: error.toString() + " " + stacktrace.toString());
  }
}

/// Call this method to start the process of Apple Sign In.
///
/// Everything is handled automatically, except that
/// this METHOD DOES NOT CHECK, WHETHER APPLE SIGN IS AVAILABLE ON THE DEVICE, THIS HAS TO BE DONE BEFORE CALLING THIS METHOD!
/// Check for Apple Sign In availability (iOS 13 and higher) by calling [checkAppleSignInAvailability].
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
      Log().error(
          causingClass: "auth_service.dart",
          method: "appleSignIn()",
          action: ("AppleSignIn AuthorizationStatus Error occured: " +
              result.error.toString()));
      //Throw an exception here
      break;
    case AuthorizationStatus.cancelled:
      throw SignInAbortedException(null,
          "The AppleSignIn was aborted by the user and thus no user is logged in!");
      break;
  }
}

/// Call this method to sign a [FirebaseUser] in with email and password.
///
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
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action: "An unknown Exception has occured! Exception is : $e");
  } catch (fatal) {
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action:
        "SomeWTFthing has happend! Object of type ${fatal
            .runtimeType} has been thrown. Trying to print it: $fatal");
  }
  if (!_user.isEmailVerified) {
    _user.sendEmailVerification(); //TODO usability ? chris fragen
    signOut();
//    throw new UserEmailNotVerified(null,  //TODO einkommentieren sobald Fehlerbehandlung steht
//        "Email is not verified"); //TODO internationalisierung für Toast ?!
  }
  return _user != null ? true : false;
}

//TODO throw a NullParameterException in Email And Password methods and also throw a WeakPasswordException.
/// Call this method to register a [FirebaseUser] with email and password.
///
/// You should check [email] for correct format (meaning that the string truly represents an email) before calling this method!
/// You should check [password] for strength (meaning 8 characters, containing at least one number and letter) before calling this method!
/// None of the parameters [email] & [password] can be null!
/// Throws [NotAnEmailException] if the given String for [email] was not of correct format, this should be checked before calling this method.
Future<bool> registerWithEmailAndPassword(String email, String password) async {
  try {
    _user = (await _auth.createUserWithEmailAndPassword(
        email: email, password: password))
        .user;
    _user.sendEmailVerification();
  } on PlatformException catch (platformException) {
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action: platformException.toString());
    switch (platformException.code) {
      case "ERROR_WEAK_PASSWORD":
      //at least 6 characters needed
        break;
      case "ERROR_INVALID_EMAIL":
        throw new NotAnEmailException(platformException,
            "The email ($email) is not an email. This should have been checked by the login screen BEFORE submitting a registration request!");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        Log().error(causingClass: "auth_service.dart",
            method: "registerWithEmailAndPassword(String email, String password) async",
            action: "MailAlreadyInUseError");
        //TODO correct Error Handling, maybe offer to reset password or if an gmail address try google sign in?
        break;
    }
  } on Exception catch (e) {
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action: "An unknown Exception has occured! Exception is : $e");
  } catch (fatal) {
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action:
        "SomeWTFthing has happend! Object of type ${fatal
            .runtimeType} has been thrown. Trying to print it: $fatal");
  }
  if (!_user.isEmailVerified) {
    signOut();
    throw new UserEmailNotVerified(null,
        "Email is not verified"); //TODO internationalisierung für Toast ?!
  }
  return _user != null ? true : false;
}

/// use this method to change the email of the currently signed in user!
///
/// You should check [newEmail] for correct format (meaning that the string truly represents an email) before calling this method!
/// The [password] is required to reauthenticate the user before operating such sensitive stuff.
Future<void> changeEmailAddress(String newEmail, String password) async {
  await _user.reauthenticateWithCredential(
      EmailAuthProvider.getCredential( //TODO use [reauthenticate] method!
          email: getEmailOfCurrentlySignedInUser(), password: password));
  await _user.updateEmail(newEmail);
  UserProfile toUpdate =
  await (getUserProfile(getUidOfCurrentlySignedInUser()));
  await updateProfile(toUpdate.setEmail(newEmail));
}

/// used to delete an account.
///
/// Only the [userProfileService.deleteProfileOfCurrentlySignedInUser] should call this method!
Future<void> deleteAccount(BuildContext context) async {
  await _reauthenticate(context);
  await _user.delete(); // TODO handle different errors that could occur!
}

/// For some sensitive operations a prior re-authentication is required. This method is user only internally and therefore private.
/// The exact needed procedure depends on the identity provider that was used for creating the account (e.g. Google / Apple / E-Mail and Password). This method identifies the provider on its own and acts properly.
///
/// A [context] argument is needed to display dialogs in case user input is required.
Future<void> _reauthenticate(BuildContext context) async {
  String providerId = (_user.providerData.length > 1)
      ? _user.providerData[1].providerId
      : _user.providerData[0].providerId;

  if (providerId == GoogleAuthProvider.providerId) {
    final GoogleSignInAccount _googleAccountToSignIn =
    await _googleSignIn.signIn();
    if (_googleAccountToSignIn != null) {
      final GoogleSignInAuthentication _googleSignInAuthentication =
      await _googleAccountToSignIn.authentication;
      await _user.reauthenticateWithCredential(GoogleAuthProvider.getCredential(
          idToken: _googleSignInAuthentication.idToken,
          accessToken: _googleSignInAuthentication.accessToken));
    }
  } else if (providerId.contains("apple.com")) {
    // TODO show dialog to user that he/she has to sign in with apple again.
    // TODO Wrap with try / catch!
    try {
      final result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
      //TODO maybe remove duplicated code?
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider(providerId: 'apple.com');
          await _user.reauthenticateWithCredential(oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode)));
          break;
        case AuthorizationStatus.error:
        //TODO good exception handling here
          Log().error(causingClass: "auth_service.dart",
              method: "_reauthenticate()",
              action: "AppleSignIn AuthorizationStatus Error occured: " +
                  result.error.toString());
          //Throw an exception here
          break;
        case AuthorizationStatus.cancelled:
          Log().warn(causingClass: "auth_service.dart",
              method: "_reauthenticate()",
              action: "Sign In with Apple has been aborted!");
          throw SignInAbortedException(null,
              "The AppleSignIn was aborted by the user and thus no user is logged in!");
          break;
      }
    } on Exception catch (error, stacktrace) {
      Log().error(
          causingClass: "auth_service.dart",
          method: "_reauthenticate",
          action:
          "Something went wrong during Apple Reauthentication: Error: " +
              error.toString() +
              "; Stacktrace:  " +
              stacktrace.toString());
    }
  } else if (providerId == EmailAuthProvider.providerId) {
    final TextEditingController _editingController = TextEditingController();
    String _password;
    await showDialog<
        String>( //TODO define widget outside of _reauthenticate method.
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                obscureText: true,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Input your password below to confirm permanently deleting your account!',
                    hintText: 'password'),
                //TODO add internationalization and don't write about deletion, possibly called in other cases as well!
                controller: _editingController,
                onChanged: (string) {
                  _password = string;
                },
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              //TODO do NOT offer cancellation because deletion possibly already occured partially
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('CONFIRM'),
              onPressed: () async {
                await _user.reauthenticateWithCredential(
                    EmailAuthProvider.getCredential(
                        email: getEmailOfCurrentlySignedInUser(),
                        password: _password));
                Navigator.pop(context);
              })
        ],
      ),
    );
  } else {
    // TODO this should never happen?
  }
}

/// Call this method so Firebase can send an email for password reset.
///
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
        Log().error(causingClass: "auth_service.dart",
            method: "sendPasswordResetEmail(String email) async",
            action: "The user with email ($email) could not be found!");
        break;
    }
  } on Exception catch (e) {
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action: "An unknown Exception has occured! Exception is : $e");
  } catch (fatal) {
    Log().error(
        causingClass: 'userProfileService',
        method: 'updateProfile',
        action:
        "SomeWTFthing has happend! Object of type ${fatal
            .runtimeType} has been thrown. Trying to print it: $fatal");
  }
}

/// this method checks asynchronously whether a user is signed in in the firebase. Takes time because it uses the plugins method to check at firebase.
Future<bool> isUserSignedIn() async {
  await _refreshCurrentlyLoggedInUser();
  return _user != null ? true : false;
}

/// this method checks whether a user is signed in in the firebase. Is the quicker than [isUserSignedIn] because it only checks the internal variables.
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
  Log().info(causingClass: "auth_service.dart",
      method: "signOut() async",
      action: "SignOut done successfully!");
}

/// auth stream to be registered of user changes, should probably only be used to display the correct screen (Login vs. App)
Stream<FirebaseUser> get user {
  return _auth.onAuthStateChanged;
}