import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_account.dart';
import './authentication_page.dart';

class MainPage extends StatefulWidget {
  final UserAccount account;

  MainPage({this.account});

  @override
  State<StatefulWidget> createState() => new _MainPageState();
}

enum Status {
  NULL,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _MainPageState extends State<MainPage> {
  Status status = Status.NULL;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      User user = widget.account.auth.currentUser;

        if (user != null) {
          _userId = user?.uid;
        }
        status =
            user?.uid == null ? Status.NOT_LOGGED_IN : Status.LOGGED_IN;
      });
  }

  void _signedIn() {
   setState(() {
      User user = widget.account.auth.currentUser;
      _userId = user.uid;
      status = Status.LOGGED_IN;
   });
  }

  void _signedOut() {
    setState(() {
      _userId = "";
      status = Status.NOT_LOGGED_IN;
    });
  }

  Widget _loadingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.NULL:
      return _loadingScreen();
      break;
      case Status.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          account: widget.account,
          signedIn: _signedIn
        );
        break;
      case Status.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new LoginSignUpPage(
          account: widget.account,
          signedIn: _signedIn
        );
        } else return _loadingScreen();
        break;
      default:
        return _loadingScreen();
    }
  }
}