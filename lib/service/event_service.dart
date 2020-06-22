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

/// todo: add author
/// todo: CONSIDER writing a library-level doc comment
/// todo: methods and variables in camel case

/// todo: make all variables private
//Collection-Name in database
final String collection = 'events';

//initialize Firestore and GeoFirestore
final db = Firestore.instance;
final GeoFirestore geoFirestore = GeoFirestore(db.collection(collection));

//DataField-names in database
final String endDate = 'endDate';
final String startDate = 'startDate';
final String eventOwner = 'eventOwner';
final String privateEvent = 'private';
final String attendees = 'attendeesIds';
final String description = 'description';
final String imageUrl = 'imageUrl';
final String eventName = 'name';
final String tags = 'tagsList';
final String location = 'locationText';
final String latitude = 'latitude';
final String longitude = 'longitude';

//Filter for database query's
Timestamp _startDateFilter;
Timestamp _endDateFilter;
List<dynamic> _tagsFilter;
List<dynamic> _friendIdFilter;
bool _privateEventFilter;
bool _myEventsFilter;

//map to permanently save the url to the ids
Map<String, String> _urlToID = new Map();

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// uploads the data into the database when creating an [Event]
/// if a [File] is also handed over, it is also uploaded and the
/// url for the file is assigned to the event
/// throws [PlatformException] when an Error occurs while storing
/// a Event in the database
void createEvent(File image, Event event) async {
  String uid = getUidOfCurrentlySignedInUser();
  event.ownerIds.add(uid);
  event.addAttendeesIds(uid);

  String eventID = await _addData(event);

  //TODO hier zu GeoPoint parsen oder direkt im Event ?
  double latitude = double.parse(event.latitude);
  double longitude = double.parse(event.longitude);
  geoFirestore.setLocation(eventID, GeoPoint(latitude, longitude));

  if (image != null) {
    Map<String, dynamic> eventMap = new Map();
    String imageURL = await uploadFile(collection, image, eventID);
    eventMap[imageUrl] = imageURL;
    _urlToID[eventID] = imageURL;
    await updateField(eventID, eventMap);
  }
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// fetches a [List] of events from the database and checks
/// which filters are set
/// throws [PlatformException] when an error occurs while Fetching data
/// from Database
Future<List<Event>> getEvents() async {
  var x;
  String uid = await getUidOfCurrentlySignedInUser();
  if (_privateEventFilter) {
    x = db
        .collectionGroup(collection)
        .reference()
        .where(privateEvent, isEqualTo: true)
        .where(attendees, arrayContains: uid);
  } else {
    x = db
        .collectionGroup(collection)
        .reference()
        .where(privateEvent, isEqualTo: false);
    if (_myEventsFilter) {
      x = x.where(attendees, arrayContains: uid);
    }
  }
  if (_startDateFilter != null) {
    x = x.where(startDate, isGreaterThanOrEqualTo: _startDateFilter);
  }
  if (_endDateFilter != null) {
    x = x.where(endDate, isSmallerThanOrEqualTo: _endDateFilter);
  }
  if (_tagsFilter != null) {
    //  x = x.where('tagsList', arrayContains: _tags);
  }
  if (_friendIdFilter != null) {
    // x = x.where(attendees, arrayContainsany:_friendIdFilter);
  }
  QuerySnapshot querySnapshot = await x.getDocuments();
  List<Event> eventList = _snapShotToList(querySnapshot);
  addEventIdToObjects(eventList, querySnapshot);
  return eventList;
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// fetches a [List] of events from the database by [geoLocation] and [radius]
/// [List] may be empty if no Event was found
/// throws [PlatformException] when an error occurs while Fetching data
/// from Database
Future<List<Event>> getEventNearLocation(
    GeoPoint geoLocation, double radius) async {
  final List<DocumentSnapshot> documentList =
      await geoFirestore.getAtLocation(geoLocation, radius);
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
/// fetches a [List] of events from the database by [geoLocation],[radius]
/// and [filters]
/// [List] may be empty if no Event was found
/// throws [PlatformException] when an error occurs while Fetching data
/// from Database
Future<List<Event>> get_events_near_location_and_filters(
    GeoPoint geo_location, double radius) async {
  List<DocumentSnapshot> documentList =
      await geoFirestore.getAtLocation(geo_location, radius);
  for (int j = 0; j < documentList.length; j++) {
    bool remove = true;
    if (documentList[j].data[privateEvent] == true) {
      List<dynamic> attendesList = documentList[j].data[attendees];
      List<dynamic> ownerList = documentList[j].data[eventOwner];
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
        (documentSnapshot.data[privateEvent] != privateEventFilter));
  }
  if (myEventFilter != null) {
    for (int j = 0; j < documentList.length; j++) {
      bool remove = true;
      List<dynamic> attendesList = documentList[j].data[attendees];
      List<dynamic> ownerList = documentList[j].data[eventOwner];
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
      List<dynamic> attendesList = documentList[j].data[attendees];
      List<dynamic> ownerList = documentList[j].data[eventOwner];
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
      Timestamp startdate = documentList[i].data[startDate];
      if (startdate.toDate().isBefore(startDateFilter)) {
        documentList.removeAt(i);
        i--;
      }
    }
  }

  if (_endDateFilter != null) {
    for (int i = 0; i < documentList.length; i++) {
      Timestamp enddate = documentList[i].data[endDate];
      if (enddate.toDate().isAfter(endDateFilter)) {
        documentList.removeAt(i);
        i--;
      }
    }
  }

  if (tagsFilter != null && tagsFilter.length > 0) {
    for (int x = 0; x < documentList.length; x++) {
      bool dontRemove = true;
      List<dynamic> tagsList = documentList[x].data[tags];
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
      await db.collection(collection).add(_eventToMap(event));
  return documentReference.documentID;
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// updates an event in the database based on an [Event]
/// throws [PlatformException] when Error occurs while updating Data
void updateData(Event event) async {
  if (event.eventID != null)
    db
        .collection(collection)
        .document(event.eventID)
        .updateData(_eventToMap(event));
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// in order to change an image of an event, the new [image] and the relevant [event] must be transferred
/// throws [PlatformException] when an Error occurs while
/// updating Image from Database
void updateImage(File image, Event event) async {
  if (event.imageURL != null) await deleteFile(collection, event.eventID);
  String url = await uploadFile(collection, image, event.eventID);
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
  db.collection(collection).document(eventID).updateData(map);
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// deletes an event in the database based on an [Event]
/// throws [PlatformException] when an Error occurs while
/// deleting Event from Database
deleteEvent(Event event) async {
  if (event.eventID != null) {
    if (event.imageURL != null) {
      deleteFile(event.eventID, collection);
    }
    db.collection(collection).document(event.eventID).delete();
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
        await db.collection(collection).document(eventID).get();
    url = documentSnapshot.data[imageUrl].toString();
    _urlToID[eventID] = url;
  }
  if (url != null && url.isNotEmpty)
    return Image.network(url);
  else
    return null;
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// returns a [List] of all available events
/// then filters based on the set filters
/// throws [PlatformException] when an error occurs while fetching data
Future<List<Event>> getAllEvents() async {
  QuerySnapshot qShot = await db.collection(collection).getDocuments();
  List<Event> eventList = new List();
  eventList = _snapShotToList(qShot);
  addEventIdToObjects(eventList, qShot);
  eventList = filterEvents(eventList);
  return eventList;
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// filters a [List] with [Events] based on the set filters
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
      List<dynamic> attendesList = eventList[j].attendeesIds;
      List<dynamic> ownerList = eventList[j].ownerIds;
      for (int i = 0; i < friendIdFilter.length; i++) {
        if (attendesList != null && attendesList.contains(friendIdFilter[i]) ||
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
      DateTime startdate = eventList[i].eventStartDate;
      if (startdate.isBefore(startDateFilter)) {
        eventList.removeAt(i);
        i--;
      }
    }
  }

  if (_endDateFilter != null) {
    for (int i = 0; i < eventList.length; i++) {
      DateTime enddate = eventList[i].eventEndDate;
      if (enddate.isAfter(endDateFilter)) {
        eventList.removeAt(i);
        i--;
      }
    }
  }

  if (tagsFilter != null && tagsFilter.length > 0) {
    for (int x = 0; x < eventList.length; x++) {
      bool dontRemove = true;
      List<dynamic> tagsList = eventList[x].tagsList;
      if (tagsList != null) {
        for (int i = 0; i < tagsFilter.length; i++) {
          if (tagsList.contains(tagsFilter[i])) {
            dontRemove = false;
          }
        }
      }
      if (dontRemove) {
        eventList.removeAt(x);
        x--;
      }
    }
  }

  return eventList;
}

/// todo: DO start doc comments with a single-sentence summary
/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// returns a [List] of events that was created based
/// on a [QuerySnapshot] returns nothing when no Event was found
List<Event> _snapShotToList(QuerySnapshot qShot) {
  if (qShot != null) {
    return qShot.documents
        .map((doc) => Event.createFrommDB(
              doc.data[eventName],
              doc.data[startDate],
              doc.data[endDate],
              doc.data[description],
              doc.data[location],
              doc.data[privateEvent],
              doc.data[attendees],
              doc.data[tags],
              doc.data[latitude],
              doc.data[longitude],
              doc.data[imageUrl],
              doc.data[eventOwner],
            ))
        .toList();
  } else
    //show_toast(AppLocalizations.of(context).translate("no_events_found"));
    Log().error(
        causingClass: 'event_service',
        method: '_snapShotToList',
        action: "No matching events found!");
  //TODO: show Toast with internationalized message
}

/// Returns a [Event] based on a documentSnapshot
Event _documentSnapshotToEvent(DocumentSnapshot documentSnapshot) {
  Event event = new Event.createFrommDB(
      documentSnapshot.data[eventName],
      documentSnapshot.data[startDate],
      documentSnapshot.data[endDate],
      documentSnapshot.data[description],
      documentSnapshot.data[location],
      documentSnapshot.data[privateEvent],
      documentSnapshot.data[attendees],
      documentSnapshot.data[tags],
      documentSnapshot.data[latitude],
      documentSnapshot.data[longitude],
      documentSnapshot.data[imageUrl],
      documentSnapshot.data[eventOwner]);
  return event;
}

/// Wraps a [Event] into a [Map]
Map<String, dynamic> _eventToMap(Event event) {
  return {
    eventName: event.title,
    description: event.description,
    location: event.location,
    startDate: event.eventStartDate,
    endDate: event.eventEndDate,
    privateEvent: event.privateEvent,
    attendees: event.attendeesIds,
    tags: event.tagsList,
    imageUrl: event.imageURL,
    latitude: event.latitude,
    longitude: event.longitude,
    eventOwner: event.ownerIds
  };
}

/// adds Event'ids based on a [QuerySnapshot] to a [List] of events
List<Event> addEventIdToObjects(List<Event> eventList, QuerySnapshot qShot) {
  for (int x = 0; x < eventList.length; x++) {
    eventList[x].eventID = qShot.documents[x].documentID;
  }
  return eventList;
}

/// todo: DO separate the first sentence of a doc comment into its own paragraph.
/// todo: DO use prose to explain parameters, return values, and exceptions
/// handles errors by [PlatformException] and returns a [String]
/// with the Error message
/// can be used by method caller to translate exception to a simple message
String exceptionHandling(PlatformException e) {
  switch (e.code) {
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
  return e.message;
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

/// todo: missing documentation
DateTime get endDateFilter {
  if (_endDateFilter == null) {
    return null;
  } else {
    return _endDateFilter.toDate();
  }
}

/// todo: missing documentation
List<String> get tagsFilter => _tagsFilter;

/// todo: missing documentation
set myEventFilter(bool value) {
  _myEventsFilter = value;
}

/// todo: missing documentation
set privateEventFilter(bool value) {
  _privateEventFilter = value;
}

/// todo: missing documentation
bool get myEventFilter => _myEventsFilter;

/// todo: missing documentation
bool get privateEventFilter => _privateEventFilter;

/// todo: missing documentation
void set friendIdFilter(List<dynamic> value) {
  _friendIdFilter = value;
}

/// todo: missing documentation
List<dynamic> get friendIdFilter => _friendIdFilter;

/// todo: missing documentation
void deleteFriendIdFilter() {
  _friendIdFilter = null;
}

/// todo: missing documentation
void deletePrivateEventFilter() {
  privateEventFilter = null;
}

/// todo: missing documentation
void deleteMyEventFilter() {
  _myEventsFilter = null;
}

/// todo: missing documentation
Map<String, String> get urlToID => _urlToID;
