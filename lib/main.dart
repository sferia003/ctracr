import 'package:ctracer/pages/home_controller.dart';
import 'package:ctracer/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/new_event_page.dart';
import 'services/firebase_service.dart';
import 'package:device_preview/device_preview.dart';
import "pages/participant_home_page.dart";
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
  // Widget build(BuildContext context) {
  //   return ConnectivityAppWrapper(
  //     app: MaterialApp(
  //         locale: DevicePreview.locale(context), // Add the locale here
  //         builder: DevicePreview.appBuilder,
  //         title: 'CTracr',
  //         home: new SplashScreen(authService: new AuthService())),
  //   );
  // }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp();
  // runApp(DevicePreview(
  //   enabled: true,
  //   builder: (context) => MyApp(), // Wrap your app
  // ));
  runApp(MyApp());
}
