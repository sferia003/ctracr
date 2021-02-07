import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

import 'dart:async';
import '../models/event.dart';
import '../models/user.dart';
import '../services/size_config.dart';
import '../services/firebase_service.dart';
import 'home_controller.dart';

class ParticipantHome extends StatefulWidget {
  final FirebaseService firebaseService;
  UserCT user;
  ParticipantHome(this.user, {this.firebaseService});

  @override
  _ParticipantHomeState createState() => _ParticipantHomeState();
}

class _ParticipantHomeState extends State<ParticipantHome> {
  final TextEditingController _cC = TextEditingController();
  var userStream;
  var streams = new List<StreamSubscription<DocumentSnapshot>>();
  String name;
  String email;
  String uuid;
  Timer timer;
  List<Event> events = new List<Event>();

  Future<void> _displayCodeInput() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Join An Event'),
          content: TextFormField(
            maxLines: 1,
            controller: _cC,
            autofocus: false,
            decoration: InputDecoration(
                hintText: "Code",
                hintStyle:
                    TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
                border: InputBorder.none),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Submit'),
                onPressed: () {
                  if (widget.user.isPositive) {
                    _display("Error",
                        "You may not join a group while you are positive");
                  } else {
                    widget.firebaseService.firestore
                        .collection("event_ids")
                        .doc(_cC.text)
                        .get()
                        .then((value) async {
                      if (value.exists) {
                        var userEvents = UserCT.fromSnapshot(await widget
                                .firebaseService.firestore
                                .collection("users")
                                .doc(
                                    widget.firebaseService.auth.currentUser.uid)
                                .get())
                            .events;
                        if (userEvents.contains(value.data()["id"])) {
                          _display("Error",
                              "You may not join a group you are already in");
                        } else {
                          userEvents.add(value.data()["id"]);
                          widget.firebaseService.firestore
                              .collection("users")
                              .doc(widget.firebaseService.auth.currentUser.uid)
                              .update({"events": userEvents});
                          List<EventParticipant> currentParticipants =
                              Event.fromSnapshot(await widget
                                      .firebaseService.firestore
                                      .collection("events")
                                      .doc(value.data()["id"])
                                      .get())
                                  .participants;
                          currentParticipants.add(new EventParticipant(
                              name, false, false, email, uuid));
                          widget.firebaseService.firestore
                              .collection("events")
                              .doc(value.data()["id"])
                              .update({
                            "participants": currentParticipants
                                .map((e) => e.toJson())
                                .toList()
                          });
                          Navigator.of(context).pop();
                        }
                      } else {
                        Navigator.of(context).pop();
                        _display("Error", "Invalid code, please try again");
                      }
                    });
                  }
                }),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkOut(eventUUID) async {
    List<EventParticipant> participants = Event.fromSnapshot(await widget
            .firebaseService.firestore
            .collection("events")
            .doc(eventUUID)
            .get())
        .participants;
    participants
        .firstWhere((element) => (element.uuid == uuid))
        .checkOut(DateTime.now());
    widget.firebaseService.firestore
        .collection("events")
        .doc(eventUUID)
        .update({"participants": participants.map((e) => e.toJson()).toList()});
    setState(() {});
  }

