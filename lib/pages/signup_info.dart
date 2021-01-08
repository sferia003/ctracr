import 'package:flutter/material.dart';
import '../services/size_config.dart';

void main() => runApp(new SignUpIntro());

class SignUpIntro extends StatefulWidget {
  @override
  _SignUpIntroState createState() => _SignUpIntroState();
}

class _SignUpIntroState extends State<SignUpIntro> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
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
        children: <Widget>[_buildEmail(),],
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
        padding: EdgeInsets.all(SizeConfig.bV * 1),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey[200]))),
        child: TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              hintText: "Email",
              hintStyle:
                  TextStyle(fontSize: SizeConfig.bH * 5, color: Colors.grey),
              border: InputBorder.none),
        ));
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
                Spacer(flex: 5) 
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
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () {
                    _pageController.previousPage(
                        duration: Duration(seconds: 1), curve: Curves.ease);
                  },
                  color: Colors.white,
                  iconSize: 6 * SizeConfig.bH,
                ),
              ),
              Text(
                "Get Started",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    _pageController.nextPage(
                        duration: Duration(seconds: 1), curve: Curves.ease);
                  },
                  color: Colors.white,
                  iconSize: 6 * SizeConfig.bH,
                ),
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
