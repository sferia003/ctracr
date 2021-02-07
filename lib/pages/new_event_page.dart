import 'package:ctracer/models/event.dart';
import 'package:ctracer/services/firebase_service.dart';
import 'package:flutter/material.dart';
import '../services/size_config.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../models/user.dart';

class OrganizerNewEvent extends StatefulWidget {
  FirebaseService firebaseService;

  OrganizerNewEvent({this.firebaseService});
  @override
  _OrganizerNewEventState createState() => _OrganizerNewEventState();
}

class _OrganizerNewEventState extends State<OrganizerNewEvent> {
  final TextEditingController _oC = TextEditingController();
  final TextEditingController _orC = TextEditingController();
  final TextEditingController _orCC = TextEditingController();
  final TextEditingController _fD = TextEditingController();
  final TextEditingController _lD = TextEditingController();
  final TextEditingController _nC = TextEditingController();
  final TextEditingController _sC = TextEditingController();
  final TextEditingController _dC = TextEditingController();

  DateTime firstDate;
  DateTime endDate;
  Event newEvent;

  Container _buildEventInfo() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.bH * 2),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(36, 92, 196, .3),
                blurRadius: SizeConfig.bV * 2,
                offset: Offset(0, SizeConfig.bV * 2))
          ]),
      child: Column(
        children: <Widget>[
          _buildName(),
          _buildOrg(),
          _buildOrgCode(),
          _buildStreet(),
          _buildDatePicker(),
          _buildAddressOther(),
          _buildDescription(),
        ],
      ),
    );
  }

  Container _selectDate() {
    return Container(
      width: SizeConfig.bH * 40,
      child: DateTimePicker(
        type: DateTimePickerType.dateTime,
        initialValue: null,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        controller: _fD,
        dateLabelText: 'Start Time',
      ),
    );
  }

  Container _selectEndDate() {
    return Container(
      width: SizeConfig.bH * 40,
      child: DateTimePicker(
        type: DateTimePickerType.dateTime,
        initialValue: null,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        controller: _lD,
        dateLabelText: 'End Time',
      ),
    );
  }

  Container _buildDatePicker() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: Row(
          children: [_selectDate(), Spacer(), _selectEndDate()],
        ));
  }

  BoxDecoration _buildLoginTemplate() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.bH * 15),
            topRight: Radius.circular(SizeConfig.bH * 15)));
  }

  Container _buildName() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          controller: _nC,
          decoration: InputDecoration(
              hintText: "Event Name",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  Container _buildOrg() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          controller: _orC,
          decoration: InputDecoration(
              hintText: "Organization",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  Container _buildOrgCode() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          controller: _orCC,
          decoration: InputDecoration(
              hintText: "Organization Code",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  Container _buildStreet() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          controller: _sC,
          decoration: InputDecoration(
              hintText: "Street Name",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  Container _buildAddressOther() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          controller: _oC,
          decoration: InputDecoration(
              hintText: "City, State Zip",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  Container _buildDescription() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 3,
          autofocus: false,
          controller: _dC,
          decoration: InputDecoration(
              hintText: "Description",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  void _createEvent() async {
    newEvent = Event(
        widget.firebaseService.auth.currentUser.uid,
        DateTime.parse(_fD.text),
        DateTime.parse(_lD.text),
        _nC.text,
        _orC.text,
        _orCC.text,
        _sC.text,
        _dC.text,
        _oC.text);

    await widget.firebaseService.firestore
        .collection("events")
        .doc(newEvent.eventId)
        .set(newEvent.toJson());
    await widget.firebaseService.firestore
        .collection("event_ids")
        .doc(newEvent.code)
        .set({"id": newEvent.eventId});
    var userEvents = UserCT.fromSnapshot(await widget.firebaseService.firestore
            .collection("users")
            .doc(widget.firebaseService.auth.currentUser.uid)
            .get())
        .events;
    userEvents.add(newEvent.eventId);
    await widget.firebaseService.firestore
        .collection("users")
        .doc(widget.firebaseService.auth.currentUser.uid)
        .update({"events": userEvents});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Spacer(flex: 2),
                Container(
                  decoration: _buildLoginTemplate(),
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.bH * 7),
                    child: _buildEventInfo(),
                  ),
                ),
                Spacer()
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("assets/images/small_logo.png"),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0xff1055cc),
              constraints: BoxConstraints(
                  minHeight: 5 * SizeConfig.bV, maxHeight: 7 * SizeConfig.bV),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Text(
                    "Create An Event",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  FlatButton(
                      color: Color(0xff1166f7),
                      child: const Text(
                        "Create",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        print("sad");
                        _createEvent();
                      }),
                  Spacer()
                ],
              ),
            ),
          ),
        ]));
  }
}
