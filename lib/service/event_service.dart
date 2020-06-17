import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geo_firestore/geo_firestore.dart';
import 'package:univents/controller/authService.dart';
import 'package:univents/controller/storageService.dart';
import 'package:univents/model/event.dart';

import '../controller/authService.dart';
import 'log.dart';

/// Markus Häring
///
/// The EventService is responsible for correctly writing events
/// into the database and loading them from the database.
/// Various filters can also be set to load the events.

/// Collection-Name in database
final String _collection = 'events';

/// initialized database
final _database = Firestore.instance;

/// initialized geoFireStore based on the database and the collection
final GeoFirestore _geoFireStore =
    GeoFirestore(_database.collection(_collection));

/// dataField name in database for the endDate
final String _endDate = 'endDate';

/// dataField name in database for the startDate
final String _startDate = 'startDate';

/// dataField name in database for the list of event Owners
final String _eventOwner = 'eventOwner';

/// dataField name in database for the boolean of privateEvent
final String _privateEvent = 'private';

/// dataField name in database for the list of attendees
final String _attendees = 'attendeesIds';

/// dataField name in database for the event description
final String _description = 'description';

/// dataField name in database for the image url
final String _imageUrl = 'imageUrl';

/// dataField name in database for the event name
final String _eventName = 'name';

/// dataField name in database for the list of tags
final String _tags = 'tagsList';

/// dataField name in database for the location
final String _location = 'locationText';

/// dataField name in database for the latitude
final String _latitude = 'latitude';

/// dataField name in database for the longitude
final String _longitude = 'longitude';

/// filter for events startDate.
/// if the filter is set it will be considered in the search
Timestamp _startDateFilter;

/// filter for events endDate.
/// if the filter is set it will be considered in the search
Timestamp _endDateFilter;

/// filter for events tags.
/// if the filter is set it will be considered in the search
List<dynamic> _tagsFilter;

/// filter for events friends.
/// if the filter is set it will be considered in the search
List<dynamic> _friendIdFilter;

/// filter for private events.
/// if the filter is set it will be considered in the search
bool _privateEventFilter;

/// filter for own-users events.
/// if the filter is set it will be considered in the search
bool _myEventsFilter;

/// map to permanently save the url to the ids
Map<String, String> _urlToID = new Map();

