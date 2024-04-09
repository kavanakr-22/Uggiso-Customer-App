import 'package:flutter/material.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:fade_shimmer/fade_shimmer.dart';


class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final delay = 100;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppColors.white,
        elevation: 0.0,
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: FadeShimmer(
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width,
                radius: 4,
                millisecondsDelay: delay,
                fadeTheme:FadeTheme.light
            ),
          );
        },
      )
    );
  }
}
