import 'package:ctracer/pages/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_service.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
        app: MaterialApp(
        title: 'CTracr',
        home: new HomeController(firebaseService: new FirebaseService()))
      );

  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp();
  runApp(MyApp());
}
