import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_bloc.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_event.dart';
import 'package:uggiso/Bloc/SignUpBloc/signup_state.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/Widgets/ui-kit/TextFieldCurvedEdges.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final SignUpBloc _signUpBloc = SignUpBloc();
  bool isInvalidCredentials = false;
  String number = '';
  bool isChecked = false;
  bool showPrivacyPolicyError = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FocusNode _mobileFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.requestPermission();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider(
        create: (context) => _signUpBloc,
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (BuildContext context, SignUpState state) {
            if (state is onLoadedState) {
              // Navigate to the next screen when NavigationState is emitted
              saveNumber(_mobileController.text);
              Navigator.pushNamed(context, AppRoutes.verifyOtp);
            } else if (state is ErrorState) {
              isInvalidCredentials = true;
            }
          },
          child: Scaffold(
              backgroundColor: AppColors.white,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                leading: Container(),
                backgroundColor: AppColors.white,
                elevation: 0.0,
                actions: [
                  Platform.isIOS?IconButton(onPressed: (){
                  Navigator.popAndPushNamed(context, AppRoutes.home_landing_screen);
                }, icon: Icon(Icons.close_rounded,color: AppColors.textColor,)):Container()],
              ),
              body:
                  BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
                if (state is LoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          kToolbarHeight - // AppBar height (default is 56)
                          MediaQuery.of(context).padding.top, // Status bar height
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Strings.hi,
                                style:
                                    AppFonts.header.copyWith(color: AppColors.black)),
                            Text(Strings.uggiso_welcomes_you,
                                style: AppFonts.header
                                    .copyWith(color: AppColors.appPrimaryColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 36.0),
                              child: Center(
                                  child: Image.asset(
                                'assets/login.png',
                                height: MediaQuery.of(context).size.height * 0.25,
                                fit: BoxFit.fitWidth,
                              )),
                            ),
                            Center(
                                child: Text(Strings.enter_mobile_number,
                                    style: AppFonts.subHeader
                                        .copyWith(color: AppColors.textColor))),
                            const SizedBox(height: 20.0),
                            TextFieldCurvedEdges(
                                focusNode: _mobileFocusNode,
                                controller: _mobileController,
                                backgroundColor: AppColors.textFieldBg,
                                keyboardType: TextInputType.number,
                                borderColor: AppColors.textFieldBorderColor,
                                length: 10,
                                onChanged: (value) {
                                  if (value.length == 10) {
                                    FocusScope.of(context).unfocus(); // Hide keyboard
                                  }
                                },
                                inputFormatter: "number",
                                validatorType: 'phone'),
                            isInvalidCredentials
                                ? Text(
                                    Strings.error_invalid_credientials,
                                    style:
                                        AppFonts.smallText.copyWith(color: Colors.red),
                                  )
                                : SizedBox(),
                            showPrivacyPolicyError
                                ? Text(
                                    Strings.privacy_policy_checkbox_error,
                                    style:
                                        AppFonts.smallText.copyWith(color: Colors.red),
                                  )
                                : SizedBox(),
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  activeColor: AppColors.appPrimaryColor,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: 'I agree to the ',
                                            style: AppFonts.smallText),
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: AppFonts.smallText.copyWith(
                                              color: AppColors.appPrimaryColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final Uri uri = Uri.parse(
                                                  Strings.terms_and_conditions_url);
                                              if (!await launchUrl(uri,
                                                  mode:
                                                      LaunchMode.externalApplication)) {
                                                // Handle the error gracefully
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Could not launch Terms and Conditions URL')),
                                                );
                                              }
                                              // Handle Terms and Conditions tap here
                                              // _showTermsDialog(context);
                                            },
                                        ),
                                        TextSpan(
                                            text: ' and the ',
                                            style: AppFonts.smallText),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: AppFonts.smallText.copyWith(
                                              color: AppColors.appPrimaryColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              final Uri uri =
                                                  Uri.parse(Strings.privacy_policy_url);
                                              if (!await launchUrl(uri,
                                                  mode:
                                                      LaunchMode.externalApplication)) {
                                                // Handle the error gracefully
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          'Could not launch Terms and Conditions URL')),
                                                );
                                              }
                                              // Handle Privacy Policy tap here
                                              // _showPrivacyPolicyDialog(context);
                                            },
                                        ),
                                        TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Platform.isIOS?SizedBox(height: MediaQuery.of(context).size.height*0.1,):Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: RoundedElevatedButton(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40.0,
                                  text: Strings.get_otp,
                                  onPressed: () {
                                    if (isChecked) {
                                      setState(() {
                                        showPrivacyPolicyError = false;
                                      });
                                      _signUpBloc.add(OnButtonClicked(
                                          number: _mobileController.text));
                                    } else {
                                      setState(() {
                                        showPrivacyPolicyError = true;
                                      });
                                    }
                                  },
                                  cornerRadius: 6.0,
                                  buttonColor: AppColors.appPrimaryColor,
                                  textStyle: AppFonts.header
                                      .copyWith(color: AppColors.black)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void saveNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile_number', number);
  }
}
