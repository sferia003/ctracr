import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import 'login_page.dart';

enum AuthStatus { NOT_DETERMINED, HANDLED }

class HomeController extends StatefulWidget {
  final FirebaseService firebaseService;

  const HomeController({this.firebaseService, Key key}) : super(key: key);

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  AuthStatus authenticationStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      setState(() {
        authenticationStatus = (firebaseUser != null) ? AuthStatus.HANDLED: AuthStatus.NOT_DETERMINED;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (authenticationStatus == AuthStatus.HANDLED)
        ? LoginPage(firebaseService: widget.firebaseService)
        : LoginPage(firebaseService: widget.firebaseService);
  }
}
