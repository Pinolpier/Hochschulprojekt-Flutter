
class Event{
  String _title;
  DateTime _eventStartDate;
  DateTime _eventEndDate;
  var _duration;
  String _details;
  String _city;
  String _lat,_lng;
  bool _privateEvent;
  //an image

  Event(this._title, this._eventStartDate, this._eventEndDate, this._details, this._city, this._privateEvent,this._lat,this._lng) {
    this._duration = _eventEndDate.difference(_eventStartDate);
  }

  bool get privateEvent => _privateEvent;

  set privateEvent(bool value) {
    _privateEvent = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get details => _details;

  set details(String value) {
    _details = value;
  }

  get duration => _duration;

  set duration(value) {
    _duration = value;
  }

  DateTime get eventEndDate => _eventEndDate;

  set eventEndDate(DateTime value) {
    _eventEndDate = value;
  }

  DateTime get eventStartDate => _eventStartDate;

  set eventStartDate(DateTime value) {
    _eventStartDate = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }


}