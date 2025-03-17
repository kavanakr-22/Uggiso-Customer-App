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
      create: (context)=>_profileBloc,
      child: BlocListener<ProfileBloc,ProfileState>(
        listener: (BuildContext context, state)async{
          if(state is onUserDataRemovedSuccess){

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
            leading: Container(),
            backgroundColor: AppColors.appPrimaryColor,
            title: const Text(
              Strings.myProfile,
              style: AppFonts.appBarText,
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

  Widget ListContainerItem(String icon, String text, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: RoundedContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              children: [
                index == 2
                    ? Icon(Icons.rule)
                    : index == 3
                        ? Icon(Icons.privacy_tip)
                        : index==5?Platform.isAndroid?Image.asset(
                  icon,
                  height: 24,
                  width: 24,
                ):Icon(Icons.delete_forever,color: Colors.red,):Image.asset(
                            icon,
                            height: 24,
                            width: 24,
                          ),
                SizedBox(
                  width: 16.0,
                ),
                index==5?Platform.isIOS?Text(
                  Strings.delete_account,
                  style: AppFonts.title.copyWith(color: Colors.red,fontWeight: FontWeight.bold),
                ):Text(
                  text,
                  style: AppFonts.title.copyWith(color: AppColors.textColor),
                ):Text(
                  text,
                  style: AppFonts.title.copyWith(color: AppColors.textColor),
                )
              ],
            ),
            color: AppColors.white,
            borderColor: AppColors.textFieldBorderColor,
            cornerRadius: 8),
      );

  goToNextPage(int index) async {
    switch (index) {
      case 0:
        return Navigator.push(context,MaterialPageRoute(builder: (context)=>OrdersTab(from: 'profile')));


      case 1:
        return Navigator.pushNamed(context, AppRoutes.getReferralHistory);

      case 2:
        return Navigator.pushNamed(context, AppRoutes.terms_and_conditions);

      case 3:
        return Navigator.pushNamed(context, AppRoutes.privacy_policy);

      case 4:
        return Navigator.pushNamed(context, AppRoutes.helpCenter);

      case 5:

        if(Platform.isAndroid){
          await signoutUser();
          return Navigator.popAndPushNamed(context, AppRoutes.signupScreen);
        }
        else{
          return showDeleteAccountDialog(context);
        }
      // case 6:
      //   return Con

      default:
        return 'Unknown';
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
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced corner radius
          ),
          title: Text("Are you sure you want to delete your account? This action cannot be undone.",style: AppFonts.title,
            textAlign: TextAlign.center,),
          actions: [
            RoundedElevatedButton(width: MediaQuery.of(context).size.width*0.3, height: 40, text: 'Cancel',
                onPressed: (){
                  Navigator.pop(context);
                }, cornerRadius: 8, buttonColor: AppColors.grey,
                textStyle: AppFonts.title.copyWith(color: AppColors.textColor)),
            RoundedElevatedButton(width: MediaQuery.of(context).size.width*0.3, height: 40, text: 'Delete',
                onPressed: (){
                  deleteUserData();
                }, cornerRadius: 8, buttonColor: Colors.red,
                textStyle: AppFonts.title.copyWith(color: AppColors.white))
          ],
        );
      },
    );
  }

  deleteUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';
    _profileBloc.add(OnDeleteUserData(userId: userId));


  }

}
