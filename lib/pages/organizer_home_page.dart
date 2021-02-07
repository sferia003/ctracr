import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctracer/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

import 'dart:async';
import '../models/event.dart';
import 'new_event_page.dart';
import '../services/size_config.dart';
import '../services/firebase_service.dart';
import 'home_controller.dart';

class OrganizerHome extends StatefulWidget {
  final FirebaseService firebaseService;
  UserCT user;
  OrganizerHome(this.user, {this.firebaseService});

  @override
  _OrganizerHomeState createState() => _OrganizerHomeState();
}

class _OrganizerHomeState extends State<OrganizerHome> {
  String name;
  String email;
  String uuid;
  List<Event> events = new List<Event>();
  var streams = new List<StreamSubscription<DocumentSnapshot>>();

  @override
  void dispose() {
    streams.forEach((element) {
      element.cancel();
    });
    super.dispose();
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
    setState(() {});
  }

  DataTable displayData(List<EventParticipant> data) {
    return DataTable(columns: const <DataColumn>[
      DataColumn(
        label: Text(
          'Name',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Positive',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Email',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ], rows: <DataRow>[
      for (EventParticipant v in data)
        DataRow(cells: <DataCell>[
          DataCell(Text(v.name)),
          DataCell(Checkbox(
            value: v.positive,
            onChanged: (bool) {},
          )),
          DataCell(Text(v.email))
        ])
    ]);
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
        SizedBox(
          height: SizeConfig.bV * 5,
        ),
        if (event.participants.isNotEmpty)
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: displayData(event.participants),
              ))
      ],
    );
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

  Route _transitionE() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          OrganizerNewEvent(
        firebaseService: widget.firebaseService,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, -1.0);
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
            tooltip: 'Create an Event',
            onPressed: () {
              Navigator.of(context).push(_transitionE());
            },
          ),
        ],
      ),
    );
  }
}