  Future<void> _display(_title, _message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkIn(eventUUID) async {
    List<EventParticipant> participants = Event.fromSnapshot(await widget
            .firebaseService.firestore
            .collection("events")
            .doc(eventUUID)
            .get())
        .participants;
    participants
        .firstWhere((element) => (element.uuid == uuid))
        .checkIn(DateTime.now());
    widget.firebaseService.firestore
        .collection("events")
        .doc(eventUUID)
        .update({"participants": participants.map((e) => e.toJson()).toList()});
    setState(() {});
  }

  Function _isDisabled(Event event) {
    if (DateTime.now()
        .isAfter(event.start.subtract(new Duration(minutes: 15)))) {
      return () {
        _checkIn(event.eventId);
      };
    } else {
      return null;
    }
  }

  Widget _checkEventStatus(Event event) {
    if (event.participants
                .firstWhere((element) => element.uuid == uuid,
                    orElse: () => null)
                ?.checkInTime ==
            null &&
        !(DateTime.now().isAfter(event.end))) {
      return Row(
        children: [
          TextButton(
            child: const Text("Leave Event"),
            onPressed: () => leaveEvent(event),
          ),
          Spacer(),
          TextButton(
            child: const Text('Check-In'),
            onPressed: _isDisabled(event),
          ),
        ],
      );
    } else if (event.participants
                .firstWhere((element) => element.uuid == uuid,
                    orElse: () => null)
                ?.checkOutTime ==
            null &&
        !(DateTime.now().isAfter(event.end))) {
      return TextButton(
          child: const Text('Check-Out'),
          onPressed: () => _checkOut(event.eventId));
    } else {
      return Text("You May No Longer Attend This Event");
    }
  }

  leaveEvent(Event event) async {
    var userEvents = UserCT.fromSnapshot(await widget.firebaseService.firestore
            .collection("users")
            .doc(widget.firebaseService.auth.currentUser.uid)
            .get())
        .events;
    userEvents.remove(event.eventId);
    widget.firebaseService.firestore
        .collection("users")
        .doc(uuid)
        .update({"events": userEvents});
    List<EventParticipant> currentParticipants = Event.fromSnapshot(await widget
            .firebaseService.firestore
            .collection("events")
            .doc(event.eventId)
            .get())
        .participants;
    currentParticipants
        .remove(new EventParticipant(name, false, false, email, uuid));
    widget.firebaseService.firestore
        .collection("events")
        .doc(event.eventId)
        .update({
      "participants": currentParticipants.map((e) => e.toJson()).toList()
    });

    streams.forEach((element) {
      element.onData((data) {
        if (Event.fromSnapshot(data).eventId == event.eventId) element.cancel();
      });
    });

    setState(() {
      events.remove(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    streams.forEach((element) {
      element.cancel();
    });
    timer.cancel();
  }

  void addDataListener() async {
    userStream = widget.firebaseService.firestore
        .collection("users")
        .doc(uuid)
        .snapshots()
        .listen((value) {
      widget.user = UserCT.fromSnapshot(value);
      name = widget.user.name;
      email = widget.user.email;
      uuid = widget.firebaseService.auth.currentUser.uid;
      var sEvents = widget.user.events;
      events = new List<Event>();
      setState(() {});
      sEvents.forEach((event) async {
        Event current;
        await widget.firebaseService.firestore
            .collection("events")
            .doc(event)
            .get()
            .then((value) {
          current = Event.fromSnapshot(value);
          streams.add(widget.firebaseService.firestore
              .collection("events")
              .doc(current.eventId)
              .snapshots()
              .listen((event) {
            setState(() {
              events.remove(current);
              addEvent(Event.fromSnapshot(event));
            });
          }));
        });
      });
    });

    setState(() {});
  }

  void addEvent(Event event) {
    events.add(event);
    events.sort((a, b) {
      var aStart = a.start;
      var bStart = b.start;
      return aStart.compareTo(bStart);
    });
  }

  @override
  void initState() {
    super.initState();
    name = widget.user.name;
    email = widget.user.email;
    uuid = widget.firebaseService.auth.currentUser.uid;
    addDataListener();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {});
    });
    Future.delayed(Duration.zero, () {
      if (widget.user.isNotified) {
        _display(
            "Important Message",
            "A user in a group you have attended has recently tested positive for COVID-19. " +
                "You are advised to get tested immediately and follow the guidelines on the CDC website(cdc.gov).");
        widget.firebaseService.firestore
            .collection("users")
            .doc(uuid)
            .update({"isNotified": false});
      }
    });
  }

  Route _transition() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          HomeController(firebaseService: widget.firebaseService),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  ExpansionTile _eventTile(Event event) {
    return ExpansionTile(
      title: Row(children: <Widget>[
        SizedBox(width: SizeConfig.bH * 3),
        Text(event.name,
            style: TextStyle(
                fontSize: SizeConfig.bH * 6, fontWeight: FontWeight.bold)),
        Spacer()
      ]),
      childrenPadding:
          EdgeInsets.only(left: SizeConfig.bH * 7, right: SizeConfig.bH * 3),
      children: [
        Row(
          children: [
            Icon(Icons.people),
            SizedBox(width: SizeConfig.bH * 3),
            Text(event.organization),
          ],
        ),
        SizedBox(height: SizeConfig.bV * 1),
        Row(
          children: [
            Icon(Icons.lock_open),
            SizedBox(width: SizeConfig.bH * 3),
            Text(event.code),
          ],
        ),
        SizedBox(height: SizeConfig.bV * 1),
        Row(
          children: [
            Icon(Icons.calendar_today),
            SizedBox(width: SizeConfig.bH * 3),
            Text(DateFormat.yMMMMd('en_US').format(event.start)),
          ],
        ),
        SizedBox(height: SizeConfig.bV * 1),
        Row(
          children: [
            Icon(Icons.schedule),
            SizedBox(width: SizeConfig.bH * 3),
            Text(
                '${DateFormat.jm().format(event.start)} - ${DateFormat.jm().format(event.end)}'),
          ],
        ),
        SizedBox(height: SizeConfig.bV * 1),
        Row(
          children: [
            Icon(Icons.location_on),
            SizedBox(width: SizeConfig.bH * 3),
            Text('${event.streetAddress}\n${event.cityStateZipAddress}'),
          ],
        ),
        SizedBox(
          height: SizeConfig.bV * 3,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(event.description),
        ),
        Align(
            alignment: Alignment.bottomRight, child: _checkEventStatus(event)),
      ],
    );
  }

  void reportPositive() {
    events.forEach((element) {
      EventParticipant positiveParticipant =
          element.participants.firstWhere((element) => element.uuid == uuid);
      widget.firebaseService.firestore
          .collection("events")
          .doc(element.eventId)
          .get()
          .then((value) {
        Event e = Event.fromSnapshot(value);
        var participants = e.participants;
        participants.forEach((element) {
          if (element.uuid == uuid) {
            element.positive = true;
          }
        });
        widget.firebaseService.firestore
            .collection("events")
            .doc(element.eventId)
            .update(
                {"participants": participants.map((e) => e.toJson()).toList()});
        e.participants.forEach((element) {
          if (element.uuid != uuid && !element.contacted) {
            widget.firebaseService.firestore
                .collection("users")
                .doc(element.uuid)
                .get()
                .then((usr) {
              if (element.checkInTime
                      .isBefore(positiveParticipant.checkOutTime) &&
                  positiveParticipant.checkInTime
                      .isBefore(element.checkInTime)) {
                widget.firebaseService.firestore
                    .collection("users")
                    .doc(element.uuid)
                    .update({"isNotified": true});
              }
            });
          }
        });
      });
    });

    _display(
        "Important Message",
        "You have notified the group event leaders with your positive test. " +
            "It is advised that you do not attend any other events until you have succesfully quaratined. "
                "Please check the guidelines on the CDC website(cdc.gov) for more information.");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: ConnectivityScreenWrapper(
        child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return _eventTile(events[index]);
            }),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(
                    top: SizeConfig.bV * 1,
                    left: SizeConfig.bH * 4,
                    right: SizeConfig.bH * 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.bV * 3),
                    Text(name,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.bH * 5)),
                    SizedBox(height: SizeConfig.bV * 1),
                    Text(email),
                  ],
                )),
            Divider(),
            ListTile(
              leading: Icon(Icons.warning, color: Colors.orange),
              title: Text('Report Positive COVID-19 Test'),
              onTap: () {
                reportPositive();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout'),
              onTap: () {
                widget.firebaseService.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  _transition(),
                  (route) => route.isFirst,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
            builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.black,
                onPressed: () => Scaffold.of(context).openDrawer())),
        title: Image.asset(
          "assets/images/ctracr_txt.png",
          height: SizeConfig.bV * 10,
          width: SizeConfig.bH * 40,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.library_add),
              color: Colors.black,
              tooltip: 'Add An Event',
              onPressed: _displayCodeInput),
        ],
      ),
    );
  }
}
