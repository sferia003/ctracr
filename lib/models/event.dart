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
        this.code = snapshot.data()["code"],
        this.name = snapshot.data()["name"],
        this.start = snapshot.data()["start"],
        this.end = snapshot.data()["end"],
        this.streetAddress = snapshot.data()["streetAddress"],
        this.cityStateZipAddress = snapshot.data()["cityStateZipAddress"],
        this.description = snapshot.data()["description"],
        this.participants = snapshot.data()["participants"];

  toJson() => {
        "eventId": this.eventId,
        "organizerId": this.organizerId,
        "name": this.name,
        "code": this.code,
        "start": this.start,
        "end": this.end,
        "streetAddress": this.streetAddress,
        "cityStateZipAddress": this.cityStateZipAddress,
        "description": this.description,
        "participants": this.participants
      };
}


class EventParticipant {
  DateTime checkInTime;
  DateTime checkOutTime;

  EventParticipant({this.checkInTime, this.checkOutTime});

  checkIn(DateTime checkInTime) {
    this.checkInTime = checkInTime;
  }

  checkOut(DateTime checkOutTime) {
    this.checkOutTime = checkOutTime;
  }

  EventParticipant.fromSnapshot(DocumentSnapshot snapshot)
      : this.checkInTime = snapshot.data()["checkInTime"],
        this.checkOutTime = snapshot.data()["checkOutTime"];

  toJson() =>
      {"checkInTime": this.checkInTime, "checkOutTime": this.checkOutTime};
}
