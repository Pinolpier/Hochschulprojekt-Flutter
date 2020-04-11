import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

 class Crud {

  final db = Firestore.instance;
  Map map;
  String id;
  String name;

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    }
    else {
      return false;
    }
  }

   Future<void> addData(event) async {
    //TODO überprüfung mit isLoggedIn sobald möglich
    Firestore.instance.collection('events').add(event).catchError((e){print(e);});
  }


  void readData() async{

  }


}