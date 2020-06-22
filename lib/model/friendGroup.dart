/// todo: add author
/// todo: CONSIDER writing a library-level doc comment

class FriendGroup {
  /// todo: missing documenation for the variables
  String _groupname;
  List<String> _attendees;

  /// todo: missing documentation for constructor
  FriendGroup(this._attendees);

  /// todo: missing documentation
  List<String> get attendees => _attendees;

  /// todo: missing documentation
  set attendees(List<String> value) {
    _attendees = value;
  }

  /// todo: missing documentation
  String get groupname => _groupname;

  /// todo: missing documentation
  set groupname(String value) {
    _groupname = value;
  }
}
