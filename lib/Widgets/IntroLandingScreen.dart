import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class IntroLandingScreen extends StatefulWidget {
  const IntroLandingScreen({super.key});

  @override
  State<IntroLandingScreen> createState() => _IntroLandingScreenState();
}

class _IntroLandingScreenState extends State<IntroLandingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void nextPage() {
    setState(() {
      if (_currentPage < 2) {
        _currentPage++;
        _pageController.jumpToPage(_currentPage);
      }
      else if (_currentPage == 2) {
        Navigator.pushReplacementNamed(context, AppRoutes.signupScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.signupScreen);
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      textAlign: TextAlign.center,
                      Strings.skip,
                      style: AppFonts.subHeader,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*0.6,
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Image.asset('assets/intro_3.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 48.0, bottom: 32.0),
                            child: Text(
                              Strings.have_fresh_food,
                              style: (AppFonts.subHeader)
                                  .copyWith(color: AppColors.headerColor),
                            ),
                          ),
                          Text(
                            Strings.experience_the_joy,
                            style: (AppFonts.title)
                                .copyWith(color: AppColors.headerColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Image.asset('assets/intro_1.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 48.0, bottom: 32.0),
                            child: Text(
                              Strings.ordering_made_easy,
                              style: (AppFonts.subHeader)
                                  .copyWith(color: AppColors.headerColor),
                            ),
                          ),
                          Text(
                            Strings.get_ready_to_explore,
                            style: (AppFonts.title)
                                .copyWith(color: AppColors.headerColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Image.asset('assets/intro_2.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 48.0, bottom: 32.0),
                            child: Text(
                              Strings.easy_secure_payment,
                              style: (AppFonts.subHeader)
                                  .copyWith(color: AppColors.headerColor),
                            ),
                          ),
                          Text(
                            Strings.payment_secure_simple,
                            style: (AppFonts.title)
                                .copyWith(color: AppColors.headerColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: DotsIndicator(
                  dotsCount: 3,
                  position: _currentPage.toDouble(),
                  decorator: const DotsDecorator(
                    color: AppColors.grey,
                    activeColor: AppColors.appPrimaryColor,
                  ),
                ),
              ),
              RoundedElevatedButton(
                  width: MediaQuery.of(context).size.width*0.4,
                  height: 40.0,
                  text: Strings.next,
                  onPressed: nextPage,
                  cornerRadius: 43.0,
                  buttonColor: AppColors.appPrimaryColor,
                  textStyle:
                  AppFonts.header.copyWith(color: AppColors.black)),
              SizedBox(height: MediaQuery.of(context).size.height*0.02,)

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
