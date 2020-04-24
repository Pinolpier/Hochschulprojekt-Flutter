class UserProfile {
  String _uid;
  String _username;
  String _email;
  String _forename;
  String _surname;
  String _biography;

  UserProfile(this._uid, this._username, this._email, this._forename,
      this._surname, this._biography);


  UserProfile.fromDocumentSnapshot(Map<String, dynamic> documentSnapshot,
      String uid) {
    _uid = uid;
    _username = documentSnapshot['username'];
    _email = documentSnapshot['email'];
    _forename = documentSnapshot['forename'];
    _surname = documentSnapshot['surname'];
    _biography = documentSnapshot['biography'];
  }

  String toString() {
    return 'UserProfile{_uid: $_uid, _username: $_username, _email: $_email, _forename: $_forename, _surname: $_surname, _biography: $_biography}';
  }

  Map <String, dynamic> toMap() {
    return {
      'username': _username,
      'email': _email,
      'forename': _forename,
      'surname': _surname,
      'biography': _biography
    };
  }

  String get biography => _biography;

  set biography(String value) {
    _biography = value;
  }

  String get surname => _surname;

  set surname(String value) {
    _surname = value;
  }

  String get forename => _forename;

  set forename(String value) {
    _forename = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

}