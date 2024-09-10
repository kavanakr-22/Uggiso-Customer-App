import 'package:flutter/material.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class ReferralHistory extends StatefulWidget {
  const ReferralHistory({super.key});

  @override
  State<ReferralHistory> createState() => _ReferralHistoryState();
}

class _ReferralHistoryState extends State<ReferralHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        title: Text(Strings.my_referrals,style: AppFonts.appBarText.copyWith(color: AppColors.black),),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: IconButton(
            iconSize: 18,
            icon: Image.asset('assets/ic_back_arrow.png'),
            onPressed: () {
              Navigator.pop(context);

            },
          ),
        ),
      ),
      body: Center(child: Text('No referals Found'),),
    );
  }
}
