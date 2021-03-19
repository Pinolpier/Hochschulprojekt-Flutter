/// author Markus link
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:univents/controller/userProfileService.dart';

/// spoken values for the different privacy options
final int PRIVATE = 1;
final int FRIENDS = 2;
final int PUBLIC = 3;

/// todo: CONSIDER writing a library-level doc comment
/// --> What
/// used to model a UserProfile of the App
class UserProfile {
  /// todo: add documentation for the variables
  /// --> What (sprechende Namen)
  String _uid;
  String _username;
  String _email;
  String _forename;
  String _surname;
  String _biography;
  List<String> _tags;
  int _emailVisibility = PRIVATE;
  int _nameVisibility = PRIVATE;
  int _tagsVisibility = PRIVATE;

  /// Takes all values from a [UserProfile] except the visibilities which have to be set using [tagVisibility], [emailVisibility] an [nameVisibility] methods.
  /// Their standard value is [PRIVATE] if not set.
  UserProfile(this._uid, this._username, this._email, this._forename,
      this._surname, this._biography, this._tags);

  /// Used to get an object from a [Firestore] query's return value, which is a [documentSnapshot].
  ///
  /// Visibilities will either be set to according to the values in the database or to [PRIVATE]
  UserProfile.fromDocumentSnapshot(Map<String, dynamic> documentSnapshot, String uid) {
    _uid = uid;
    _username = documentSnapshot['username'];
    _email = documentSnapshot['email'];
    _forename = documentSnapshot['forename'];
    _surname = documentSnapshot['surname'];
    _biography = documentSnapshot['biography'];
    _tags = documentSnapshot['tags'];
    _emailVisibility = documentSnapshot.containsKey('emailVisibility')
        ? documentSnapshot['emailVisibility']
        : PRIVATE;
    _nameVisibility = documentSnapshot.containsKey('nameVisibility')
        ? documentSnapshot['nameVisibility']
        : PRIVATE;
    _tagsVisibility = documentSnapshot.containsKey('tagsVisibility')
        ? documentSnapshot['tagsVisibility']
        : PRIVATE;
  }

  /// todo: missing documentation
  /// --> What
  String toString() {
    return 'UserProfile{_uid: $_uid, _username: $_username, _email: $_email, _forename: $_forename, _surname: $_surname, _biography: $_biography, _tags: $_tags, _emailVisibility: $_emailVisibility, _nameVisibility: $_nameVisibility, _tagsVisibility: $_tagsVisibility}';
  }

  /// returns a [Map] to store this instance in the [Firestore] database
  Future<Map<String, dynamic>> toMap() async {
    String pictureURI = await getProfilePictureUri(uid);
    return {
      'username': _username.toLowerCase(),
      'email': _email.toLowerCase(),
      'forename': _forename,
      'surname': _surname,
      'biography': _biography,
      'tags': _tags,
      'profilePicture': pictureURI,
      'emailVisibility': _emailVisibility,
      'tagsVisibility': _tagsVisibility,
      'nameVisibility': _nameVisibility
    };
  }

  String get biography => _biography;

  /// should only be used to update fields on the logged in User's profile
  set biography(String value) {
    _biography = value;
  }

  /// may be null if the logged in [FirebaseUser] has no access to this profile's information, because of it's [_nameVisibility] setting
  String get surname => _surname;

  /// should only be used to update fields on the logged in User's profile
  set surname(String value) {
    _surname = value;
  }

  /// may be null if the logged in [FirebaseUser] has no access to this profile's information, because of it's [_nameVisibility] setting
  String get forename => _forename;

  /// should only be used to update fields on the logged in User's profile
  set forename(String value) {
    _forename = value;
  }

  /// may be null if the logged in [FirebaseUser] has no access to this profile's information, because of it's [_emailVisibility] setting
  String get email => _email;

  /// should only be used to update fields on the logged in User's profile
  setEmail(String value) {
    _email = value;
  }

  String get username => _username;

  /// should only be used to update fields on the logged in User's profile
  set username(String value) {
    _username = value;
  }

  /// todo: missing documentation
  String get uid => _uid;

  /// should only be used to update fields on the logged in User's profile
  set uid(String value) {
    _uid = value;
  }

  int get tagsVisibility => _tagsVisibility;

  /// should only be used to update fields on the logged in User's profile
  set tagsVisibility(int value) {
    _tagsVisibility = value;
  }

  int get nameVisibility => _nameVisibility;

  /// should only be used to update fields on the logged in User's profile
  set nameVisibility(int value) {
    _nameVisibility = value;
  }

  int get emailVisibility => _emailVisibility;

  /// should only be used to update fields on the logged in User's profile
  set emailVisibility(int value) {
    _emailVisibility = value;
  }

  /// may be null if the logged in [FirebaseUser] has no access to this profile's information, because of it's [_tagsVisibility] setting
  List<String> get tags => _tags;

  /// should only be used to update fields on the logged in User's profile
  set tags(List<String> value) {
    _tags = value;
  }
}
