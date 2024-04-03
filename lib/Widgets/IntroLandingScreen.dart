import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:uggiso/base/common/ui/colors.dart';

class IntroLandingScreen extends StatefulWidget {
  const IntroLandingScreen({super.key});

  @override
  State<IntroLandingScreen> createState() => _IntroLandingScreenState();
}

class _IntroLandingScreenState extends State<IntroLandingScreen> {

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        actions: [const Text('Skip')],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: 200,height: 200,
                    child: Image.asset('assets/intro_1.png'),
                  ),
                  Text("wefkbwfknwl"),
                  Text("38239842934u02")
                ],
              ),
              Container(
                child: Image.asset('assets/intro_2.png',width: 200,height: 200,),
              ),
              Container(
                child: Image.asset('assets/intro_3.png',width: 200,height: 200,),
              ),
            ],
          ),
          Positioned(
            bottom: 70.0,
            left: 0,
            right: 0,
            child: Center(
              child: DotsIndicator(
                dotsCount: 3,
                position: _currentPage.toDouble(),
                decorator: const DotsDecorator(
                  color:  AppColors.grey,
                  activeColor: AppColors.appPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
