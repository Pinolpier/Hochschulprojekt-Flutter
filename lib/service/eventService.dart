import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:univents/model/event.dart';


 ///This class adds and gets data from the database
 class eventService {
  final db = Firestore.instance;
  final String collection = 'events';
  Timestamp _start;
  Timestamp _stop;
  QuerySnapshot qShot;
  String uid;

  Timestamp get start => _start;
  set start(Timestamp value) {
    _start = value;
  }



  ///This Method checks, if the user is logged in
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else {
      return false;
    }
  }

   ///This Method gets an Event and wrappes it into a map for the database.
    Map<String, dynamic> eventToMap(Event event){
      return {
        'name' : event.title,
        'details' : event.details,
        'city' : event.city,
        'startdate' : event.eventStartDate,
        'enddate' : event.eventEndDate,
        'latitude': event.lat,
        'longitude' : event.lng,
        'private' : event.privateEvent,
        'teilnehmerIDs' : event.teilnehmerIDs,
      };
    }
  
    ///This Method writes the data into the database
   Future <void> addData(Event event) async {
    if(isLoggedIn()) {
      try {
        db.collection(collection).add(eventToMap(event)).catchError((e) {
          print(e);
        });
      }
      on PlatformException catch(e){
        exceptionhandling(e);
      }
    } else{
      print('User muss eingeloggt sein');
    }
  }


  /// updates a event in a database
  Future <void> updateData(Event event) async{
    try {
      if (event.eventID != null)
        db.collection(collection).document(event.eventID).updateData(
            eventToMap(event));
    }
    on PlatformException catch(e){
      exceptionhandling(e);
    }
  }

   ///deletes a event in the database
  Future<void> deleteEvent(Event event) async{
    if(event.eventID !=null){
      try {
        db.collection(collection).document(event.eventID).delete();
      }
      on PlatformException catch(e){
        exceptionhandling(e);
      }
    }
  }

   ///This Method gets a List of Events from the Database with different Filters
   Future<List<Event>> getEventswithQueryFilter() async{
    try {
      if (start != null) {
        if (stop != null) {
          qShot = await db.collectionGroup(collection).where(
              'startdate', isGreaterThanOrEqualTo: start).where(
              'enddate', isLessThanOrEqualTo: stop).getDocuments();
        }
        else {
          qShot = await db.collectionGroup(collection).where(
              'startdate', isGreaterThanOrEqualTo: start).getDocuments();
        }
        if (stop != null) {
          qShot = await db.collectionGroup(collection).where(
              'enddate', isLessThanOrEqualTo: stop).getDocuments();
        }
        if (uid != null) {
          qShot = await db.collectionGroup(collection).where(
              'teilnehmerIDs', arrayContains: uid).getDocuments();
        }
      }
      List<Event> list = snapShotToList(qShot);
      if (list != null) {
        if (list.length > 0)
          return list;
        else
          print('Keine Events gefunden');
      }
    }
    on PlatformException catch(e){
      exceptionhandling(e);
    }
  }

   ///This method gets all Events from database
   Future <List<Event>>getEvents() async {
    qShot =
    await db.collection(collection).getDocuments();
    return snapShotToList(qShot);
  }


   ///This method wraps a QuerySnapshot into a List of Events
    List<Event> snapShotToList(QuerySnapshot qShot){
    if(qShot != null) {
      return qShot.documents.map(
              (doc) =>
              Event(
                  doc.data['name'],
                  doc.data['startdate'],
                  doc.data['enddate'],
                  doc.data['details'],
                  doc.data['city'],
                  doc.data['private'],
                  doc.data['latitude'],
                  doc.data['longitude'],
                  doc.data['teilnehmerIDs']
              )
      ).toList();
    }
    else return null;
  }

  ///To Update Events, each event needs it own EventID
  void addEventIdToObjects(List<Event> eventList){
    for(int x=0;x<eventList.length;x++){
      eventList[x].eventID = qShot.documents[x].documentID;
    }
  }

  Timestamp get stop => _stop;
  set stop(Timestamp value) {
    _stop = value;
  }

  ///First Version of Exceptionhandling (not tested)
  void exceptionhandling(PlatformException e){
    switch(e.code){
      case ('ABORTED'):
        print('The operation was aborted, typically due to a concurrency issue like transaction aborts, etc.');
        break;
      case('ALREADY_EXISTS'):
        print('Some document that we attempted to create already exists.');
        break;
      case('CANCELLED'):
        print('The operation was cancelled (typically by the caller).');
        break;
      case('DATA_LOSS'):
        print('Unrecoverable data loss or corruption.');
        break;
      case('DEADLINE_EXCEEDED'):
        print('Deadline expired before operation could complete. For operations that change the state of the system, this error may be returned even if the operation has completed successfully. For example, a successful response from a server could have been delayed long enough for the deadline to expire.');
        break;
      case('FAILED_PRECONDITION'):
        print('Operation was rejected because the system is not in a state required for the operations execution.');
        break;
      case('INTERNAL'):
        print('Internal errors. Means some invariants expected by underlying system has been broken. If you see one of these errors, something is very broken.');
        break;
      case('INVALID_ARGUMENT'):
        print('Client specified an invalid argument. Note that this differs from FAILED_PRECONDITION. INVALID_ARGUMENT indicates arguments that are problematic regardless of the state of the system (e.g., an invalid field name).');
        break;
      case('NOT_FOUND'):
        print('Some requested document was not found.');
        break;
      case('OK'):
        //The operation completed successfully. FirebaseFirestoreException will never have a status of OK.
        print('The operation completed successfully.');
        break;
      case('OUT_OF_RANGE'):
        print('Operation was attempted past the valid range.');
        break;
      case('PERMISSION_DENIED'):
        print('The caller does not have permission to execute the specified operation.');
        break;
      case('RESOURCE_EXHAUSTED'):
        print('Some resource has been exhausted, perhaps a per-user quota, or perhaps the entire file system is out of space.');
        break;
      case('UNAUTHENTICATED'):
        print('The request does not have valid authentication credentials for the operation.');
        break;
      case('UNAVAILABLE'):
        print('The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.');
        break;
      case('UNIMPLEMENTED'):
        print('Operation is not implemented or not supported/enabled.');
        break;
      case('UNKNOWN'):
        print('Unknown error or an error from a different error domain.');
        break;
    }
  }
 }