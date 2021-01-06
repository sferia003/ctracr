
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'home_controller.dart';
import '../services/user_account.dart';

class SignUpPage extends StatelessWidget {
  final AuthService authService;
  SignUpPage({this.authService});

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/people_graph.png"), fit: BoxFit.cover)),
        child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                scale: 1.3,
                image: AssetImage(
                'assets/images/people_graph.png'),
                alignment: Alignment.topRight,
              ),
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.blue[900],
            Colors.blue[800],
            Colors.blue[400]
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "SignUp",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(36, 92, 196, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey[200]))),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () {
                              print("clicked");
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.orange[900]),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              print("clicked");
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.grey),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Don\'t have an account? ',
                                ),
                                TextSpan(
                                  text: 'Create One',
                                  style: TextStyle(
                                      color: Color(0xff5dbcd2),
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pop(_transition());
                                    },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        Image.asset("assets/images/small_logo.png"),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

Route _transition() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeController(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
