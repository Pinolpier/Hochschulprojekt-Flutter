import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/model/event.dart';

/**
 * This class adds and gets data from the database
 */
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


  /**
   * This Method checks, if the user is logged in
   */
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else {
      return false;
    }
  }

  /**
   * This Method gets an Event and wrappes it into a map for the database.
   */
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
  

  /**
   * This Method writes the data into the database
   */
   Future <void> addData(event) async {
    if(isLoggedIn())
     db.collection(collection).add(eventToMap(event)).catchError((e){print(e);});
    else{
      print('User muss eingeloggt sein');
    }
  }

  /**
   * updates a event in a database
   */
  Future <void> updateData(Event event) async{
    if(event.eventID !=null)
    db.collection(collection).document(event.eventID).updateData(eventToMap(event));
  }

  /**
   * deletes a event in the database
   */
  Future<void> deleteEvent(Event event) async{
    if(event.eventID !=null){
      db.collection(collection).document(event.eventID).delete();
    }
  }

  /**
   * This Method gets a List of Events from the Database with different Filters
   */
  Future<List<Event>> getEventswithQueryFilter() async{
    if(start != null){
      if(stop != null){
        qShot =  await db.collectionGroup(collection).where('startdate',isGreaterThanOrEqualTo: start).where('enddate', isLessThanOrEqualTo: stop).getDocuments();
      }
      else{
        qShot =  await db.collectionGroup(collection).where('startdate',isGreaterThanOrEqualTo: start).getDocuments();
      }
      if(stop !=null){
        qShot =  await db.collectionGroup(collection).where('enddate', isLessThanOrEqualTo: stop).getDocuments();
      }
      if(uid !=null){
        qShot =  await db.collectionGroup(collection).where('teilnehmerIDs', arrayContains: uid).getDocuments();
      }
    }
    return snapShotToList(qShot);
  }

  /**
   * This method gets all Events from database
   */
   Future <List<Event>>getEvents() async {
    qShot =
    await db.collection(collection).getDocuments();
    return snapShotToList(qShot);
  }

  /**
   * This method wraps a QuerySnapshot into a List of Events
   */
    List<Event> snapShotToList(QuerySnapshot qShot){
    return qShot.documents.map(
            (doc) => Event(
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

  /**
   * To Update Events, each event needs it own EventID
   */
  void addEventIdToObjects(List<Event> eventList){
    for(int x=0;x<eventList.length;x++){
      eventList[x].eventID = qShot.documents[x].documentID;
    }
  }

  // just for testing the database service
  void testMethod() async{
    List<Event> eventList = await getEvents();
    print(eventList[0].title);
  }

  Timestamp get stop => _stop;
  set stop(Timestamp value) {
    _stop = value;
  }
 }