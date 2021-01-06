import 'package:ctracer/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../services/size_config.dart';
import './signup_page.dart';
import '../services/user_account.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';

class LoginPage extends StatelessWidget {
  final AuthService authService;
  LoginPage({this.authService});

  Route _transition() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SignUpPage(authService: authService),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  InkWell _buildForgotPassword() {
    return InkWell(
      child: Text(
        "Forgot Password?",
        style: TextStyle(color: Colors.grey, fontSize: SizeConfig.bH * 4),
      ),
      onTap: () {
        print("clicked");
      },
    );
  }

  Column _buildCreateOne(BuildContext context) {
    return Column(children: <Widget>[
      Text('Don\'t have an account?',
          style: TextStyle(fontSize: SizeConfig.bH * 4, color: Colors.grey)),
      SizedBox(height: SizeConfig.bV * .5),
      InkWell(
          child: new Text('Create One',
              style: TextStyle(
                  color: Color(0xff5dbcd2),
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.bH * 4)),
          onTap: () {
            Navigator.of(context).push(_transition());
          })
    ]);
  }

  InkWell _buildLoginButton() {
    return InkWell(
      onTap: () {
        print("clicked");
      },
      child: Container(
        height: SizeConfig.bV * 7,
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.bH * 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.bV * 3),
            color: Colors.orange[900]),
        child: Center(
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.bH * 6,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  InkWell _buildOfflineLoginButton() {
    return InkWell(
      onTap: null,
      child: Container(
        height: SizeConfig.bV * 7,
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.bH * 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.bV * 3),
            color: Colors.grey[600]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Connecting",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.bH * 6,
                  fontWeight: FontWeight.bold),
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildGradient() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.blue[900], Colors.blue[800], Colors.blue[400]]));
  }

  Padding _buildWelcomeText() {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.bH * 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: SizeConfig.bV * 6),
          ),
          SizedBox(
            height: SizeConfig.bV * 1,
          ),
          Text(
            "Welcome Back",
            style: TextStyle(color: Colors.white, fontSize: SizeConfig.bV * 3),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildLoginTemplate() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.bH * 15),
            topRight: Radius.circular(SizeConfig.bH * 15)));
  }

  Container _buildEmail() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.bV * 2),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: TextField(
        decoration: InputDecoration(
            hintText: "Email",
            hintStyle:
                TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
            border: InputBorder.none),
      ),
    );
  }

  Container _buildPassword() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.bV * 2),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: TextField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: "Password",
            hintStyle:
                TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
            border: InputBorder.none),
      ),
    );
  }

  Container _buildLoginInfo() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.bH * 2),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(36, 92, 196, .3),
                blurRadius: SizeConfig.bV * 2,
                offset: Offset(0, SizeConfig.bV * 2))
          ]),
      child: Column(
        children: <Widget>[_buildEmail(), _buildPassword()],
      ),
    );
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: _buildGradient(),
        child: Stack(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.bV * 5,
              ),
              _buildWelcomeText(),
              SizedBox(height: SizeConfig.bV * 6),
              Expanded(
                child: Container(
                  decoration: _buildLoginTemplate(),
                  child: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        primary: false,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.bH * 7),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: SizeConfig.bV * 7,
                              ),
                              _buildLoginInfo(),
                              SizedBox(
                                height: SizeConfig.bV * 5,
                              ),
                              ConnectivityWidgetWrapper(
                                  child: _buildLoginButton(),
                                  offlineWidget: _buildOfflineLoginButton()),
                              SizedBox(
                                height: SizeConfig.bV * 2,
                              ),
                              _buildForgotPassword(),
                              SizedBox(
                                height: SizeConfig.bV * 5,
                              ),
                              _buildCreateOne(context),
                              SizedBox(height: SizeConfig.bV * 3),
                              Image.asset("assets/images/ctracr_txt.png",
                                  fit: BoxFit.contain,
                                  height: SizeConfig.bV * 12,
                                  width: SizeConfig.bV * 90),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
