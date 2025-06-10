import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_bloc.dart';
import 'package:uggiso/Bloc/VerifyOtpBloc/VerifyOtpBloc.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  await Firebase.initializeApp();
}

void requestIOSPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}

Future<void> initializeFirebase() async {
  if (Firebase.apps.isEmpty) {
    try {
      if (Platform.isAndroid) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyBaQeRktxRI4f-1nc8e2ysD_6SmjsC954g',
            appId: '1:692027802741:android:c7ca0866ba8264ca44e43c',
            messagingSenderId: '692027802741',
            projectId: 'my-uggiso-89fdd',
            storageBucket: 'my-uggiso-89fdd.appspot.com',
          ),
        );
      } else if (Platform.isIOS) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyApPM5HUmnG-4dNPjffhsXMGU15BRqWnxA',
            appId: '1:692027802741:ios:9fd21d335b28583544e43c',
            messagingSenderId: '692027802741',
            projectId: 'my-uggiso-89fdd',
            storageBucket: 'my-uggiso-89fdd.appspot.com',
          ),
        );
      }
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }
}

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (payload) {
      print("Notification opened with payload: $payload");
    },
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    initializeFirebase(),
    initializeNotifications(),
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [SystemUiOverlay.bottom],
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.appPrimaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SignUpBloc>(create: (context) => SignUpBloc()),
        BlocProvider<VerifyOtpBloc>(create: (context) => VerifyOtpBloc()),
      ],
      child: MyApp(),
    ),
  );
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

    // Firebase Messaging Handlers
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: ${message.messageId}');
      // Handle notification in foreground
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp: $message');
      // Handle background notification click
    });

    // Request permissions after splash
    Future.delayed(Duration(seconds: 2), () {
      if (Platform.isIOS) {
        requestIOSPermissions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uggiso',
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
