import 'package:ctracer/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/signup_info.dart';
import './services/user_account.dart';
import 'package:device_preview/device_preview.dart';
import "pages/participant_home_page.dart";
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
        app: MaterialApp(
        title: 'CTracr',
        home: new ParticipantHome(authService: new AuthService()) 
      ),
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
