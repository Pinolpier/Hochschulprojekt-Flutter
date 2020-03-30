//@author mdarscht
class FeedItemImpl{
  String _title;
  DateTime _eventStartDate;
  DateTime _eventEndDate;
  var _duration;
  String _details;
  String _city;
  bool _privateEvent;
  //an image

  FeedItemImpl(this._title, this._eventStartDate, this._eventEndDate, this._details, this._city, this._privateEvent) {
    this._duration = _eventEndDate.difference(_eventStartDate);
  }

  String get title {
    return this._title;
  }

  DateTime get eventStartDate => _eventStartDate;

  DateTime get eventEndDate => _eventEndDate;

  get duration => _duration;

  String get details => _details;

  String get city => _city;

  bool get privateEvent => _privateEvent;

  set title(String value) {
    _title = value;
  }

  set eventStartDate(DateTime value) {
    _eventStartDate = value;
  }

  set eventEndDate(DateTime value) {
    _eventEndDate = value;
  }

  set details(String value) {
    _details = value;
  }

  set city(String value) {
    _city = value;
  }

  set privateEvent(bool value) {
    _privateEvent = value;
  }
}