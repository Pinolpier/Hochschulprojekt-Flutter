import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/model/event.dart';


 class Crud {
  final db = Firestore.instance;
  final String collection = 'events';
  Timestamp start;
  Timestamp stop;


  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else {
      return false;
    }
  }

  void saveEvent(Event event){
    Map<String, dynamic> toMap(){
      return {
        'name' : event.title,
        'details' : event.details,
        'city' : event.city,
        'startdate' : event.eventStartDate,
        'enddate' : event.eventEndDate,
        'latitude': event.lat,
        'longitude' : event.lng,
        'private' : event.privateEvent,
      };
    }
    addData(toMap());
  }

   Future <void> addData(event) async {
    //TODO überprüfung mit isLoggedIn sobald möglich
    db.collection(collection).add(event).catchError((e){print(e);});
  }

  Future<List<Event>> getEventswithFilter() async{
    QuerySnapshot qShot =
    await db.collectionGroup(collection).where('startdate',isGreaterThanOrEqualTo: start).where('enddate', isLessThanOrEqualTo: stop).getDocuments();

  }


  Future<List<Event>> getEvents() async {
    QuerySnapshot qShot =
    await db.collection(collection).getDocuments();
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
            )
    ).toList();
  }


  void testMethod() async{
    List<Event> eventList = await getEvents();
    print(eventList[0].title);
  }

}