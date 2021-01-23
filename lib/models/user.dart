import 'package:cloud_firestore/cloud_firestore.dart';

class UserCT {
  bool isOrganizer;
  String name, email;
  List<String> events;

  UserCT(isOrganizer, name, email) {
    this.isOrganizer = isOrganizer;
    this.name = name;
    this.email = email;
    this.events = new List<String>();
  }

  UserCT.fromSnapshot(DocumentSnapshot snapshot)
      : this.isOrganizer = snapshot.data()['isOrganizer'],
        this.name = snapshot.data()['name'],
        this.email = snapshot.data()['email'],
        this.events = snapshot.data()['events'];

  toJson() {
    return {
      "isOrganizer": this.isOrganizer,
      "name": this.name,
      "email": this.email,
      "events": this.events
    };
  }
}
