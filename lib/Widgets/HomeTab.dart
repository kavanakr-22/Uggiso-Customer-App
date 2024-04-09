import 'package:flutter/material.dart';
import 'package:uggiso/Widgets/Shimmer/HomeScreen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
