import 'package:flutter/material.dart';
import 'package:uggiso/widgets/IntroLandingScreen.dart';
import 'package:uggiso/widgets/SignUpScreen.dart';
import 'package:uggiso/widgets/splash.dart';

class AppRoutes {
  static const String initialRoute = '/initialRoute';

  static const String introLanding = '/introLanding';

  static const String signupScreen = '/signup_screen';

  static const String verifyOtp = '/verify_otp';

  static const String homeScreen = '/home_screen';

  static const String personalityScreen = '/personality_screen';

  static const String workTodayScreen = '/work_today_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initialRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case introLanding:
        return MaterialPageRoute(builder: (_) => const IntroLandingScreen());
      case signupScreen:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case verifyOtp:
        return MaterialPageRoute(builder: (_) => const IntroLandingScreen());
      default:
      // If there is no such named route in the switch statement, e.g. /randomRoute
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}