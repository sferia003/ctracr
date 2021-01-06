import 'package:ctracer/services/user_account.dart';
import 'package:flutter/material.dart';
import 'home_controller.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final AuthService authService;

  const SplashScreen({this.authService, Key key}) : super(key: key);

  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeController(
                  authService: widget.authService,
                ))));

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: new Center(child: Image.asset("assets/images/small_logo.png")),
        ),
      ),
    );
  }
}
