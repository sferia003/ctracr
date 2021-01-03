import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './pages/main_page.dart';
import './services/user_account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} 


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CTracr',
      home: new HomeController(authService: new AuthService())
      );
  }
  
}
