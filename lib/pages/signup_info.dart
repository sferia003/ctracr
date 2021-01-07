import 'package:flutter/material.dart';
import '../services/size_config.dart';

void main() => runApp(new SignUpIntro());

class SignUpIntro extends StatefulWidget {
  @override
  _SignUpIntroState createState() => _SignUpIntroState();
}

class _SignUpIntroState extends State<SignUpIntro> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        body: Stack(children: <Widget>[
      PageView(
        pageSnapping: true,
        controller: _pageController,
        physics: new NeverScrollableScrollPhysics(),
        children: [
          Container(color: Colors.indigo),
          Container(color: Colors.red),
          Container(color: Colors.amber)
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(0.0),
        child: Align(
          alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0xff1055cc),
            constraints: BoxConstraints(
                minHeight: 5 * SizeConfig.bV, maxHeight: 7  * SizeConfig.bV),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: () {
                      _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.ease);;
                    },
                    color: Colors.white,
                    iconSize: 6 * SizeConfig.bH,
                  ),
                ),
                Text(
                  "Get Started",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
                    },
                    color: Colors.white,
                    iconSize: 6 * SizeConfig.bH,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
