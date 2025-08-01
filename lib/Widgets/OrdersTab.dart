import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/MyOrderBloc/MyOrderBloc.dart';
import 'package:uggiso/Bloc/MyOrderBloc/MyOrderEvent.dart';
import 'package:uggiso/Bloc/MyOrderBloc/MyOrderState.dart';
import 'package:uggiso/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/MyOrdersModel.dart';
import '../base/common/utils/colors.dart';
import '../base/common/utils/fonts.dart';
import '../base/common/utils/strings.dart';

class OrdersTab extends StatefulWidget {
  final String from;
  const OrdersTab({super.key, this.from = ''});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  final MyOrderBloc _myOrderBloc = MyOrderBloc();
  String? userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          leading: widget.from == ''
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: IconButton(
                    iconSize: 18,
                    icon: Image.asset('assets/ic_back_arrow.png'),
                    color: AppColors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
          // backgroundColor: AppColors.appPrimaryColor,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.appPrimaryGradient,
            ),
          ),
          title: const Text(
            Strings.your_orders,
            style: AppFonts.appBarText,
          ),
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (context) => _myOrderBloc,
          child: BlocBuilder<MyOrderBloc, MyOrderState>(
              builder: (BuildContext context, MyOrderState state) {
            if (state is OrderFetchingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.appPrimaryColor,
                ),
              );
            } else if (state is ErrorState) {
              return Center(
                child: Text(
                  '${state.message}',
                  textAlign: TextAlign.center,
                  style: AppFonts.title,
                ),
              );
            } else if (state is OrderFetchedState) {
              return ShowOrderList(state.data);
            }
            return Container();
          }),
        ));
  }

  Widget ShowOrderList(MyOrdersModel data) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListView.builder(
            itemCount: data.payload?.length,
            itemBuilder: (BuildContext context, int count) {
              return Container(
                  margin: EdgeInsets.only(top: 8.0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(4.0),
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: AppColors.textFieldBg)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                '${data.payload?[count].restaurantName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppFonts.title
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.appSecondaryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    child: Text(
                                      '${data.payload?[count].orderStatus}',
                                      style: AppFonts.smallText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order No : ${data.payload?[count].orderNumber}',
                            style: AppFonts.title.copyWith(fontSize: 12),
                          ),
                          Text(
                            'CODE : ${data.payload?[count].verifyCode}',
                            style: AppFonts.smallText.copyWith(
                                color: AppColors.appPrimaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Gap(8),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.payload?[count].menus?.length,
                          itemBuilder: (BuildContext context, int menuItem) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Row(
                                children: [
                                  data.payload?[count].menus?[menuItem]
                                              .restaurantMenuType ==
                                          'VEG'
                                      ? Image.asset(
                                          'assets/ic_veg.png',
                                          height: 14,
                                          width: 14,
                                        )
                                      : Image.asset(
                                          'assets/ic_non_veg.png',
                                          height: 14,
                                          width: 14,
                                        ),
                                  Gap(8),
                                  Text(
                                    '${data.payload?[count].menus?[menuItem].quantity} x ${data.payload?[count].menus?[menuItem].menuName}',
                                    style: AppFonts.title,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹ ${data.payload?[count].menus?[menuItem].quantityAmount}',
                                          style: AppFonts.title,
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      Gap(8),
                      Divider(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Ordered On ',
                                      style: AppFonts.smallText.copyWith(
                                          color: AppColors
                                              .bottomTabInactiveColor), // Color for the word "Comments"
                                    ),
                                    TextSpan(
                                      text:
                                          '${convertDate(data.payload![count].orderDate)}',
                                      style: AppFonts
                                          .smallText, // Original style for the comments
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                '₹ ${data.payload?[count].totalAmount}',
                                style: AppFonts.smallText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Locate on Map',
                              style: AppFonts.smallText.copyWith(fontSize: 14),
                            ),
                            Gap(10),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                final googleMapsUrl =
                                    'https://www.google.com/maps/search/?api=1&query=${data.payload?[count].lat},${data.payload?[count].lng}';
                                if (await canLaunch(googleMapsUrl)) {
                                  await launch(googleMapsUrl);
                                } else {
                                  print('Could not open Google Maps');
                                }
                              },
                              icon: Icon(
                                Icons.directions, // Icon for navigation
                                color: Colors.blue, // Blue color for the icon
                                size: 24, // Icon size
                              ),
                            ),
                          ],
                        ),
                      ),
                      //     RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: 'Locate on Map',
                      //         style: AppFonts.smallText, // Color for the word "Comments"
                      //       ),
                      //       TextSpan(
                      //         text: '${data.payload?[count].comments}',
                      //         style: AppFonts.smallText, // Original style for the comments
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ));
            }),
      );

  void getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
    print('this is user id : $userId');
    fetchOrders();
  }

  fetchOrders() {
    _myOrderBloc.add(OnFetchOrders(customerId: userId!));
  }

  String convertDate(String? dateString) {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.parse(dateString!);

    // Format the DateTime object to the desired format
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String formattedDate = dateFormat.format(dateTime);

    return formattedDate;
  }
}
