import 'package:ctracer/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/size_config.dart';

class OrganizerNewEvent extends StatefulWidget {
  @override
  _OrganizerNewEventState createState() => _OrganizerNewEventState();
}

class _OrganizerNewEventState extends State<OrganizerNewEvent> {
  final PageController _pageController = PageController(initialPage: 0);
  DateTime selectedDate = DateTime.now();
  Event newEvent;
  int currentPage = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

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
          _buildStreet(),
          _buildAddressOther(),
          _buildDescription(),
        ],
      ),
    );
  }

  Container _buildExtraEventInfo() {
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
        children: <Widget>[_buildDatePicker()],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  RaisedButton _buildDatePicker() {
    return RaisedButton(
      padding: EdgeInsets.all(SizeConfig.bV * 1),
      onPressed: () => _selectDate(context), // Refer step 3
      child: Text(
        'Select date',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      color: Colors.greenAccent,
    );
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
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              hintText: "Event Name",
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
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
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
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
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
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              hintText: "Description",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          PageView(
            pageSnapping: true,
            controller: _pageController,
            physics: new NeverScrollableScrollPhysics(),
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Spacer(),
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
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Spacer(),
                    Container(
                      decoration: _buildLoginTemplate(),
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.bH * 7),
                        child: _buildExtraEventInfo(),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              Container(color: Colors.white)
            ],
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
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        _pageController.previousPage(
                            duration: Duration(seconds: 1), curve: Curves.ease);
                        currentPage--;
                      },
                      color: Colors.white,
                      iconSize: 6 * SizeConfig.bH,
                    ),
                  ),
                  Text(
                    "Create An Event",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        if (currentPage == 1 && newEvent != null)
                        _pageController.nextPage(
                            duration: Duration(seconds: 1), curve: Curves.ease);
                        currentPage++;
                      },
                      color: Colors.white,
                      iconSize: 6 * SizeConfig.bH,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
