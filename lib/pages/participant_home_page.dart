import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  var streams = new List<StreamSubscription<DocumentSnapshot>>();
  UserCT currentUser;
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
                    _displayError("You may not join a group while you are positive");
                    
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
                              .doc(widget.firebaseService.auth.currentUser.uid)
                              .get())
                          .events;
                      if (userEvents.contains(value.data()["id"])) {
                        _displayError("You may not join a group you are already in");
                      } else {
                      userEvents.add(value.data()["id"]);
                      widget.firebaseService.firestore
                          .collection("users")
                          .doc(widget.firebaseService.auth.currentUser.uid)
                          .update({"events": userEvents});
                        Map<String, EventParticipant> currentParticipants = Event.fromSnapshot(await widget
                              .firebaseService.firestore
                              .collection("events")
                              .doc(value.data()["id"])
                              .get()).participants;
                        currentParticipants[widget.firebaseService.auth.currentUser.uid] = new EventParticipant(name, false, false, email);
                        widget.firebaseService.firestore
                          .collection("events")
                          .doc(value.data()["id"])
                          .update({"participants": {widget.firebaseService.auth.currentUser.uid: currentParticipants[widget.firebaseService.auth.currentUser.uid].toJson()}});
                      Navigator.of(context).pop();
                      }
                    } else {
                      Navigator.of(context).pop();
                       _displayError("Invalid code, please try again");
                    }
                  });
                }}),
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

  Future<void> _checkOut(eventUUID) {
    print("checked in");
    setState(() {});
  }

Future<void> _displayError(_errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_errorMessage),
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

  Future<void> _checkIn(eventUUID) {
    widget.firebaseService.firestore.collection("events").doc(eventUUID).set({"checkInTime": DateTime.now()});
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
    if (event.participants[uuid]?.checkInTime ?? true && !(DateTime.now().isAfter(event.end))) {
      return TextButton(
        child: const Text('Check-In'),
        onPressed: _isDisabled(event),
      );
    } else if (event.participants[uuid]?.checkInTime ?? true && !(DateTime.now().isAfter(event.end))) {
      return TextButton(
          child: const Text('Check-Out'),
          onPressed: () => _checkOut(event.eventId));
    } else {
      return Text("You May No Longer Attend This Event");
    }
  }

  @override
  void dispose() {
    streams.forEach((element) {
      element.cancel();
    });
    timer.cancel();
  }

  void addDataListener() async {
    streams.add(widget.firebaseService.firestore
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
    }));
    setState(() {
    });
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
    name = widget.user.name;
    email = widget.user.email;
    uuid = widget.firebaseService.auth.currentUser.uid;
    addDataListener();
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
      });
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
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
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
