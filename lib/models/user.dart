import 'package:cloud_firestore/cloud_firestore.dart';
class UserCT {
  bool isOrganizer, isPositive, isNotified;
  String name, email;
  List<String> events;

  UserCT(isOrganizer, name, email, isPositive, isNotified) {
    this.isOrganizer = isOrganizer;
    this.name = name;
    this.email = email;
    this.isPositive = isPositive;
    this.isNotified = isNotified;
    this.events = new List<String>();
  }

  UserCT.fromSnapshot(DocumentSnapshot snapshot)
      : this.isOrganizer = snapshot.data()['isOrganizer'],
        this.name = snapshot.data()['name'],
        this.isPositive = snapshot.data()['isPositive'],
        this.email = snapshot.data()['email'],
        this.isNotified = snapshot.data()['isNotified'],
        this.events = snapshot.data()['events'].cast<String>();

  toJson() {
    return {
      "isOrganizer": this.isOrganizer,
      "isPositive": this.isPositive,
      "isNotified": this.isNotified,
      "name": this.name,
      "email": this.email,
      "events": this.events
    };
  }
}
