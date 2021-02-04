import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctracer/models/event.dart';

class UserCT {
  bool isOrganizer, isPositive;
  String name, email;
  List<String> events;

  UserCT(isOrganizer, name, email, isPositive) {
    this.isOrganizer = isOrganizer;
    this.name = name;
    this.email = email;
    this.isPositive = isPositive;
    this.events = new List<String>();
  }

  UserCT.fromSnapshot(DocumentSnapshot snapshot)
      : this.isOrganizer = snapshot.data()['isOrganizer'],
        this.name = snapshot.data()['name'],
        this.isPositive = snapshot.data()['isPositive'],
        this.email = snapshot.data()['email'],
        this.events = snapshot.data()['events'].cast<String>();

  toJson() {
    return {
      "isOrganizer": this.isOrganizer,
      "isPositive": this.isPositive,
      "name": this.name,
      "email": this.email,
      "events": this.events
    };
  }
}
