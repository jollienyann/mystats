import 'package:flutter/material.dart';
import 'package:sam/intro_screens/intro_page_one.dart';
import 'package:sam/intro_screens/intro_page_two.dart';
import 'package:sam/intro_screens/intro_page_three.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'home_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenSate createState() => _OnBoardingScreenSate();
}

class _OnBoardingScreenSate extends State<OnBoardingScreen> {
  PageController _controller = new PageController();

  //Check if on the last page
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => {onLastPage = (index == 2)});
            },
            children: [
              IntroPageOne(),
              IntroPageTwo(),
              IntroPageThree(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Skip
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text('skip')),
                SmoothPageIndicator(controller: _controller, count: 3),
                //Next
                onLastPage
                    ? GestureDetector(
                        onTap: () async{
                          //set shared preferences to not show intro again
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('showHome', true);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }));
                        },
                        child: Text('done'))
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(microseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text('next')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
