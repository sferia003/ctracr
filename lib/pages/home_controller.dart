import 'package:ctracer/pages/organizer_home_page.dart';
import 'package:ctracer/pages/participant_home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/user.dart';
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
  UserCT currentUser;
  void authStateListener() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
        if (firebaseUser != null) {
        widget.firebaseService.firestore
            .collection("users")
            .doc(widget.firebaseService.auth.currentUser.uid)
            .get()
            .then((value) {
              if (value.exists) {
          currentUser = UserCT.fromSnapshot(value);
          authenticationStatus = AuthStatus.HANDLED;
              }
        });
      } else {
        authenticationStatus = AuthStatus.NOT_DETERMINED;
      }
      });
    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    widget.firebaseService.signOut();
    authStateListener();
  }

  @override
  Widget build(BuildContext context) {
    return (authenticationStatus == AuthStatus.HANDLED)
        ? (currentUser.isOrganizer)
            ? OrganizerHome(currentUser, firebaseService: widget.firebaseService)
            : ParticipantHome(currentUser, firebaseService: widget.firebaseService)
        : LoginPage(firebaseService: widget.firebaseService);
  }
}
