import 'package:flutter/material.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/Widgets/ui-kit/TextFieldCurvedEdges.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController _nameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.welcome,
                style: AppFonts.header1
                    .copyWith(color: AppColors.appPrimaryColor)),
            const SizedBox(height: 20.0),
            Text(Strings.world_of_flavor,
                style:
                AppFonts.subHeader.copyWith(color: AppColors.textColor)),
            Text(Strings.appName,
                style:
                AppFonts.subHeader.copyWith(color: AppColors.appPrimaryColor)),
            const SizedBox(height: 30.0),

            Text(Strings.enter_your_name,
                style:
                AppFonts.title.copyWith(color: AppColors.textColor)),
            const SizedBox(height: 30.0),
            TextFieldCurvedEdges(
              controller: _nameController,
              backgroundColor: AppColors.textFieldBg,
              keyboardType: TextInputType.name,
              borderColor: AppColors.textFieldBorderColor,
              borderRadius: 6,
            ),

            const SizedBox(height: 20.0),

            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 30),
                child: RoundedElevatedButton(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    text: Strings.submit,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.homeScreen);
                    },
                    cornerRadius: 6.0,
                    buttonColor: AppColors.appPrimaryColor,
                    textStyle:
                    AppFonts.header.copyWith(color: AppColors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
