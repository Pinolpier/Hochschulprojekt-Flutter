class FriendGroup {
  String _groupname;
  List<String> _attendees;

  FriendGroup(this._attendees);

  List<String> get attendees => _attendees;

  set attendees(List<String> value) {
    _attendees = value;
  }

  String get groupname => _groupname;

  set groupname(String value) {
    _groupname = value;
  }
}
