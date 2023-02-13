import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps/screens/auth/login_screen.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoarding {
  String image;
  String title;
  String description;

  OnBoarding(
      {required this.image, required this.title, required this.description});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var onBorderController = PageController();
  bool isLast = false;
  List<OnBoarding> pages = [
    OnBoarding(
        image: 'assets/images/onboarding1.png',
        title: 'Up to date',
        description:
            'track employees locations and sales processes, keep in touch with them'),
    OnBoarding(
        image: 'assets/images/onboarding2.png',
        title: 'Productivity',
        description:
            'decrease mistakes, increase job satisfaction and performance'),
    OnBoarding(
        image: 'assets/images/onboarding3.png',
        title: 'Team work',
        description:
            'enable representatives to more easily become productive members of the company'),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setBool('isOnBoardingShowed', true);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text(
                    'SKIP -> ',
                    style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .75,
                child: PageIndicatorContainer(
                  child: PageView.builder(
                    itemCount: pages.length,
                    physics: BouncingScrollPhysics(),
                    controller: onBorderController,
                    onPageChanged: (index) {
                      if (index == pages.length - 1) {
                        setState(() {
                          isLast = true;
                        });
                      } else {
                        setState(() {
                          isLast = false;
                        });
                      }
                    },
                    itemBuilder: (context, index) {
                      return onBoardingPage(pages[index]);
                    },
                  ),
                  align: IndicatorAlign.bottom,
                  length: pages.length,
                  indicatorSpace: 20.0,
                  padding: const EdgeInsets.all(10),
                  indicatorColor: Colors.grey,
                  indicatorSelectorColor: Colors.blue,
                  shape: IndicatorShape.circle(size: 15),
                  // shape: IndicatorShape.roundRectangleShape(size: Size.square(12),cornerSize: Size.square(3)),
                  // shape: IndicatorShape.oval(size: Size(12, 8)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 30),
                child: FloatingActionButton(
                  onPressed: () async {
                    if (isLast) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isOnBoardingShowed', true);

                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    } else {
                      onBorderController.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget onBoardingPage(OnBoarding page) {
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Image(
          image: AssetImage(page.image),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          page.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            page.description,
            style:
                TextStyle(fontSize: 20, height: 1.3, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
