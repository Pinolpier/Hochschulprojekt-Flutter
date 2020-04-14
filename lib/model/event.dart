import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  String _eventID;
  String _title;
  Timestamp _eventStartDate;
  Timestamp _eventEndDate;
  String _description;
  String _location;
  bool _privateEvent;
  List<dynamic> _teilnehmerIDs;
  List<dynamic> _tagsList;
  String _imageURL;
  File image;

  Event(this._title, this._eventStartDate, this._eventEndDate, this._description,
      this._location, this._privateEvent,this._teilnehmerIDs,this._imageURL,this._tagsList);

  Event.createEvent(this._title,this._eventStartDate,this._eventEndDate,this._description,this._location,this._privateEvent,this._tagsList,this.image);


  bool get privateEvent => _privateEvent;

  void addTeilnehmer(String teilnehmerID){
    teilnehmerIDs.add(teilnehmerID);
  }
  List<dynamic> get teilnehmerIDs => _teilnehmerIDs;

  set teilnehmerIDs(List<String> value) {
    _teilnehmerIDs = value;
  }

  set privateEvent(bool value) {
    _privateEvent = value;
  }


  String get title => _title;

  set title(String value) {
    _title = value;
  }


  String get description => _description;

  set description(String value) {
    _description = value;
  }

  Timestamp get eventEndDate => _eventEndDate;

  set eventEndDate(Timestamp value) {
    _eventEndDate = value;
  }

  Timestamp get eventStartDate => _eventStartDate;

  set eventStartDate(Timestamp value) {
    _eventStartDate = value;
  }

  String get eventID => _eventID;

  set eventID(String value) {
    _eventID = value;
  }

  String get imageURL => _imageURL;

  set imageURL(String value) {
    _imageURL = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }

  List<dynamic> get tagsList => _tagsList;

  set tagsList(List<dynamic> value) {
    _tagsList = value;
  }


}