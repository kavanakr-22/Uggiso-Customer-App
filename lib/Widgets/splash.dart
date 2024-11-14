import 'package:device_uuid/device_uuid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/LocationManager.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? deviceId = '';
  String? fcmToken = '';
  bool? _isUserLoggedIn = false;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    checkUserLoggedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColors.appPrimaryColor,
        child:
            Image.asset('assets/uggiso_splash.png', width: 200, height: 200));
  }

  void checkUserLoggedStatus() {
    getDeviceId();
  }

  void getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    deviceId = await DeviceUuid().getUUID();
    prefs.setString('device_id', deviceId!);
    print('this is device id : $deviceId');
    initFirebaseMessaging();
    setState(() {
      _isUserLoggedIn = prefs.getBool('is_user_logged_in');

    });
    if (await isLocationEnabled()) {
      print('this is islocation enable true');
      print('this is user logged in value : $_isUserLoggedIn');

      if(_isUserLoggedIn!){
        await getUserCurrentLocation(true);

      }
      else{
        await _showLocationFetchingDialog();
      }


    } else {
      print('this is islocation enable false');
      await _showLocationFetchingDialog();
    }

  }

  void initFirebaseMessaging() async {
    final prefs = await SharedPreferences.getInstance();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token: $token");
      prefs.setString('fcm_token', token!);

      setState(() {
        fcmToken = token;
      });
    });
  }

   _showLocationFetchingDialog() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {});
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Column(
              children: [
                Icon(Icons.location_on,
                    color: AppColors.appPrimaryColor, size: 40),
                Gap(4),
                Text(Strings.location_alert_title,
                    style: AppFonts.subHeader,textAlign: TextAlign.center,),
              ],
            ),
            content: Text(
              Strings.location_permission_request,
              style: AppFonts.smallText,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Get.back(); // Close the dialog
                  // getLatLong(); // Retry fetching location
                  getUserCurrentLocation(false);
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Deny',
                  style:
                      AppFonts.title.copyWith(color: Colors.red),
                ),
              ),

              TextButton(
                onPressed: () {
                  // Get.back(); // Close the dialog
                  // getLatLong(); // Retry fetching location
                  getUserCurrentLocation(true);
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Allow',
                  style:
                  AppFonts.title.copyWith(color: AppColors.alertColor),
                ),
              ),
            ],
          );
        });
  }

  getUserCurrentLocation(bool isGetLocation) async {

    final prefs = await SharedPreferences.getInstance();

    if(isGetLocation){
      LocationInfo _location = await LocationManager.getCurrentPosition();
      print('this is user lat lng : ${_location.longitude} and ${_location.latitude}');
      prefs.setDouble('user_longitude', _location.longitude);
      prefs.setDouble('user_latitude', _location.latitude);
    }
    else{
      prefs.setBool('userLocationEnabled', false);
    }

    if(_isUserLoggedIn==null || _isUserLoggedIn ==false){

      Navigator.popAndPushNamed(context, AppRoutes.introLanding);

    }
    else{
      Navigator.popAndPushNamed(context, AppRoutes.homeScreen);

    }

  }


}
