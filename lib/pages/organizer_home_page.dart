import 'package:ctracer/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

import 'dart:async';
import '../models/event.dart';
import '../services/size_config.dart';
import '../services/firebase_service.dart';
import 'home_controller.dart';

class OrganizerHome extends StatefulWidget {
  final FirebaseService firebaseService;
  OrganizerHome({this.firebaseService});

  @override
  _OrganizerHomeState createState() => _OrganizerHomeState();
}

class _OrganizerHomeState extends State<OrganizerHome> {
  UserCT currentUser;
  String name;
  String email;
  String uuid;
  Timer timer;
  List<Event> events = new List<Event>();

  Widget _checkEventStatus(Event event) {
    if (event.participants[uuid]?.checkInTime ?? true) {
      return TextButton(
        child: const Text('Check-In'),
        onPressed: _isDisabled(event),
      );
    } else if (event.participants[uuid]?.checkInTime ?? true) {
      return TextButton(
          child: const Text('Check-Out'),
          onPressed: () => _checkOut(event.eventId));
    } else {
      return Text("You May No Longer Attend This Event");
    }
  }

  @override 
  void dispose() {
    timer.cancel();
    super.dispose();
  }

void getData() async {
    await widget.firebaseService.firestore
        .collection("users")
        .doc(widget.firebaseService.auth.currentUser.uid)
        .get()
        .then((value) {
      currentUser = UserCT.fromSnapshot(value);
    });
    name = currentUser.name;
    email = currentUser.email;
    uuid = widget.firebaseService.auth.currentUser.uid;
    currentUser.events.forEach((event) {
      widget.firebaseService.firestore
        .collection("events")
        .doc(event)
        .get().then((value) {
      events.add(Event.fromSnapshot(value));
    });
    });
    
    setState(() {});
  }

  void addDataListener() async {
    widget.firebaseService.firestore.collection("users").doc(uuid).snapshots().listen((value) {
      currentUser = UserCT.fromSnapshot(value);
     name = currentUser.name;
    email = currentUser.email;
    uuid = widget.firebaseService.auth.currentUser.uid;
    events = new List<Event>();
    currentUser.events.forEach((event) {
      widget.firebaseService.firestore
        .collection("events")
        .doc(event)
        .get().then((value) {
      events.add(Event.fromSnapshot(value));
    });
    });
  });
  }

  @override
  void initState() {
    getData();
    super.initState();
    events.add(new Event(
        "organizerId",
        DateTime.now(),
        DateTime.now().add(new Duration(minutes: 60)),
        "name",
        "organization",
        "NOM",
        "405 Bank",
        "description",
        "cityStateZipAddress"));
    timer = new Timer.periodic(
        new Duration(minutes: 1), (Timer t) => setState(() {}));
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
                  MaterialPageRoute(
                      builder: (context) => new HomeController(
                          firebaseService: widget.firebaseService)),
                  (route) => route.isFirst,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: Colors.red),
              title: Text('Close'),
              onTap: () {
                Navigator.pop(context);
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
            tooltip: 'Show Snackbar',
            onPressed: () {
              print("Asa");
            },
          ),
        ],
      ),
    );
  }

  _isDisabled(Event event) {}

  _checkOut(String eventId) {}
}
