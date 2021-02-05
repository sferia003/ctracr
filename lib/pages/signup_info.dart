import 'package:flutter/material.dart';
import '../services/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import '../services/firebase_service.dart';
import 'organizer_home_page.dart';
import 'participant_home_page.dart';
import '../models/user.dart';

class SignUpIntro extends StatefulWidget {
  final FirebaseService firebaseService;
  UserCT user;

  SignUpIntro(thisuser, {this.firebaseService});
  @override
  _SignUpIntroState createState() => _SignUpIntroState();
}

enum Status {
  submitting,
  normal,
  disabled,
}

class _SignUpIntroState extends State<SignUpIntro> {
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _nC = TextEditingController();
  bool _isAdministrator = false;
  Status _signUpStatus;

  @override
  void initState() {
    _signUpStatus = Status.disabled;
    super.initState();
    _nC.addListener(_textListener);
  }

  @override
  void dispose() {
    _nC.dispose();
    super.dispose();
  }

  _textListener() {
    if (_nC.text.isNotEmpty) {
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
        children: <Widget>[_buildName(), _buildSwitch()],
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

  Container _buildName() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          controller: _nC,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              hintText: "Full Name",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
  }

  Container _buildSwitch() {
    return Container(
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: new Row(
          children: [
            Spacer(),
            Text("Participant", style: TextStyle(fontSize: SizeConfig.bH * 4)),
            Spacer(),
            Switch(
              value: _isAdministrator,
              activeColor: Colors.blue,
              activeTrackColor: Colors.blue[200],
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.blue[200],
              onChanged: (value) {
                setState(() {
                  _isAdministrator = value;
                });
              },
            ),
            Spacer(),
            Text("Administrator",
                style: TextStyle(fontSize: SizeConfig.bH * 4)),
            Spacer()
          ],
        ));
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

  void _submit() async {
    bool isAdministrator = _isAdministrator;

    await widget.firebaseService.auth.currentUser.reload().then((value) {
      widget.firebaseService
          .signUpVerification(_isAdministrator, _nC.text)
            .then((_) {
          Navigator.of(context).push(_transitionHome(isAdministrator));
        }).catchError((e) {
        _displayError(
                "Please verify the email you signed up with before proceeding.");
      });
    });
  }

  Route _transitionHome(bool isAdministrator) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => isAdministrator
          ? OrganizerHome(widget.user, firebaseService: widget.firebaseService)
          : ParticipantHome(widget.user, 
              firebaseService: widget.firebaseService,
            ),
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          PageView(
            pageSnapping: true,
            controller: _pageController,
            physics: new NeverScrollableScrollPhysics(),
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Spacer(flex: 3),
                    Container(
                      decoration: _buildLoginTemplate(),
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.bH * 7),
                        child: _buildLoginInfo(),
                      ),
                    ),
                    Spacer(),
                    ConnectivityWidgetWrapper(
                        child: _buildSignupButton(),
                        offlineWidget: _buildOfflineSignupButton()),
                    SizedBox(
                      height: SizeConfig.bV * 2,
                    ),
                    Spacer(flex: 2)
                  ],
                ),
              ),
              Container(color: Colors.white),
              Container(color: Colors.white)
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset("assets/images/small_logo.png"),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0xff1055cc),
              constraints: BoxConstraints(
                  minHeight: 5 * SizeConfig.bV, maxHeight: 7 * SizeConfig.bV),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  // Expanded(
                  //   flex: 1,
                  //   child: IconButton(
                  //     icon: Icon(Icons.chevron_left),
                  //     onPressed: () {
                  //       _pageController.previousPage(
                  //           duration: Duration(seconds: 1), curve: Curves.ease);
                  //     },
                  //     color: Colors.white,
                  //     iconSize: 6 * SizeConfig.bH,
                  //   ),
                  // ),
                  Text(
                    "Get Started",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  // Expanded(
                  //   flex: 1,
                  //   child: IconButton(
                  //     icon: Icon(Icons.chevron_right),
                  //     onPressed: () {
                  //       _pageController.nextPage(
                  //           duration: Duration(seconds: 1), curve: Curves.ease);
                  //     },
                  //     color: Colors.white,
                  //     iconSize: 6 * SizeConfig.bH,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ]));
  }
}
