import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileBloc.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileEvent.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileState.dart';
import 'package:uggiso/Widgets/OrdersTab.dart';
import 'package:uggiso/Widgets/ui-kit/ProfileHeader.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String userName = '';
  String userNumber = '';
  ProfileBloc _profileBloc = ProfileBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _profileBloc,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (BuildContext context, state) async {
          if (state is onUserDataRemovedSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.signupScreen, // The new route
              (Route<dynamic> route) => false, // Condition to remove all routes
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.textFieldBg,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new, // iOS-style back arrow
                color: AppColors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            title: const Text(
              Strings.myProfile,
              style: AppFonts.appBarText,
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.appPrimaryGradient,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  userName: userName,
                  mail: userNumber,
                  address: '',
                  imageUrl: 'assets/ic_person.png',
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.rewards);
                    },
                    child: RoundedContainer(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/ic_coins.png',
                              height: 24,
                              width: 24,
                            ),
                            Gap(8),
                            Text(
                              "My Uggiso Points",
                              style: AppFonts.subHeader
                                  .copyWith(color: AppColors.appPrimaryColor),
                            )
                          ],
                        ),
                        color: AppColors.white,
                        borderColor: AppColors.textFieldBorderColor,
                        cornerRadius: 8),
                  ),
                ),
                ListView.builder(
                  itemCount: Strings.profileItemList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => goToNextPage(index),
                      child: ListContainerItem(
                          Strings.profileItemList[index]['image'],
                          Strings.profileItemList[index]['title'],
                          index),
                    );
                  },
                ),
                // RoundedContainer(width: MediaQuery.of(context).size.width,
                //   child: Text('Delete Account',style: AppFonts.title.copyWith(color: Colors.red,fontWeight: FontWeight.bold),),
                //   cornerRadius: 8,color: AppColors.white,
                //   borderColor: AppColors.textFieldBorderColor,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ListContainerItem(String icon, String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: RoundedContainer(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        cornerRadius: 8,
        borderColor: AppColors.textFieldBorderColor,
        color: AppColors.white,
        child: Row(
          children: [
            _buildIconForIndex(index, icon),
            const SizedBox(width: 16.0),
            _buildTextForIndex(index, text),
          ],
        ),
      ),
    );
  }

  Widget _buildIconForIndex(int index, String icon) {
    if (index == 3) return const Icon(Icons.rule); // Terms
    if (index == 4) return const Icon(Icons.privacy_tip); // Privacy
    if (index == 6 && Platform.isIOS) {
      return const Icon(Icons.delete_forever, color: Colors.red);
    }
    return Image.asset(icon, height: 24, width: 24);
  }

  Widget _buildTextForIndex(int index, String text) {
    if (index == 6 && Platform.isIOS) {
      return Text(
        Strings.delete_account,
        style: AppFonts.title.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Text(
      text,
      style: AppFonts.title.copyWith(color: AppColors.textColor),
    );
  }

  void goToNextPage(int index) async {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrdersTab(from: 'profile')),
        );
        break;

      case 1:
        Navigator.pushNamed(context, AppRoutes.getReferralHistory);
        break;

      case 2:
        Navigator.pushNamed(context, AppRoutes.bookmarkscreen);
        break;

      case 3:
        Navigator.pushNamed(context, AppRoutes.terms_and_conditions);
        break;

      case 4:
        Navigator.pushNamed(context, AppRoutes.privacy_policy);
        break;

      case 5:
        Navigator.pushNamed(context, AppRoutes.helpCenter);
        break;

      case 6:
      case 6:
        showSignOutDialog(context);
        break;

      default:
        break;
    }
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userNumber = prefs.getString('mobile_number') ?? '';
      userName = prefs.getString('user_name') ?? '';
    });
  }

  signoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_user_logged_in', false);
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 48, color: Color(0xFFFFB508)),
              const SizedBox(height: 16),
              Text(
                "Are you sure you want to sign out?",
                style: AppFonts.title.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  // Cancel Button with white background and gradient border
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.appPrimaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(1.5), // Border thickness
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Color(0xFFFFB508),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: AppFonts.title.copyWith(
                              color: Color(0xFFFFB508),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sign Out Button with full gradient background
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.appPrimaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          await signoutUser();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.signupScreen,
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: AppFonts.title.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced corner radius
          ),
          title: Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
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
                textStyle: AppFonts.title.copyWith(color: AppColors.textColor)),
            RoundedElevatedButton(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                text: 'Delete',
                onPressed: () {
                  deleteUserData();
                },
                cornerRadius: 8,
                buttonColor: Colors.red,
                textStyle: AppFonts.title.copyWith(color: AppColors.white))
          ],
        );
      },
    );
  }

  deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    _profileBloc.add(OnDeleteUserData(userId: userId));
  }
}
