import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:univents/model/event.dart';

 class Crud {

  final db = Firestore.instance;
  Map map;
  String id;
  final String collection = 'events';

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

   Future<void> addData(event) async {
    //TODO überprüfung mit isLoggedIn sobald möglich
    Firestore.instance.collection(collection).add(event).catchError((e){print(e);});
  }

   getData() async{
   return await db.collection(collection) .getDocuments();
  }


  void testMethod(){
    Event event = Event('testname',DateTime.now(),DateTime(2021),'testDetails','Heilbronn',true,'12.0','45.12');
    saveEvent(event);
  }


}