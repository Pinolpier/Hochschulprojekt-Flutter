import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/storageService.dart';

final db = Firestore.instance;
final String collection = 'events';
Map<String, String> urlToID = new Map();
String _uid;
Timestamp _startDate;
Timestamp _endDate;
List<dynamic> _tags;

/// uploads the data into the database when creating an [Event]
/// if a [File] is also handed over, it is also uploaded and the
/// url for the file is assigned to the event
void createEvent(File image, Event event) async {
  String eventID = await _addData(event);
  if (image != null) {
    event.imageURL = await uploadImage('eventPicture', image, event.eventID);
  }
  if (event.imageURL != null) urlToID[eventID] = event.imageURL;
}

/// fetches a [List<Event>] of events from the database and checks
/// which filters are set
Future<List<Event>> getEvents() async {
  if (startDate != null) {
    if (endDate != null) {
      if (tags != null) {
        return await getEventsbyStartStopdateAndTag(startDate, endDate, tags);
      } else {
        return await getEventsbyStartAndStopDate(startDate, endDate);
      }
    } else {
      return await _getEventsbyStartDate(startDate);
    }
  } else if (tags != null) {
  } else if (endDate != null) {
    return await _getEventsbyEndDate(endDate);
  } else
    getallEvents();
}

/// adds [Event] data to the database
Future<String> _addData(Event event) async {
  try {
    DocumentReference documentReference =
        await db.collection(collection).add(_eventToMap(event));
    return documentReference.documentID;
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// updates an event in the database based on an [Event]
updateData(Event event) async {
  try {
    if (event.eventID != null)
      db
          .collection(collection)
          .document(event.eventID)
          .updateData(_eventToMap(event));
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// deletes an event in the databse based on an [Event]
deleteEvent(Event event) async {
  if (event.eventID != null) {
    try {
      if(event.imageURL != null){
        deleteImage(event.eventID);
      }
      db.collection(collection).document(event.eventID).delete();
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }
}

/// Returns a [Widget] with a image based on an [String] eventID
Future<Widget> getImage(String eventID) async {
  String key = '';
  if (urlToID.containsValue(eventID)) {
    key = urlToID.keys
        .firstWhere((k) => urlToID[k] == eventID, orElse: () => null);
  } else {
    DocumentSnapshot documentSnapshot =
        await db.collection(collection).document(eventID).get();
    key = documentSnapshot.data['imageUrl'].toString();
  }
  return Image.network(key);
}

/// Returns a [Event] based on the [eventID]
Future<Event> _getEventbyID(String eventID) async {
  DocumentSnapshot documentSnapshot =
      await db.collection(collection).document(eventID).get();
  return _documentSnapshotToEvent(documentSnapshot);
}

///
Event _documentSnapshotToEvent(DocumentSnapshot documentSnapshot) {
  Event event = new Event(
      documentSnapshot.data['name'],
      documentSnapshot.data['startdate'],
      documentSnapshot.data['enddate'],
      documentSnapshot.data['description'],
      documentSnapshot.data['location'],
      documentSnapshot.data['private'],
      documentSnapshot.data['teilnehmerIDs'],
      documentSnapshot.data['tagsList'],
      documentSnapshot.data['latitude'],
      documentSnapshot.data['longitude']);
  return event;
}

/// Wrappes a [Event] into a [Map]
Map<String, dynamic> _eventToMap(Event event) {
  return {
    'name': event.title,
    'description': event.description,
    'location': event.location,
    'startdate': event.eventStartDate,
    'enddate': event.eventEndDate,
    'private': event.privateEvent,
    'teilnehmerIDs': event.teilnehmerIDs,
    'tagsList': event.tagsList,
    'imageUrl': event.imageURL,
    'latitude': event.latitude,
    'longitude': event.longitude
  };
}

/// returns a [List] of events based on a [Timestamp]
/// start and [Timestamp] stopdate
Future<List<Event>> getEventsbyStartAndStopDate(
    Timestamp start, Timestamp stop) async {
  try {
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('startdate', isGreaterThanOrEqualTo: start)
        .where('enddate', isLessThanOrEqualTo: stop)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on a [Timestamp] startdate
Future<List<Event>> _getEventsbyStartDate(Timestamp start) async {
  try {
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('startdate', isLessThanOrEqualTo: start)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on a [Timestamp] enddate
Future<List<Event>> _getEventsbyEndDate(Timestamp stop) async {
  try {
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('enddate', isGreaterThanOrEqualTo: stop)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on [Timestamp] startdate ,
/// [Timestamp] stopdate and a [List] of Strings including the tags
Future<List<Event>> getEventsbyStartStopdateAndTag(
    Timestamp start, Timestamp stop, List<String> tags) async {
  try {
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('startdate', isLessThanOrEqualTo: start)
        .where('enddate', isGreaterThanOrEqualTo: stop)
        .where('tagsList', arrayContainsAny: tags)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on a [Timestamp] startdate
Future<List<Event>> getUsersEvents() async {
  try {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('teilnehmerIDs', arrayContains: uid)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on a [Timestamp]
/// start and [Timestamp] stopdate for the current User
Future<List<Event>> getEventsbyUserAndStartAndStopDate(
    Timestamp start, Timestamp stop) async {
  try {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('teilnehmerIDs', arrayContains: uid)
        .where('startdate', isGreaterThanOrEqualTo: start)
        .where('enddate', isLessThanOrEqualTo: stop)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on a
/// [Timestamp] stopdate for the current User
Future<List<Event>> getEventsbyUserAndStopDate(
    Timestamp start, Timestamp stop) async {
  try {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('teilnehmerIDs', arrayContains: uid)
        .where('enddate', isLessThanOrEqualTo: stop)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on a
/// [Timestamp] startdate for the current User
Future<List<Event>> getEventsbyUserAndStartDate(
    Timestamp start, Timestamp stop) async {
  try {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .where('teilnehmerIDs', arrayContains: uid)
        .where('startdate', isGreaterThanOrEqualTo: start)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of events based on a
/// [List] with tags
Future<List<Event>> getEventsbyTags(List<String> tagsList) async {
  try {
    QuerySnapshot qShot = await db
        .collectionGroup(collection)
        .reference()
        .where('tagsList', arrayContainsAny: tagsList)
        .getDocuments();
    return snapShotToList(qShot);
  } on PlatformException catch (e) {
    exceptionhandling(e);
  }
}

/// returns a [List] of all available events
Future<List<Event>> getallEvents() async {
  QuerySnapshot qShot = await db.collection(collection).getDocuments();
  return snapShotToList(qShot);
}

/// returns a [List] of events that was created based
/// on a [QuerySnapshop]
List<Event> snapShotToList(QuerySnapshot qShot) {
  if (qShot != null) {
    return qShot.documents
        .map((doc) => Event(
            doc.data['name'],
            doc.data['startdate'].toDate(),
            doc.data['enddate'].toDate(),
            doc.data['details'],
            doc.data['city'],
            doc.data['private'],
            doc.data['teilnehmerIDs'],
            doc.data['tagsList'],
            doc.data['latitude'],
            doc.data['longitude']))
        .toList();
  } else
    print('Keine passenden Events gefunden');
}

/// adds Event'ids based on a [QuerySnapshot] to a [List] of events
void addEventIdToObjects(List<Event> eventList, QuerySnapshot qShot) {
  for (int x = 0; x < eventList.length; x++) {
    eventList[x].eventID = qShot.documents[x].documentID;
  }
}

/// handles errors by [PlatformException]
void exceptionhandling(PlatformException e) {
  switch (e.code) {
    case ('ABORTED'):
      print(
          'The operation was aborted, typically due to a concurrency issue like transaction aborts, etc.');
      break;
    case ('ALREADY_EXISTS'):
      print('Some document that we attempted to create already exists.');
      break;
    case ('CANCELLED'):
      print('The operation was cancelled (typically by the caller).');
      break;
    case ('DATA_LOSS'):
      print('Unrecoverable data loss or corruption.');
      break;
    case ('DEADLINE_EXCEEDED'):
      print(
          'Deadline expired before operation could complete. For operations that change the state of the system, this error may be returned even if the operation has completed successfully. For example, a successful response from a server could have been delayed long enough for the deadline to expire.');
      break;
    case ('FAILED_PRECONDITION'):
      print(
          'Operation was rejected because the system is not in a state required for the operations execution.');
      break;
    case ('INTERNAL'):
      print(
          'Internal errors. Means some invariants expected by underlying system has been broken. If you see one of these errors, something is very broken.');
      break;
    case ('INVALID_ARGUMENT'):
      print(
          'Client specified an invalid argument. Note that this differs from FAILED_PRECONDITION. INVALID_ARGUMENT indicates arguments that are problematic regardless of the state of the system (e.g., an invalid field name).');
      break;
    case ('NOT_FOUND'):
      print('Some requested document was not found.');
      break;
    case ('OK'):
      //The operation completed successfully. FirebaseFirestoreException will never have a status of OK.
      print('The operation completed successfully.');
      break;
    case ('OUT_OF_RANGE'):
      print('Operation was attempted past the valid range.');
      break;
    case ('PERMISSION_DENIED'):
      print(
          'The caller does not have permission to execute the specified operation.');
      break;
    case ('RESOURCE_EXHAUSTED'):
      print(
          'Some resource has been exhausted, perhaps a per-user quota, or perhaps the entire file system is out of space.');
      break;
    case ('UNAUTHENTICATED'):
      print(
          'The request does not have valid authentication credentials for the operation.');
      break;
    case ('UNAVAILABLE'):
      print(
          'The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.');
      break;
    case ('UNIMPLEMENTED'):
      print('Operation is not implemented or not supported/enabled.');
      break;
    case ('UNKNOWN'):
      print('Unknown error or an error from a different error domain.');
      break;
  }
}

set startDate(Timestamp value) {
  _startDate = value;
}

set endDate(Timestamp value) {
  _endDate = value;
}

void deleteEndFilter() {
  endDate = null;
}

void deleteStartFilter() {
  startDate = null;
}

void deleteTagFilter() {
  tags = null;
}

set tags(List<String> value) {
  _tags = value;
}

Timestamp get startDate => _startDate;

Timestamp get endDate => _endDate;

List<String> get tags => _tags;
