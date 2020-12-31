import 'package:flutter/material.dart';
import './pages/sign_in_page.dart';
import './services/authentication.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTracer',
      home: new RootPage(auth: new Auth())
      );
  }
  
}
