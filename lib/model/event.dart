import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Markus Häring

/// The Event class represents the model for each event
/// with all the information necessary for it
class Event {
  /// Id of Event, assigned by database
  String _eventID;

  /// Name of the Event
  String _title;

  /// Date when the event starts
  DateTime _eventStartDate;

  /// Date when the event ends
  DateTime _eventEndDate;

  /// information about the event
  String _description;

  /// location of the event, can be a [String] for informations
  /// about the location or a Geopoint relates to the location
  dynamic _location;

  /// boolean if the event is private or local. If its true, the event is private
  bool _privateEvent;

  /// latitude and longitude to the location of the event
  String _latitude, _longitude;

  /// List of all ids from attendees
  List<dynamic> _attendeesIds = new List();

  /// Tags relates to the event
  List<dynamic> _tagsList = new List();

  /// List of ids freom event owners
  List<dynamic> _ownerIds = new List();

  /// picture belongs to the event
  File image;

  /// URL relates to the eventPicture
  String _imageURL;

  /// constructor for creating a event by a user
  ///
  /// [title] String for the name of a Event
  /// [eventStartDate] a DateTime for the begin of the Event
  /// [eventEndDate] a DateTime for the end of the Event
  /// [description] String for the description of the Event
  /// [location] dynamic Object with actual Text information about the location
  /// [privateEvent] bool if the event is private or public. if the field is
  /// to true, a event is marked as private, false for public
  /// [attendeesIds] a List filled with UIDs for all attendees
  /// [tagsList] a List filled with tags which the User chooses
  /// [latitude] String for the latitude of the Event location
  /// [longitude] String for longitude of the Event location
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

  /// Named Constructor for creating a event from the database
  ///
  /// this constructor should be used if an event has been loaded
  /// from the database and therefore an [eventID] exists
  ///
  /// [title] String for the name of a Event
  /// [eventStartDate] a DateTime for the begin of the Event
  /// [eventEndDate] a DateTime for the end of the Event
  /// [description] String for the description of the Event
  /// [location] dynamic Object with actual Text information about the location
  /// [privateEvent] bool if the event is private or public. if the field is
  /// to true, a event is marked as private, false for public
  /// [attendeesIds] a List filled with UIDs for all attendees
  /// [tagsList] a List filled with tags which the User chooses
  /// [latitude] String for the latitude of the Event location
  /// [longitude] String for longitude of the Event location
  /// [eventID] String with the id created by the Database
  /// [imageURL] String with the Url for the Event image. May be null if
  /// no image exists for the Event
  Event.createFromDB(
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

  /// adds a attendee to the attendeesList
  /// by getting a String [attendeesIds]
  void addAttendeesIds(String attendeesIds) {
    _attendeesIds.add(attendeesIds);
  }

  /// returns true, if the event is private
  /// returns false, if the events is public
  bool get privateEvent => _privateEvent;

  /// returns all ids of the participants including that of the event creator
  List<dynamic> get attendeesIds => _attendeesIds;

  set attendeesIds(List<String> value) {
    _attendeesIds = value;
  }

  set privateEvent(bool value) {
    _privateEvent = value;
  }

  /// returns the name of the Event
  String get title => _title;

  set title(String value) {
    _title = value;
  }

  /// returns the description of the event,
  /// may be null if non description exists
  String get description => _description;

  set description(String value) {
    _description = value;
  }

  /// returns the end of the Event
  DateTime get eventEndDate => _eventEndDate;

  set eventEndDate(DateTime value) {
    _eventEndDate = value;
  }

  /// returns the start of the Event
  DateTime get eventStartDate => _eventStartDate;

  set eventStartDate(DateTime value) {
    _eventStartDate = value;
  }

  /// returns the database id of the Event, may be null if event was not loaded
  /// from the database
  String get eventID => _eventID;

  set eventID(String value) {
    _eventID = value;
  }

  /// returns the url of the event image, may be null if non exists
  String get imageURL => _imageURL;

  set imageURL(String value) {
    _imageURL = value;
  }

  /// returns the location of the event, actual could be a Geopoint
  /// or a info String of the location
  dynamic get location => _location;

  /// sets the location by getting a String[value]
  /// with information about the location
  set location(String value) {
    _location = value;
  }

  /// sets the location by getting a GeoPoint [value]
  set location_to_geopoint(GeoPoint value) {
    _location = value;
  }

  /// returns all tags that relates to the event
  List<dynamic> get tagsList => _tagsList;

  set tagsList(List<dynamic> value) {
    _tagsList = value;
  }

  /// returns the longitude of the Events location
  get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
  }

  /// returns the latitude of the Events location
  get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  /// returns the [List] of owner ids
  List<dynamic> get ownerIds => _ownerIds;

  set ownerIds(List<dynamic> value) {
    _ownerIds = value;
  }
}
