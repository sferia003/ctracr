import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:short_readable_id/short_readable_id.dart';
import 'package:uuid/uuid.dart';

class Event {
  String eventId,
      code,
      organizerId,
      organization,
      name,
      streetAddress,
      description,
      cityStateZipAddress;
  DateTime start, end;
  Map<String, EventParticipant> participants;

  Event(organizerId, start, end, name, organization, organizationCode,
      streetAddress, description, cityStateZipAddress) {
    this.eventId = Uuid().v4();
    this.code = "$organizationCode-${idGenerator.generate()}";
    this.name = name;
    this.organizerId = organizerId;
    this.organization = organization;
    this.start = start;
    this.end = end;
    this.streetAddress = streetAddress;
    this.cityStateZipAddress = cityStateZipAddress;
    this.description = description;
    this.participants = new Map<String, EventParticipant>();
  }

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.eventId = snapshot.data()["eventId"],
        this.organizerId = snapshot.data()["organizerId"],
        this.organization = snapshot.data()["organization"],
        this.code = snapshot.data()["code"],
        this.name = snapshot.data()["name"],
        this.start = snapshot.data()["start"].toDate(),
        this.end = snapshot.data()["end"].toDate(),
        this.streetAddress = snapshot.data()["streetAddress"],
        this.cityStateZipAddress = snapshot.data()["cityStateZipAddress"],
        this.description = snapshot.data()["description"],
        this.participants = new Map<String, EventParticipant>.from(snapshot.data()["participants"]);
          

  toJson() => {
        "eventId": this.eventId,
        "organizerId": this.organizerId,
        "organization": this.organization,
        "name": this.name,
        "code": this.code,
        "start": this.start,
        "end": this.end,
        "streetAddress": this.streetAddress,
        "cityStateZipAddress": this.cityStateZipAddress,
        "description": this.description,
        "participants": this.participants.cast<String, EventParticipant>()
      };

  @override
  bool operator ==(o) => o is Event && this.eventId == o.eventId;
  int get hashCode => this.eventId.hashCode;
}

class EventParticipant {
  String name, email;
  bool positive;
  DateTime checkInTime;
  DateTime checkOutTime;
  bool contacted;

  EventParticipant(this.name, this.contacted, this.positive, this.email,
      {this.checkInTime, this.checkOutTime});

  checkIn(DateTime checkInTime) {
    this.checkInTime = checkInTime;
  }

  checkOut(DateTime checkOutTime) {
    this.checkOutTime = checkOutTime;
  }

  contact() {
    this.contacted = true;
  }

  EventParticipant.fromSnapshot(DocumentSnapshot snapshot)
      : this.name = snapshot.data()["name"],
        this.positive = snapshot.data()["positive"],
        this.email = snapshot.data()["email"],
        this.checkInTime = snapshot.data()["checkInTime"],
        this.contacted = snapshot.data()["contacted"],
        this.checkOutTime = snapshot.data()["checkOutTime"];

  toJson() => {
        "name": this.name,
        "positive": this.positive,
        "email": this.email,
        "checkInTime": this.checkInTime,
        "contacted": this.contacted,
        "checkOutTime": this.checkOutTime
      };
}
