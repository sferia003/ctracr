import 'dart:convert';

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
  List<EventParticipant> participants;

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
    this.participants = new List<EventParticipant>();
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
        this.participants = snapshot.data()["participants"].map<EventParticipant>((e) => EventParticipant.fromJson(e)).toList();

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
        "participants": this.participants,
      };

  @override
  bool operator ==(o) => o is Event && this.eventId == o.eventId;
  int get hashCode => this.eventId.hashCode;
}

class EventParticipant {
  String name, email, uuid;
  bool positive;
  DateTime checkInTime;
  DateTime checkOutTime;
  bool contacted;

  EventParticipant(this.name, this.contacted, this.positive, this.email, this.uuid,
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

  EventParticipant.fromJson(Map<String, dynamic> json)
      : this.name = json["name"],
        this.positive = json["positive"],
        this.email = json["email"],
        this.checkInTime = json["checkInTime"]?.toDate(),
        this.contacted = json["contacted"],
        this.uuid = json["uuid"],
        this.checkOutTime = json["checkOutTime"]?.toDate();


  toJson() => {
        "name": this.name,
        "uuid": this.uuid,
        "positive": this.positive,
        "email": this.email,
        "checkInTime": this.checkInTime,
        "contacted": this.contacted,
        "checkOutTime": this.checkOutTime
      };

  @override
  bool operator ==(o) => o is EventParticipant && this.uuid == o.uuid;
  int get hashCode => this.uuid.hashCode;
}
