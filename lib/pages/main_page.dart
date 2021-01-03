import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_account.dart';
import './login_page.dart';

enum AuthStatus { NOT_DETERMINED, HANDLED }

class HomeController extends StatefulWidget {
  final AuthService authService;

  const HomeController({this.authService, Key key}) : super(key: key);

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
        authenticationStatus = AuthStatus.HANDLED;
      });
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (authenticationStatus == AuthStatus.HANDLED)
        ? LoginPage(authService: widget.authService)
        : _buildWaitingScreen();
  }
}
