import 'dart:io';

class UserProfile {
  String _uid, _username, _email, _forename, _surname, _biography;
  File picture;

  UserProfile(this._uid, this._username, this._email, this._forename,
      this._surname, this._biography, this.picture);

  get biography => _biography;

  String toString() {
    return 'UserProfile{_uid: $_uid, _username: $_username, _email: $_email, _forename: $_forename, _surname: $_surname, _biography: $_biography}';
  }

  set biography(value) {
    _biography = value;
  }

  get surname => _surname;

  set surname(value) {
    _surname = value;
  }

  get forename => _forename;

  set forename(value) {
    _forename = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get username => _username;

  set username(value) {
    _username = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

}