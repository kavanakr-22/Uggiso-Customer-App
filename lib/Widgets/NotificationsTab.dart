import 'package:flutter/material.dart';
import 'package:uggiso/Widgets/Shimmer/NotificationsShimmer.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading?NotificationsShimmer():Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 2.0,
        leading:Container(),
        backgroundColor: AppColors.white,
        title: const Text(
          Strings.notifications,
          style: AppFonts.appBarText,
        ),
        centerTitle: true,
      ),
      body: showNotifications(),
    );
  }

  Widget showNotifications() => ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
            child: RoundedContainer(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                cornerRadius: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This is new Notifications'),
                    Center(
                      child: Text(
                        Strings.view,
                        style: AppFonts.title
                            .copyWith(color: AppColors.appPrimaryColor),
                      ),
                    ),
                  ],
                )),
          );
        },
      );
}
