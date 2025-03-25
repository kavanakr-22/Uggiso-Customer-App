import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Widgets/HomeTab.dart';
import 'package:uggiso/Widgets/OrdersTab.dart';
import 'package:uggiso/Widgets/ProfileTab.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/get_route_map.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class HomeLandingScreen extends StatefulWidget {
  const HomeLandingScreen({super.key});

  @override
  State<HomeLandingScreen> createState() => _HomeLandingScreenState();
}

class _HomeLandingScreenState extends State<HomeLandingScreen> {
  int _selectedIndex = 0;

  static const List _imagePaths = [
    'assets/ic_home.png',
    'assets/ic_orders.png',
    'assets/ic_person.png',
    ''
  ];

  final List<String> text = [
    Strings.home,
    Strings.orders,
    Strings.profile,
    Strings.by_route
  ];

  static List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    OrdersTab(),
    ProfileTab(),
    GetRouteMap()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.appPrimaryColor,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_imagePaths.length, (index) {
              return buildNavBarItem(index);
            }),
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(int index) {
    return InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        var userId = prefs.getString('userId') ?? '';
        if (userId == '') {
          requestSignInDialog(context);
        } else {
          _onItemTapped(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          index == 3?Icon(Icons.assistant_navigation,color: _selectedIndex == index ? AppColors.white : AppColors.bottomTabInactiveColor,):Image.asset(_imagePaths[index],height: 18,width: 18,
            color: _selectedIndex == index ? AppColors.white : AppColors.bottomTabInactiveColor,

          ),
          SizedBox(height: 4.0),
          Text(
            text[index],
            style: TextStyle(
              fontSize: 12,
              color: _selectedIndex == index
                  ? AppColors.white
                  : AppColors.bottomTabInactiveColor,
            ),
          ),
        ],
      ),
    );
  }

  void requestSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "You are not logged in. Please sign in to continue with creating your order.",
            style: AppFonts.title,
            textAlign: TextAlign.center,
          ),
          actions: [
            RoundedElevatedButton(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              text: 'Cancel',
              onPressed: () {
                Navigator.pop(context);
              },
              cornerRadius: 8,
              buttonColor: AppColors.grey,
              textStyle:
              AppFonts.title.copyWith(color: AppColors.appPrimaryColor),
            ),
            RoundedElevatedButton(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              text: 'Sign In',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.signupScreen,
                      (Route<dynamic> route) => false,
                );
              },
              cornerRadius: 8,
              buttonColor: AppColors.appPrimaryColor,
              textStyle: AppFonts.title.copyWith(color: AppColors.white),
            )
          ],
        );
      },
    );
  }
}
