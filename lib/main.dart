import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_bloc.dart';
import 'package:uggiso/Bloc/VerifyOtpBloc/VerifyOtpBloc.dart';
import 'package:uggiso/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  // Handle the notification when the app is in the background or terminated
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCXfSKnMi_jvtwDIDT4AD9JxoKwJuzWkfQ',
          appId: '1:741537959124:android:b00dd25ac1fe00fdd2bf41',
          messagingSenderId: '741537959124',
          projectId: 'uggiso-469cc',
          storageBucket: 'uggiso-469cc.appspot.com',
        ),
      );
    } else if (Platform.isIOS) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyBhcdW0lc2uYT1Q14TVXtrTaUp8z8uVZNc',
          appId: '1:741537959124:ios:55e5e8bdc9372ebbd2bf41',
          messagingSenderId: '741537959124',
          projectId: 'uggiso-469cc',
          storageBucket: 'uggiso-469cc.appspot.com',
        ),
      );
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.bottom],
  );

  runApp(MultiBlocProvider(providers: [
    BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(),
    ),
    BlocProvider<VerifyOtpBloc>(
      create: (context) => VerifyOtpBloc(),
    ),
  ], child: MyApp()));
}

Future<void> requestPermissions() async {
  // Check and request SCHEDULE_EXACT_ALARM permission
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();

    // Set the background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: ${message.messageId}');
      // Handle the notification when the app is in the foreground
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: $message');
      // Handle the notification when the app is opened from the background
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
