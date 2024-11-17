import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_routes.dart';

class OrderSuccessScreen extends StatefulWidget {
  final double lat;
  final double lng;
  const OrderSuccessScreen({super.key, required this.lat,required this.lng});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textFieldBorderColor,
      appBar: AppBar(
          leading: Container(),
          elevation: 0,
          backgroundColor: AppColors.textFieldBorderColor),
      body: Column(
        children: [
          Image.asset('assets/ic_payment_success.png'),
          Gap(24),
          Text(
            'Yeah !',
            style: AppFonts.header.copyWith(color: AppColors.appPrimaryColor),
          ),
          Gap(18),
          Text(
            Strings.order_successful,
            style: AppFonts.header,
          ),
          Gap(28),
          Column(
            children: [
              RoundedElevatedButton(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                text: 'Get Route',
                onPressed: () async{
                  final googleMapsUrl =
                      'https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.lng}';
                  if (await canLaunch(googleMapsUrl)) {
                  await launch(googleMapsUrl);
                  } else {
                  print('Could not open Google Maps');
                  }
                },
                cornerRadius: 12,
                buttonColor: AppColors.white,
                textStyle: AppFonts.subHeader
                    .copyWith(color: AppColors.appPrimaryColor),
              ),
              Gap(10),
              RoundedElevatedButton(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 40,
                text: 'Done',
                onPressed: () =>
                    Navigator.popAndPushNamed(context, AppRoutes.myOrders),
                cornerRadius: 12,
                buttonColor: AppColors.white,
                textStyle: AppFonts.subHeader
                    .copyWith(color: AppColors.appPrimaryColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
