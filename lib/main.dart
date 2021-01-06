import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/splash_screen.dart';
import './services/user_account.dart';
import 'package:device_preview/device_preview.dart';

class MyApp extends StatelessWidget {
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'CTracr',
  //     home: new SplashScreen(authService: new AuthService())
  //   );

  // }
Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder,
        title: 'CTracr',
        home: new SplashScreen(authService: new AuthService()));
  }

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => MyApp(), // Wrap your app
  ));
  // runApp(MyApp());
}