import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:univents/model/event.dart';
import 'package:univents/service/storageService.dart';

///This class adds and gets data from the database
class eventService {
  final db = Firestore.instance;
  final String collection = 'events';
  Map<String, dynamic> urlToID;

  ///This Method should be called when a event should be created
  ///The File gets uploaded to Firebase storage
  ///The event gets uploaded to Firestore
  ///and the imageUrl gets saved in a internal Map
  ///@input: File reffering to event
  ///@input: Event who gets created
  void createEvent(File image, Event event) async {
    if (image != null) {
      event.imageURL = await storage().uploadImage('eventPicture', image);
    }
    String eventID = await addData(event);
    urlToID[eventID] = event.imageURL;
  }

  ///This Method writes the data into the database
  ///@input: Event who should added to database
  ///@return String with eventID
  Future<String> addData(Event event) async {
    try {
      DocumentReference documentReference =
          await db.collection(collection).add(eventToMap(event));
      return documentReference.documentID;
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///This Method searches for a Image belongs to an Event
  ///If there is no Url local saved the needed url gets loaded
  ///from database
  ///@input: eventID String of the wanted Event-Image
  ///@return: Widget with a image
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

  ///Search for a Event by the EventID
  ///@input: String containing the specific eventID
  ///@return: Event object
  Future<Event> getEventbyID(String eventID)async{
    DocumentSnapshot documentSnapshot = await db.collection(collection).document(eventID).get();
    return documentSnapshotToEvent(documentSnapshot);
  }

  ///Transforms a documentSnapshot into a event object
  ///@input: documentSnapshot from Firebase containing the event informations
  ///@return: Transformed Event Object
  Event documentSnapshotToEvent(DocumentSnapshot documentSnapshot){
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

  ///This Method gets an Event and wrappes it into a map for the database.
  ///@input: Event who should be wrapped to a Map
  ///@return: Map with the Informations that belong to an event
  Map<String, dynamic> eventToMap(Event event) {
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
      'latitude' : event.latitude,
      'longitude' : event.longitude
    };
  }

  /// updates a event in a database
  /// @input event which should get Updated
  updateData(Event event) async {
    try {
      if (event.eventID != null)
        db
            .collection(collection)
            .document(event.eventID)
            .updateData(eventToMap(event));
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///deletes a event in the database
  ///event which have to be deleted
   deleteEvent(Event event) async {
    if (event.eventID != null) {
      try {
        db.collection(collection).document(event.eventID).delete();
      } on PlatformException catch (e) {
        exceptionhandling(e);
      }
    }
  }

  ///Searches for Events in a specific Time
  ///@input: Start and Stop Timestamps
  ///@return: List of Events from the Database
  Future<List<Event>> getEventsbyStartAndStopDate(
      Timestamp start, Timestamp stop) async {
    try {
      QuerySnapshot qShot = await db
          .collectionGroup(collection)
          .where('startdate', isGreaterThanOrEqualTo: start)
          .where('enddate', isLessThanOrEqualTo: stop)
          .getDocuments();
      return snapShotToList(qShot);
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///Searches for Events since a specific Time
  ///@input: Timestamp of a startdate
  ///@return: List of Events from the Database
  Future<List<Event>> getEventsbyStartDate(Timestamp start) async {
    try {
      QuerySnapshot qShot = await db
          .collectionGroup(collection)
          .where('startdate', isGreaterThanOrEqualTo: start)
          .getDocuments();
      return snapShotToList(qShot);
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///Searches for Events until a specific Time
  ///@input: Timestamp until events will be searched
  ///@return: List of Events from the Database
  Future<List<Event>> getEventsbyEndDate(Timestamp stop) async {
    try {
      QuerySnapshot qShot = await db
          .collectionGroup(collection)
          .where('enddate', isLessThanOrEqualTo: stop)
          .getDocuments();
      return snapShotToList(qShot);
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///Searches for events of a specific user
  ///@return List of Events from the database
  Future<List<Event>> getUsersEvents() async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid;
      QuerySnapshot qShot = await db
          .collectionGroup(collection)
          .where('teilnehmerIDs', arrayContains: uid)
          .getDocuments();
      return snapShotToList(qShot);
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///Searches for Events in a specific Time for the currentUser
  ///@input: Start and Stop Timestamps
  Future<List<Event>> getEventsbyUserAndStartAndStopDate(
      Timestamp start, Timestamp stop) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid;
      QuerySnapshot qShot = await db
          .collectionGroup(collection)
          .where('teilnehmerIDs', arrayContains: uid)
          .where('startdate', isGreaterThanOrEqualTo: start)
          .where('enddate', isLessThanOrEqualTo: stop)
          .getDocuments();
      return snapShotToList(qShot);
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///Searches for Events until a specific Time for the currentUser
  ///@input: Stop Timestamps
  Future<List<Event>> getEventsbyUserAndStopDate(
      Timestamp start, Timestamp stop) async {
    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid;
      QuerySnapshot qShot = await db
          .collectionGroup(collection)
          .where('teilnehmerIDs', arrayContains: uid)
          .where('enddate', isLessThanOrEqualTo: stop)
          .getDocuments();
      return snapShotToList(qShot);
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///Searches for Events since a specific Time for the currentUser
  ///@input: Start Timestamps
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

  ///Searches for Events by specific tags
  ///@input: List<String> with specific Tags
  Future<List<Event>> getEventsbyTags(
      List<String>tagsList) async {
    try {

      QuerySnapshot qShot = await db
          .collectionGroup(collection)
          .where('tagsList', arrayContains: tagsList)
          .getDocuments();
      return snapShotToList(qShot);
    } on PlatformException catch (e) {
      exceptionhandling(e);
    }
  }

  ///This method gets all Events from database
  ///@return List of Events
  Future<List<Event>> getEvents() async {
    QuerySnapshot qShot = await db.collection(collection).getDocuments();
    return snapShotToList(qShot);
  }

  ///This method wraps a QuerySnapshot into a List of Events
  ///@input: QuerySnapshot who should wrapped into a List of Events
  List<Event> snapShotToList(QuerySnapshot qShot) {
    if (qShot != null) {
      return qShot.documents
          .map((doc) => Event(
              doc.data['name'],
              doc.data['startdate'],
              doc.data['enddate'],
              doc.data['details'],
              doc.data['city'],
              doc.data['private'],
              doc.data['teilnehmerIDs'],
              doc.data['tagsList'],
              doc.data['latitude'],
              doc.data['longitude']
      ))
          .toList();
    } else
      print('Keine passenden Events gefunden');
  }

  ///To Update Events, each event needs it own EventID
  ///@input: List of Events without ID,
  ///@input: QuerySnapshot with the refference ID's
  void addEventIdToObjects(List<Event> eventList, QuerySnapshot qShot) {
    for (int x = 0; x < eventList.length; x++) {
      eventList[x].eventID = qShot.documents[x].documentID;
    }
  }

  ///First Version of Exceptionhandling (not tested)
  ///@input: PlatformException to handle
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
}
