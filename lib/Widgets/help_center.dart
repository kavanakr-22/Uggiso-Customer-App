import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textFieldBg,
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        title: Text(Strings.help_center, style: AppFonts.title,),
        centerTitle: false,
        leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: IconButton(
              iconSize: 12,
              icon: Image.asset('assets/ic_back_arrow.png'),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: ()=>Navigator.pushNamed(context, AppRoutes.aboutUs),
              child: RoundedContainer(width: MediaQuery
                  .of(context)
                  .size
                  .width,
                  height: 60,
                  color: AppColors.white,
                  borderColor: AppColors.white,
                  child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Strings.about_us,style: AppFonts.title,),
                ],
              ), cornerRadius: 10),
            ),
            Gap(10),
            InkWell(
              onTap: ()=>callHelpCenter,
              child: RoundedContainer(width: MediaQuery
                  .of(context)
                  .size
                  .width,
                  height:60,
                  color: AppColors.white,
                  borderColor: AppColors.white,
                  child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Strings.call_us,style: AppFonts.title,),
                      Text(Strings.contact_number,style: AppFonts.title.copyWith(color: AppColors.appPrimaryColor),),
                    ],
                  ), cornerRadius: 10),
            ),
            Gap(10),
            InkWell(
              onTap: ()=>openMailApp,
              child: RoundedContainer(width: MediaQuery
                  .of(context)
                  .size
                  .width,
                  height: 60,
                  color: AppColors.white,
                  borderColor: AppColors.white,
                  child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Strings.email_us,style: AppFonts.title,),
                  Text(Strings.contact_mail,style: AppFonts.title.copyWith(color: AppColors.appPrimaryColor),),
                ],
              ), cornerRadius: 10),
            ),
            Gap(10),

          ],
        ),
      ),
    );
  }

  Future<void> openMailApp()async{
    final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: Strings.contact_mail,
        query: ''  // Optional parameters
    );

    if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
    } else {
    throw 'Could not launch ${Strings.contact_mail}';
    }
  }
  Future<void> callHelpCenter()async{
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: Strings.contact_number,
    );
    await launchUrl(launchUri);
  }
}
