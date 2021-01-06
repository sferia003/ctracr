import 'package:ctracer/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../services/size_config.dart';
import './signup_page.dart';
import '../services/user_account.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

  RichText _buildCreateAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey),
        
        children: <TextSpan>[
          TextSpan(
            text: 'Don\'t have an account? ',
            style: TextStyle(fontSize: SizeConfig.bH * 4)
          ),
          TextSpan(
            text: 'Create One',
            style: TextStyle(
                color: Color(0xff5dbcd2), fontWeight: FontWeight.bold, fontSize: SizeConfig.bH * 4),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(_transition());
              },
          ),
        ],
      ),
    );
  }

  InkWell _buildLoginButton() {
    return InkWell(
      onTap: () {
        print("clicked");
      },
      child: Container(
        height: SizeConfig.bH * 5,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.orange[900]),
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

  Padding _buildWelcomeText() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.bH * 12),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Welcome Back",
            style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.bH * 6),
          ),
        ],
      ),
    );
  }

  Positioned _buildPersonLogo() {
    return Positioned(
        right: SizeConfig.bH * 4,
        top: SizeConfig.bH * 9,
        child: Image(
          image: AssetImage("assets/images/person.png"),
          height: SizeConfig.bV * 14,
          width: SizeConfig.bH * 28,
          fit: BoxFit.fill,
          color: Colors.white,
        ));
  }

  Positioned _buildPersonOutline() {
    return Positioned(
      right: SizeConfig.sH * -15,
      top: SizeConfig.sV * -5,
      child: ClipOval(
        child: Container(
          color: Colors.black.withOpacity(0.05),
          height: SizeConfig.bV * 30,
          width: SizeConfig.bH * 60,
        ),
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue[900],
          Colors.blue[800],
          Colors.blue[400]
        ])),
        child: Stack(children: <Widget>[
          _buildPersonOutline(),
          _buildPersonLogo(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.bV * 8,
              ),
              _buildWelcomeText(),
              SizedBox(height: SizeConfig.bV * 7),
              Expanded(
                child: Container(
                  decoration: _buildLoginTemplate(),
                  child: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        primary: false,
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.bH * 5),
                          child: Column(  
                            children: <Widget>[
                              SizedBox(
                                height: SizeConfig.bV * 6,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(SizeConfig.bH * 2),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(36, 92, 196, .3),
                                          blurRadius: 20,
                                          offset: Offset(0, SizeConfig.bV * 2))
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
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
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
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.bV * 5,
                              ),
                              _buildLoginButton(),
                              SizedBox(
                                height: SizeConfig.bV * 2,
                              ),
                              _buildForgotPassword(),
                              SizedBox(
                                height: SizeConfig.bV * 5,
                              ),
                              _buildCreateAccount(context),
                              SizedBox(height: SizeConfig.bH * 7),
                              Image.asset("assets/images/ctracr_txt.png"),
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
