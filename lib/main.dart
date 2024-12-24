import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_bloc.dart';
import 'package:uggiso/Bloc/VerifyOtpBloc/VerifyOtpBloc.dart';
import 'package:uggiso/app_routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

}

void requestIOSPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );
}


void showNotification(String title, String body, String redirectPath) async {
  initialiseNotificationSettings();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'Uggiso',
    'message',
    channelDescription: 'new message',
    importance: Importance.max,
    priority: Priority.high,
    groupKey: 'fcm',
  );
  const DarwinNotificationDetails iosNotificationDetails =
  DarwinNotificationDetails(
    threadIdentifier: 'Uggiso',
    presentSound: true,
    categoryIdentifier: 'fcm',
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
  if (title != 'null') {
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: redirectPath);
  }
}

initialiseNotificationSettings() {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) {},
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse: (payload) {
  //     GetStorage get = GetStorage();
  //     get.writeInMemory('redirect_path', payload);
  //   },
  // );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(Firebase.apps.isEmpty){
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

// Future<void> requestPermissions() async {
//   // Check and request SCHEDULE_EXACT_ALARM permission
//   if (await Permission.scheduleExactAlarm.isDenied) {
//     await Permission.scheduleExactAlarm.request();
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

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
