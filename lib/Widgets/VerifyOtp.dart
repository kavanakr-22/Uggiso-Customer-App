import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/Widgets/ui-kit/TextFieldCurvedEdges.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final TextEditingController otpController_1 = TextEditingController();
  final TextEditingController otpController_2 = TextEditingController();
  final TextEditingController otpController_3 = TextEditingController();
  final TextEditingController otpController_4 = TextEditingController();
  late Timer _timer;
  int _secondsRemaining = 30;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36.0),
              child: Center(
                  child: Image.asset(
                'assets/verify_otp.png',
                height: MediaQuery.of(context).size.height * 0.2,
                fit: BoxFit.fitWidth,
              )),
            ),
            Center(
                child: Text(Strings.enter_verification_code,
                    style: AppFonts.header
                        .copyWith(color: AppColors.appPrimaryColor))),
            const SizedBox(height: 20.0),
            Center(
                child: Text(Strings.enter_4_digit_code,
                    style:
                        AppFonts.title.copyWith(color: AppColors.textColor))),
            const SizedBox(height: 20.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: TextFieldCurvedEdges(
                    controller: otpController_1,
                    backgroundColor: AppColors.textFieldBg,
                    keyboardType: TextInputType.number,
                    borderColor: AppColors.textFieldBorderColor,
                    borderRadius: 6,
                  ),
                ),
                SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: TextFieldCurvedEdges(
                      controller: otpController_2,
                      backgroundColor: AppColors.textFieldBg,
                      keyboardType: TextInputType.number,
                      borderColor: AppColors.textFieldBorderColor,borderRadius: 6,),
                ),
                SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: TextFieldCurvedEdges(
                      controller: otpController_3,
                      backgroundColor: AppColors.textFieldBg,
                      keyboardType: TextInputType.number,
                      borderColor: AppColors.textFieldBorderColor,borderRadius: 6,),
                ),
                SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: TextFieldCurvedEdges(
                      controller: otpController_4,
                      backgroundColor: AppColors.textFieldBg,
                      keyboardType: TextInputType.number,
                      borderColor: AppColors.textFieldBorderColor,borderRadius: 6,),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
                child: Text(Strings.resend_code,
                    style: AppFonts.smallText
                        .copyWith(color: AppColors.textColor))),
            Align(
                alignment: Alignment.centerRight,
                child: Text(_formatTimer(_secondsRemaining),
                    style: AppFonts.title
                        .copyWith(color: AppColors.textColor))),

            Expanded(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 30),
                child: RoundedElevatedButton(
                    width: MediaQuery.of(context).size.width,
                    height: 40.0,
                    text: Strings.verify,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.registerUser);
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

  @override
  void dispose() {
    otpController_1.dispose();
    otpController_2.dispose();
    otpController_3.dispose();
    otpController_4.dispose();
    super.dispose();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1,minutes: 00);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_secondsRemaining < 1) {
          timer.cancel();
        } else {
          _secondsRemaining -= 1;
        }
      });
    });
  }

  String _formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
