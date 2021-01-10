import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:short_readable_id/short_readable_id.dart';

class Event {
  String eventId, code, organizerId, organization;
  DateTime start, end;
  List<EventParticipant> participants;

  Event(this.organizerId, this.start, this.end) {
    this.organizerId = organizerId;
    this.start = start;
    this.end = end;
  }

  Event.fromSnapshot(DocumentSnapshot snapshot)
      : this.eventId = snapshot.data()["eventId"],
        this.organizerId = snapshot.data()["organizerId"],
        this.code = snapshot.data()["code"],
        this.start = snapshot.data()["start"],
        this.end = snapshot.data()["end"],
        this.participants = snapshot.data()["participants"];

  toJson() {
    return {
      "eventId": this.eventId,
      "organizerId": this.organizerId,
      "code": this.code,
      "start": this.start,
      "end": this.end,
      "participants": this.participants.map((e) => e.toJson()).toList()
    };
  }
}

class EventParticipant {
  String userId;
  DateTime checkInTime;
  DateTime checkOutTime;

  EventParticipant(this.userId, {this.checkInTime, this.checkOutTime});

  checkIn(DateTime checkInTime) {
    this.checkInTime = checkInTime;
  }

  checkOut(DateTime checkOutTime) {
    this.checkOutTime = checkOutTime;
  }

  EventParticipant.fromSnapshot(DocumentSnapshot snapshot)
      : this.userId = snapshot.data()["userId"],
        this.checkInTime = snapshot.data()["checkInTime"],
        this.checkOutTime = snapshot.data()["checkOutTime"];

  toJson() {
    return {
      "userId": this.userId,
      "checkInTime": this.checkInTime,
      "checkOutTime": this.checkOutTime
    };
  }
}

class EventInfo {
  DateTime start, end;
  List<EventParticipant> participants;
}