import 'package:flutter/material.dart';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/size_config.dart';
import './signup_page.dart';
import '../services/user_account.dart';

class ParticipantHome extends StatefulWidget {
  final AuthService authService;
  ParticipantHome({this.authService});

  @override
  _ParticipantHomeState createState() => _ParticipantHomeState();
}

class _ParticipantHomeState extends State<ParticipantHome> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(SizeConfig.bH * 3, SizeConfig.bV * 3, SizeConfig.bH * 3, SizeConfig.bV * 3),
              child:ExpansionPanelList(
          children: [
            ExpansionPanel(
              body: Container(
              margin: EdgeInsets.fromLTRB(SizeConfig.bH * 3, SizeConfig.bV * 3, SizeConfig.bH * 3, SizeConfig.bV * 3),
              child: Column(children: [
                Row(
                children: [
                   Icon(Icons.people),
                  SizedBox(width: SizeConfig.bH * 3),
                  Text('Saint Thomas Aquinas'),
                ],
              ),
              SizedBox(height: SizeConfig.bV * 1 ),
                Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: SizeConfig.bH * 3),
                  Text('January 6, 2012'),
                ],
              ),
              SizedBox(height: SizeConfig.bV * 1 ),
                Row(
                children: [
                  Icon(Icons.schedule),
                  SizedBox(width: SizeConfig.bH * 3),
                  Text('7:30am - 1:30pm'),
                ],
              ),
              SizedBox(height: SizeConfig.bV * 1),
              Row(
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: SizeConfig.bH * 3),
                  Text('405 Bucknell Street \nNaperville, IL 60565'),
                ],
              ),
              SizedBox(height: SizeConfig.bV * 3,),
              Text("A Service asd asd asd asd asd asssssssd as dasd asd asd asd as das"),
            
            Align(
              alignment: Alignment.bottomRight,
                          child: TextButton(
                child: const Text('Check-In'),
                onPressed: null,
              ),
            ),
              ],),
            ),
            isExpanded: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Row(
            children: <Widget>[
            SizedBox(width: SizeConfig.bH * 3),
            Text('Church Mass', style: TextStyle(fontSize: SizeConfig.bH * 6,fontWeight: FontWeight.bold)),
            Spacer(),
           
          ]);
        })]),
      //     Card(
      //       child: Column(
      //     children: <Widget>[
      //       Container(
      //         margin: EdgeInsets.fromLTRB(SizeConfig.bH * 3, SizeConfig.bV * 3, SizeConfig.bH * 3, SizeConfig.bV * 3),
      //         child: Column(children: <Widget>[
      //           Align(alignment: Alignment.topLeft,
      //           child: Text('Church Mass', style: TextStyle(fontSize: SizeConfig.bH * 6,fontWeight: FontWeight.bold))),
      //           SizedBox(height: SizeConfig.bV * 1 ),
      //           Row(
      //           children: [
      //              Icon(Icons.people),
      //             SizedBox(width: SizeConfig.bH * 3),
      //             Text('Saint Thomas Aquinas'),
      //           ],
      //         ),
      //         SizedBox(height: SizeConfig.bV * 1 ),
      //           Row(
      //           children: [
      //             Icon(Icons.calendar_today),
      //             SizedBox(width: SizeConfig.bH * 3),
      //             Text('January 6, 2012'),
      //           ],
      //         ),
      //         SizedBox(height: SizeConfig.bV * 1 ),
      //           Row(
      //           children: [
      //             Icon(Icons.schedule),
      //             SizedBox(width: SizeConfig.bH * 3),
      //             Text('7:30am - 1:30pm'),
      //           ],
      //         ),
      //         SizedBox(height: SizeConfig.bV * 1),
      //         Row(
      //           children: [
      //             Icon(Icons.location_on),
      //             SizedBox(width: SizeConfig.bH * 3),
      //             Text('405 Bucknell Street \nNaperville, IL 60565'),
      //           ],
      //         ),
      //         SizedBox(height: SizeConfig.bV * 3,),
      //         Text("A Service asd asd asd asd asd asssssssd as dasd asd asd asd as das"),
            
      //       Align(
      //         alignment: Alignment.bottomRight,
      //                     child: TextButton(
      //           child: const Text('Check-In'),
      //           onPressed: null,
      //         ),
      //       ),
      //         ],),
      //       )
      //     ],
      //   ),
      // ),
              ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
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
}
