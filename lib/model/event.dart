import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment (for the class)

class Event {
  /// todo: add documentation for the variables
  String _eventID;
  String _title;
  DateTime _eventStartDate;
  DateTime _eventEndDate;
  String _description;
  dynamic _location;
  bool _privateEvent;
  String _latitude, _longitude;
  List<dynamic> _attendeesIds = new List();
  List<dynamic> _tagsList = new List();
  List<dynamic> _ownerIds = new List();
  File image;
  String _imageURL;

  /// todo: DO use prose to explain parameters, return values, and exceptions
  /// constructor for creating a event by a user
  Event(
      this._title,
      this._eventStartDate,
      this._eventEndDate,
      this._description,
      this._location,
      this._privateEvent,
      this._attendeesIds,
      this._tagsList,
      this._latitude,
      this._longitude);

  /// todo: DO separate the first sentence of a doc comment into its own paragraph
  /// todo: DO use prose to explain parameters, return values, and exceptions
  /// constructor for creating a event from the database
  /// from database the event getting a [eventId] and [imageUrl]
  /// additionally
  Event.createFrommDB(
      this._title,
      Timestamp startDate,
      Timestamp endDate,
      this._description,
      this._location,
      this._privateEvent,
      this._attendeesIds,
      this._tagsList,
      this._latitude,
      this._longitude,
      this._imageURL,
      this._ownerIds) {
    _eventStartDate = startDate.toDate();
    _eventEndDate = endDate.toDate();
  }

  /// todo: missing documentation
  /// todo: PREFER starting variable, getter, or setter comments with noun phrases
  bool get privateEvent => _privateEvent;

  /// todo: missing documentation
  void addAttendeesIds(String attendeesIds) {
    _attendeesIds.add(attendeesIds);
  }

  /// todo: missing documentation
  List<dynamic> get attendeesIds => _attendeesIds;

  /// todo: missing documentation
  set attendeesIds(List<String> value) {
    _attendeesIds = value;
  }

  /// todo: missing documentation
  set privateEvent(bool value) {
    _privateEvent = value;
  }

  /// todo: missing documentation
  String get title => _title;

  /// todo: missing documentation
  set title(String value) {
    _title = value;
  }

  /// todo: missing documentation
  String get description => _description;

  /// todo: missing documentation
  set description(String value) {
    _description = value;
  }

  /// todo: missing documentation
  DateTime get eventEndDate => _eventEndDate;

  /// todo: missing documentation
  set eventEndDate(DateTime value) {
    _eventEndDate = value;
  }

  /// todo: missing documentation
  DateTime get eventStartDate => _eventStartDate;

  /// todo: missing documentation
  set eventStartDate(DateTime value) {
    _eventStartDate = value;
  }

  /// todo: missing documentation
  String get eventID => _eventID;

  /// todo: missing documentation
  set eventID(String value) {
    _eventID = value;
  }

  /// todo: missing documentation
  String get imageURL => _imageURL;

  set imageURL(String value) {
    _imageURL = value;
  }

  /// todo: missing documentation
  dynamic get location => _location;

  /// todo: missing documentation
  set location(String value) {
    _location = value;
  }

  /// todo: missing documentation
  set location_to_geopoint(GeoPoint value) {
    _location = value;
  }

  /// todo: missing documentation
  List<dynamic> get tagsList => _tagsList;

  /// todo: missing documentation
  set tagsList(List<dynamic> value) {
    _tagsList = value;
  }

  /// todo: missing documentation
  get longitude => _longitude;

  /// todo: missing documentation
  set longitude(value) {
    _longitude = value;
  }

  /// todo: missing documentation
  get latitude => _latitude;

  /// todo: missing documentation
  set latitude(String value) {
    _latitude = value;
  }

  /// todo: missing documentation
  List<dynamic> get ownerIds => _ownerIds;

  /// todo: missing documentation
  set ownerIds(List<dynamic> value) {
    _ownerIds = value;
  }
}
