import 'package:flutter/material.dart';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../services/size_config.dart';
import './login_page.dart';
import './signup_info.dart';
import '../services/firebase_service.dart';

class SignUpPage extends StatefulWidget {
  final FirebaseService firebaseService;

  SignUpPage({this.firebaseService});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

enum Status {
  submitting,
  normal,
  disabled,
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _eC = TextEditingController();
  final TextEditingController _pC = TextEditingController();
  final TextEditingController _cPC = TextEditingController();
  Status _signUpStatus;
  UserCT user;

  @override
  void initState() {
    _signUpStatus = Status.disabled;
    super.initState();
    _eC.addListener(_textListener);
    _pC.addListener(_textListener);
    _cPC.addListener(_textListener);
  }

  @override
  void dispose() {
    _eC.dispose();
    _pC.dispose();
    _cPC.dispose();
    super.dispose();
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
                  decoration: _buildSignupTemplate(),
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
                                  child: _buildSignupButton(),
                                  offlineWidget: _buildOfflineSignupButton()),
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

  Route _transitionLogin() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          LoginPage(firebaseService: widget.firebaseService),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, -1.0);
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

  Route _transitionSignUp() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SignUpIntro(user , firebaseService: widget.firebaseService),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
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

  Column _buildCreateOne(BuildContext context) {
    return Column(children: <Widget>[
      Text('Already have an account?',
          style: TextStyle(fontSize: SizeConfig.bH * 4, color: Colors.grey)),
      SizedBox(height: SizeConfig.bV * .5),
      InkWell(
          child: new Text('Log in',
              style: TextStyle(
                  color: Color(0xff5dbcd2),
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.bH * 4)),
          onTap: () {
            Navigator.of(context).push(_transitionLogin());
          })
    ]);
  }

  InkWell _buildSignupButton() {
    return InkWell(
      onTap: () {
        if (_signUpStatus == Status.normal) {
          setState(() {
            _signUpStatus = Status.submitting;
          });
          _submit();
          setState(() {
            _signUpStatus = Status.normal;
          });
        }
      },
      child: Container(
        height: SizeConfig.bV * 7,
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.bH * 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.bV * 3),
            color: (_signUpStatus == Status.disabled)
                ? Colors.grey[400]
                : Colors.orange[900]),
        child: (_signUpStatus == Status.submitting)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.bH * 6,
                        fontWeight: FontWeight.bold),
                  ),
                  CircularProgressIndicator()
                ],
              )
            : Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.bH * 6,
                      fontWeight: (_signUpStatus == Status.normal)
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
      ),
    );
  }

  InkWell _buildOfflineSignupButton() {
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
            "Sign Up",
            style: TextStyle(color: Colors.white, fontSize: SizeConfig.bV * 6),
          ),
          SizedBox(
            height: SizeConfig.bV * 1,
          ),
          Text(
            "Welcome",
            style: TextStyle(color: Colors.white, fontSize: SizeConfig.bV * 3),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildSignupTemplate() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.bH * 15),
            topRight: Radius.circular(SizeConfig.bH * 15)));
  }

  Container _buildEmail() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          controller: _eC,
          decoration: InputDecoration(
              hintText: "Email",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  Container _buildPassword() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.bV * 1),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        autofocus: false,
        controller: _pC,
        decoration: InputDecoration(
            hintText: "Password",
            hintStyle:
                TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
            border: InputBorder.none),
      ),
    );
  }

  Container _buildConfirmPassword() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.bV * 1),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200]))),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        autofocus: false,
        controller: _cPC,
        decoration: InputDecoration(
            hintText: "Confirm Password",
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
        children: <Widget>[
          _buildEmail(),
          _buildPassword(),
          _buildConfirmPassword()
        ],
      ),
    );
  }

  _textListener() {
    if (_eC.text.isNotEmpty && _pC.text.isNotEmpty && _cPC.text.isNotEmpty) {
      if (_signUpStatus == Status.disabled)
        setState(() {
          _signUpStatus = Status.normal;
        });
    } else {
      setState(() {
        _signUpStatus = Status.disabled;
      });
    }
  }

  void _submit() async {
    String _errorMessage = "";
    if (_pC.text != _cPC.text) {
      _displayError("Ensure that your passwords match.");
      return;
    }
    try {
      user = await widget.firebaseService.signUp(_eC.text, _pC.text).then((_) {
        if (widget.firebaseService.auth.currentUser != null) {
          widget.firebaseService.sendEmailVerification();
          Navigator.of(context).push(_transitionSignUp());
        }
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          _errorMessage = "Invalid email address.";
          break;
        case "email-already-in-use":
          _errorMessage = "This email is already registered, try logging in.";
          break;
        case "weak-password":
          _errorMessage =
              "Please ensure your password is more than six characters.";
          break;
        default:
          _errorMessage = "Error Code: ${e.code}";
      }
    }

    if (_errorMessage.isNotEmpty) _displayError(_errorMessage);
  }

  Future<void> _displayError(_errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_errorMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
