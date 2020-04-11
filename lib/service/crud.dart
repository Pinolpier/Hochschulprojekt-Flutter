import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class crud {

  final db = Firestore.instance;
  final formkey= GlobalKey<FormState>();

  void createData()async{
    if(formkey.currentState.validate()){
      formkey.currentState.save();

    }
  }
}