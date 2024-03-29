import 'package:uggiso/widgets/IntroLandingScreen.dart';
import 'package:uggiso/widgets/splash.dart';

class AppRoutes {
  static const String initialRoute = '/initialRoute';

  static const String introLanding = '/introLanding';

  static const String loginOrSignupScreen = '/login_or_signup_screen';

  static const String signupScreen = '/signup_screen';

  static const String loginScreen = '/login_screen';

  static const String forgotPasswordScreen = '/forgot_password_screen';

  static const String homeScreen = '/home_screen';

  static const String personalityScreen = '/personality_screen';

  static const String workTodayScreen = '/work_today_screen';

  static const String appNavigationScreen = '/app_navigation_screen';



  static get routes => {
    initialRoute: const SplashScreen(),
    introLanding : const IntroLandingScreen()
  };
}