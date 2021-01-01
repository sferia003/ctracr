import 'package:flutter/material.dart';
import './pages/main_page.dart';
import './services/user_account.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTracer',
      home: new MainPage(account: new UserAccount())
      );
  }
  
}
