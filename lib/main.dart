import 'package:flutter/material.dart';
import 'package:uggiso/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}); // Fix the constructor syntax

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: const CupertinoPageTransitionsBuilder(), // For Android
            TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(), // For iOS
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