/// uploads the data into the database when creating an [Event]
///
/// uploads a Event into the database by getting a [event]
/// if a [File] is also handed over, it is also uploaded and the
/// url for the file is assigned to the event
/// throws [PlatformException] when an Error occurs while storing
/// a Event in the database
void createEvent(File image, Event event) async {
  String uid = getUidOfCurrentlySignedInUser();
  event.ownerIds.add(uid);
  event.addAttendeesIds(uid);
  String eventID = await _addData(event);
  double latitude = double.parse(event.latitude);
  double longitude = double.parse(event.longitude);
  _geoFireStore.setLocation(eventID, GeoPoint(latitude, longitude));
  if (image != null) {
    Map<String, dynamic> eventMap = new Map();
    String imageURL = await uploadFile(_collection, image, eventID);
    eventMap[_imageUrl] = imageURL;
    _urlToID[eventID] = imageURL;
    await updateField(eventID, eventMap);
  }
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// fetches a [List] of events from the database by [geoLocation],[radius]
/// and [filters]
/// [List] may be empty if no Event was found
/// throws [PlatformException] when an error occurs while Fetching data
/// from Database
Future<List<Event>> get_events_near_location_and_filters(
    GeoPoint geo_location, double radius) async {
  List<DocumentSnapshot> documentList =
  await _geoFireStore.getAtLocation(geo_location, radius);
  for (int j = 0; j < documentList.length; j++) {
    bool remove = true;
    if (documentList[j].data[_privateEvent] == true) {
      List<dynamic> attendesList = documentList[j].data[_attendees];
      List<dynamic> ownerList = documentList[j].data[_eventOwner];
      if (attendesList != null &&
          attendesList.contains(getUidOfCurrentlySignedInUser()) ||
          ownerList != null &&
              ownerList.contains(getUidOfCurrentlySignedInUser())) {
        remove = false;
      }
      if (remove) {
        documentList.removeAt(j);
        j--;
      }
    }
  }
  if (_privateEventFilter != null) {
    documentList.removeWhere((DocumentSnapshot documentSnapshot) =>
    (documentSnapshot.data[_privateEvent] != privateEventFilter));
  }
  if (myEventFilter != null) {
    for (int j = 0; j < documentList.length; j++) {
      bool remove = true;
      List<dynamic> attendesList = documentList[j].data[_attendees];
      List<dynamic> ownerList = documentList[j].data[_eventOwner];
      if (attendesList != null &&
          attendesList.contains(getUidOfCurrentlySignedInUser()) ||
          ownerList != null &&
              ownerList.contains(getUidOfCurrentlySignedInUser())) {
        remove = false;
      }
      if (remove) {
        documentList.removeAt(j);
        j--;
      }
    }
  }
  if (friendIdFilter != null) {
    for (int j = 0; j < documentList.length; j++) {
      bool remove = true;
      List<dynamic> attendesList = documentList[j].data[_attendees];
      List<dynamic> ownerList = documentList[j].data[_eventOwner];
      for (int i = 0; i < friendIdFilter.length; i++) {
        if (attendesList != null && attendesList.contains(friendIdFilter[i]) ||
            ownerList != null && ownerList.contains(friendIdFilter[i])) {
          remove = false;
        }
      }
      if (remove) {
        documentList.removeAt(j);
        j--;
      }
    }
  }

  if (_startDateFilter != null) {
    for (int i = 0; i < documentList.length; i++) {
      Timestamp startdate = documentList[i].data[_startDate];
      if (startdate.toDate().isBefore(startDateFilter)) {
        documentList.removeAt(i);
        i--;
      }
    }
  }

  if (_endDateFilter != null) {
    for (int i = 0; i < documentList.length; i++) {
      Timestamp enddate = documentList[i].data[_endDate];
      if (enddate.toDate().isAfter(endDateFilter)) {
        documentList.removeAt(i);
        i--;
      }
    }
  }

  if (tagsFilter != null && tagsFilter.length > 0) {
    for (int x = 0; x < documentList.length; x++) {
      bool dontRemove = true;
      List<dynamic> tagsList = documentList[x].data[_tags];
      if (tagsList != null) {
        for (int i = 0; i < tagsFilter.length; i++) {
          if (tagsList.contains(tagsFilter[i])) {
            dontRemove = false;
          }
        }
      }
      if (dontRemove) {
        documentList.removeAt(x);
        x--;
      }
    }
  }
  List<Event> eventList = new List();
  for (int x = 0; x < documentList.length; x++) {
    Event event = _documentSnapshotToEvent(documentList[x]);
    event.eventID = documentList[x].documentID;
    eventList.add(event);
  }
  return eventList;
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// adds [Event] data to the database
/// throws [PlatformException] when an Error occurs while
/// updating Data in Database
Future<String> _addData(Event event) async {
  DocumentReference documentReference =
  await _database.collection(_collection).add(_eventToMap(event));
  return documentReference.documentID;
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// updates an event in the database based on an [Event]
/// throws [PlatformException] when Error occurs while updating Data
void updateData(Event event) async {
  if (event.eventID != null)
    _database
        .collection(_collection)
        .document(event.eventID)
        .updateData(_eventToMap(event));
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// in order to change an image of an event, the new [image] and the relevant [event] must be transferred
/// throws [PlatformException] when an Error occurs while
/// updating Image from Database
void updateImage(File image, Event event) async {
  if (event.imageURL != null) await deleteFile(_collection, event.eventID);
  String url = await uploadFile(_collection, image, event.eventID);
  _urlToID[event.eventID] = url;
  event.imageURL = url;
  updateData(event);
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// adds data to a existing field in the database based
/// on a [String] with the eventID and a [Map] with the new data
/// throws [PlatformException] when an Error occurs while
/// updating Event from Database
void updateField(String eventID, Map<dynamic, dynamic> map) {
  _database.collection(_collection).document(eventID).updateData(map);
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// deletes an event in the database based on an [Event]
/// throws [PlatformException] when an Error occurs while
/// deleting Event from Database
deleteEvent(Event event) async {
  if (event.eventID != null) {
    if (event.imageURL != null) {
      deleteFile(event.eventID, _collection);
    }
    _database.collection(_collection).document(event.eventID).delete();
  }
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// Returns a [Widget] with a image based on an [String] eventID
/// throws [PlatformException] when an Error occurs while Fetching imageURL
Future<Widget> getImage(String eventID) async {
  String url;
  if (_urlToID.containsKey(eventID)) {
    url = _urlToID[eventID];
  } else {
    DocumentSnapshot documentSnapshot =
    await _database.collection(_collection).document(eventID).get();
    url = documentSnapshot.data[_imageUrl].toString();
    _urlToID[eventID] = url;
  }
  if (url != null && url.isNotEmpty)
    return Image.network(url);
  else
    return null;
}

/// Fetches all events from the database and filters
/// them based on the set filters
///
/// returns a [List] of all available events
/// then filters based on the set filters
/// throws [PlatformException] when an error occurs while fetching data
Future<List<Event>> getEvents() async {
  QuerySnapshot qShot = await _database.collection(_collection).getDocuments();
  List<Event> eventList = new List();
  eventList = _snapShotToList(qShot);
  addEventIdToObjects(eventList, qShot);
  eventList = filterEvents(eventList);
  return eventList;
}


/// filters a list of events based on the filters set and deletes all
/// unnecessary events from the list
///
/// filters a List [eventList] with [Events] based on the set filters
/// and returns the updated [List]
List<Event> filterEvents(List<Event> eventList) {
  for (int j = 0; j < eventList.length; j++) {
    bool remove = true;
    if (eventList[j].privateEvent == true) {
      List<dynamic> attendesList = eventList[j].attendeesIds;
      List<dynamic> ownerList = eventList[j].ownerIds;
      if (attendesList != null &&
          attendesList.contains(getUidOfCurrentlySignedInUser()) ||
          ownerList != null &&
              ownerList.contains(getUidOfCurrentlySignedInUser())) {
        remove = false;
      }
      if (remove) {
        eventList.removeAt(j);
        j--;
      }
    }
  }
  if (_privateEventFilter != null) {
    eventList
        .removeWhere((Event event) => event.privateEvent != privateEventFilter);
  }
  if (myEventFilter != null) {
    for (int j = 0; j < eventList.length; j++) {
      bool remove = true;
      List<dynamic> attendesList = eventList[j].attendeesIds;
      List<dynamic> ownerList = eventList[j].ownerIds;
      if (attendesList != null &&
              attendesList.contains(getUidOfCurrentlySignedInUser()) ||
          ownerList != null &&
              ownerList.contains(getUidOfCurrentlySignedInUser())) {
        remove = false;
      }
      if (remove) {
        eventList.removeAt(j);
        j--;
      }
    }
  }
  if (friendIdFilter != null) {
    for (int j = 0; j < eventList.length; j++) {
      bool remove = true;
      List<dynamic> attendeesList = eventList[j].attendeesIds;
      List<dynamic> ownerList = eventList[j].ownerIds;
      for (int i = 0; i < friendIdFilter.length; i++) {
        if (attendeesList != null &&
            attendeesList.contains(friendIdFilter[i]) ||
            ownerList != null && ownerList.contains(friendIdFilter[i])) {
          remove = false;
        }
      }
      if (remove) {
        eventList.removeAt(j);
        j--;
      }
    }
  }

  if (_startDateFilter != null) {
    for (int i = 0; i < eventList.length; i++) {
      DateTime startDate = eventList[i].eventStartDate;
      if (startDate.isBefore(startDateFilter)) {
        eventList.removeAt(i);
        i--;
      }
    }
  }

  if (_endDateFilter != null) {
    for (int i = 0; i < eventList.length; i++) {
      DateTime endDate = eventList[i].eventEndDate;
      if (endDate.isAfter(endDateFilter)) {
        eventList.removeAt(i);
        i--;
      }
    }
  }

  if (tagsFilter != null && tagsFilter.length > 0) {
    for (int x = 0; x < eventList.length; x++) {
      bool remove = true;
      List<dynamic> tagsList = eventList[x].tagsList;
      if (tagsList != null) {
        for (int i = 0; i < tagsFilter.length; i++) {
          if (tagsList.contains(tagsFilter[i])) {
            remove = false;
          }
        }
      }
      if (remove) {
        eventList.removeAt(x);
        x--;
      }
    }
  }

  return eventList;
}

/// Wraps a QuerySnapshot from database into a List of Events
///
/// returns a [List] of events that was created based
/// on a [QuerySnapshot] or returns [null] when no Event was found
List<Event> _snapShotToList(QuerySnapshot qShot) {
  if (qShot != null) {
    return qShot.documents
        .map((doc) =>
        Event.createFromDB(
          doc.data[_eventName],
          doc.data[_startDate],
          doc.data[_endDate],
          doc.data[_description],
          doc.data[_location],
          doc.data[_privateEvent],
          doc.data[_attendees],
          doc.data[_tags],
          doc.data[_latitude],
          doc.data[_longitude],
          doc.data[_imageUrl],
          doc.data[_eventOwner],
        ))
        .toList();
  } else

    //show_toast(AppLocalizations.of(context).translate("no_events_found"));
    Log().error(
        causingClass: 'event_service',
        method: '_snapShotToList',
        action: "No matching events found!");
  //TODO: show Toast with internationalized message
  return null;
}

/// Returns a [Event] based on a [documentSnapshot]
Event _documentSnapshotToEvent(DocumentSnapshot documentSnapshot) {
  Event event = new Event.createFromDB(
      documentSnapshot.data[_eventName],
      documentSnapshot.data[_startDate],
      documentSnapshot.data[_endDate],
      documentSnapshot.data[_description],
      documentSnapshot.data[_location],
      documentSnapshot.data[_privateEvent],
      documentSnapshot.data[_attendees],
      documentSnapshot.data[_tags],
      documentSnapshot.data[_latitude],
      documentSnapshot.data[_longitude],
      documentSnapshot.data[_imageUrl],
      documentSnapshot.data[_eventOwner]);
  return event;
}

/// Wraps a [Event] into a [Map] and returns a [Map<String, dynamic>]
Map<String, dynamic> _eventToMap(Event event) {
  return {
    _eventName: event.title,
    _description: event.description,
    _location: event.location,
    _startDate: event.eventStartDate,
    _endDate: event.eventEndDate,
    _privateEvent: event.privateEvent,
    _attendees: event.attendeesIds,
    _tags: event.tagsList,
    _imageUrl: event.imageURL,
    _latitude: event.latitude,
    _longitude: event.longitude,
    _eventOwner: event.ownerIds
  };
}

/// adds Event'ids based on a [QuerySnapshot] to a List<Events>[eventList]
/// and returns the [List]
List<Event> addEventIdToObjects(List<Event> eventList, QuerySnapshot qShot) {
  for (int x = 0; x < eventList.length; x++) {
    eventList[x].eventID = qShot.documents[x].documentID;
  }
  return eventList;
}

/// ExceptionHandling for all PlatformException thrown by Firebase
///
/// should be used to decode PlatformExceptions by Firebase
///
/// handles errors by [platformException] and returns a [String]
/// with the decoded error message or the original message text if no
/// case applies to the given ones
String exceptionHandling(PlatformException platformException) {
  switch (platformException.code) {
    case ('ABORTED'):
      return ('The operation was aborted, typically due to a concurrency issue like transaction aborts, etc.');
      break;
    case ('ALREADY_EXISTS'):
      return ('Some document that we attempted to create already exists.');
      break;
    case ('CANCELLED'):
      return ('The operation was cancelled (typically by the caller).');
      break;
    case ('DATA_LOSS'):
      return ('Unrecoverable data loss or corruption.');
      break;
    case ('DEADLINE_EXCEEDED'):
      return ('Deadline expired before operation could complete. For operations that change the state of the system, this error may be returned even if the operation has completed successfully. For example, a successful response from a server could have been delayed long enough for the deadline to expire.');
      break;
    case ('FAILED_PRECONDITION'):
      return ('Operation was rejected because the system is not in a state required for the operations execution.');
      break;
    case ('INTERNAL'):
      return ('Internal errors. Means some invariants expected by underlying system has been broken. If you see one of these errors, something is very broken.');
      break;
    case ('INVALID_ARGUMENT'):
      return ('Client specified an invalid argument. Note that this differs from FAILED_PRECONDITION. INVALID_ARGUMENT indicates arguments that are problematic regardless of the state of the system (e.g., an invalid field name).');
      break;
    case ('NOT_FOUND'):
      return ('Some requested document was not found.');
      break;
    case ('OK'):
      //The operation completed successfully. Firebase/Firestore Exception will never have a status of OK.
      return ('The operation completed successfully.');
      break;
    case ('OUT_OF_RANGE'):
      return ('Operation was attempted past the valid range.');
      break;
    case ('PERMISSION_DENIED'):
      return ('The caller does not have permission to execute the specified operation.');
      break;
    case ('RESOURCE_EXHAUSTED'):
      return ('Some resource has been exhausted, perhaps a per-user quota, or perhaps the entire file system is out of space.');
      break;
    case ('UNAUTHENTICATED'):
      return ('The request does not have valid authentication credentials for the operation.');
      break;
    case ('UNAVAILABLE'):
      return ('The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.');
      break;
    case ('UNIMPLEMENTED'):
      return ('Operation is not implemented or not supported/enabled.');
      break;
    case ('UNKNOWN'):
      return ('Unknown error or an error from a different error domain.');
      break;
  }
  return platformException.message;
}

/// todo: missing documentation
//Filter setter/getter and delete
set startDateFilter(DateTime value) {
  _startDateFilter = Timestamp.fromDate(value);
}

/// todo: missing documentation
set endDateFilter(DateTime value) {
  _endDateFilter = Timestamp.fromDate(value);
}

/// todo: missing documentation
void deleteEndFilter() {
  _endDateFilter = null;
}

/// todo: missing documentation
void deleteStartFilter() {
  _startDateFilter = null;
}

/// todo: missing documentation
void deleteTagFilter() {
  _tagsFilter = null;
}

/// todo: missing documentation
set tagsFilter(List<String> value) {
  _tagsFilter = value;
}

/// todo: missing documentation
DateTime get startDateFilter {
  if (_startDateFilter == null) {
    return null;
  } else {
    return _startDateFilter.toDate();
  }
}

/// returns
DateTime get endDateFilter {
  if (_endDateFilter == null) {
    return null;
  } else {
    return _endDateFilter.toDate();
  }
}

List<String> get tagsFilter => _tagsFilter;

set myEventFilter(bool value) {
  _myEventsFilter = value;
}


set privateEventFilter(bool value) {
  _privateEventFilter = value;
}


bool get myEventFilter => _myEventsFilter;


bool get privateEventFilter => _privateEventFilter;


void set friendIdFilter(List<dynamic> value) {
  _friendIdFilter = value;
}


List<dynamic> get friendIdFilter => _friendIdFilter;


void deleteFriendIdFilter() {
  _friendIdFilter = null;
}

void deletePrivateEventFilter() {
  privateEventFilter = null;
}

void deleteMyEventFilter() {
  _myEventsFilter = null;
}

Map<String, String> get urlToID => _urlToID;
