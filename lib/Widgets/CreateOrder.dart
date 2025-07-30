import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderEvent.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderState.dart';
import 'package:uggiso/Network/constants.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/base/common/utils/CreateOrderArgs.dart';
import 'package:uggiso/base/common/utils/LocationManager.dart';
import 'package:uggiso/base/common/utils/background_service.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import '../Bloc/CreateOrderBloc/CreateOrderBloc.dart';
import '../app_routes.dart';
import '../base/common/utils/colors.dart';
import 'ui-kit/RoundedContainer.dart';

class CreateOrder extends StatefulWidget {
  final List<Map<String, dynamic>> orderlist;
  final String? restaurantId;
  final String? restaurantName;
  final double? restLat;
  final double? restLng;
  final double? gstPercent;

  const CreateOrder(
      {Key? key,
      required this.orderlist,
      required this.restaurantId,
      required this.restaurantName,
      required this.restLat,
      required this.restLng,
      required this.gstPercent})
      : super(key: key);

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  String selectedSlot = 'Immediately';
  double item_total = 0.0;
  double item_sub_total = 0.0;
  double gst_charges = 0.0;
  String userId = '';
  String userNumber = '';
  String userName = '';
  double parcelCharges = 0.0;
  List menuList = [];
  bool showLoader = false;
  bool _isUggiso_points_selected = false;
  double? uggiso_point_count = 0.0;
  double? uggiso_point_balance = 0.0;
  String txnId = '';
  String access_data = '';
  final CreateOrderBloc _createOrderBloc = CreateOrderBloc();
  TextEditingController points_controller = TextEditingController();
  bool _istakeAway = true;
  bool _isDineIn = false;

  // static const platform = MethodChannel('com.sabpaisa.integration/native');
  static MethodChannel _channel = MethodChannel('easebuzz');

  @override
  void initState() {
    super.initState();
    getUserDetails();
    loadOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.restaurantName ?? 'Hotel Name',
          style: AppFonts.appBarText,
        ),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 26, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appPrimaryColor),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(0.05), // shadow color with opacity
                blurRadius: 10, // soft blur radius
                spreadRadius: 2, // how far the shadow spreads
                offset: Offset(0, 4), // position of shadow (x, y)
              ),
            ],
            gradient: AppColors.appPrimaryGradient, // <-- Your gradient here
          ),
        ),
        backgroundColor:
            Colors.transparent, // Important to allow gradient to show
      ),
      body: BlocProvider(
        create: (context) => _createOrderBloc,
        child: SingleChildScrollView(
            child: BlocListener<CreateOrderBloc, CreateOrderState>(
          listener: (BuildContext context, CreateOrderState state) {
            if (state is LoadingHotelState || state is FetchingCoinsDetails) {
              showLoader = true;
              CircularProgressIndicator();
            }
            if (state is onLoadedHotelState) {
              showLoader = false;
              print('this is orderId  : ${state.data.payload?.orderId}');
              print('this is data  : $access_data');
              print('this is usedCoins  : ${uggiso_point_count!}');
              _createOrderBloc.add(OnAddTransactionData(
                  orderId: state.data.payload!.orderId!,
                  receiverId: state.data.payload!.restaurantId!,
                  senderId: state.data.payload!.customerId!,
                  status: "SUCCESS",
                  transactionId: txnId,
                  orderNumber: state.data.payload!.orderNumber!,
                  paymentId: generateUUID(),
                  amount: state.data.payload!.totalAmount!,
                  usedCoins: uggiso_point_count!,
                  data: access_data,
                  paidAmount: state.data.payload!.paidAmount!,
                  paymentMode: state.data.payload!.paymentType!,
                  payerName: userName,
                  payerMobile: userNumber));
              initializeService(widget.restLat ?? 0.0, widget.restLng ?? 0.0,
                  state.data.payload!.orderId!);
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.orderSuccessScreen,
                  arguments: OrderSuccessArgs(
                      restLat: widget.restLat ?? 0.0,
                      restLng: widget.restLng ?? 0.0),
                  (Route<dynamic> route) => false);
            }
            if (state is onCoinDetailsFetched) {
              setState(() {
                showLoader = false;
              });

              if ((state.data.payload?.balance! ?? 0.0) >= 10.0) {
                uggiso_point_count = 10.0;
              } else {
                uggiso_point_count = 0.0;
              }
              uggiso_point_balance = state.data.payload?.balance!.toDouble();
              // item_sub_total = double.parse(
              //     (item_sub_total - uggiso_point_count!).toStringAsFixed(2));
            }
            if (state is onPaymentInitiated) {
              String? access_key = state.paymentData.payload?.data;
              String pay_mode = Constants.mode;
              access_data = access_key!;
              print('this is access key : ${access_key}');
              Object parameters = {
                "access_key": access_key,
                "pay_mode": pay_mode
              };
              gotoPaymentScreen(parameters);
            }
            if (state is InitiatePaymentFailed) {
              showToast(
                state.message.toString(),
                duration: const Duration(seconds: 1),
                position: ToastPosition.bottom,
                backgroundColor: Colors.red,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              );
            }
          },
          child: showLoader
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColors.appPrimaryColor,
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(14),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          // border: Border.all(color: AppColors.appPrimaryColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 28,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Toggle Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _istakeAway = true;
                                        _isDineIn = false;
                                      });
                                      loadOrderData();
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.easeInOut,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: _istakeAway
                                            ? AppColors.appPrimaryColor
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: _istakeAway
                                              ? AppColors.appPrimaryColor
                                              : Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Strings.take_away,
                                          style: AppFonts.title.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: _istakeAway
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _istakeAway = false;
                                        _isDineIn = true;
                                      });
                                      loadOrderData();
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.easeInOut,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: _isDineIn
                                            ? AppColors.appPrimaryColor
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: _isDineIn
                                              ? AppColors.appPrimaryColor
                                              : Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Strings.dine_in,
                                          style: AppFonts.title.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: _isDineIn
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Gap(24),

                            // Time Slot Selection
                            Text(
                              Strings.select_time_slot,
                              style: AppFonts.title.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.5,
                                color: Colors.black87,
                              ),
                            ),
                            const Gap(12),
                            Container(
                              height: 52,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  value: selectedSlot,
                                  isExpanded: true,
                                  menuMaxHeight:
                                      MediaQuery.of(context).size.height * 0.4,
                                  icon: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.asset(
                                      'assets/ic_dropdown_arrow.png',
                                      width: 14,
                                      height: 14,
                                    ),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                  ),
                                  style: AppFonts.title.copyWith(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                  items: Strings.time_slot.map((String value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSlot = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(18),

                      // Text(
                      //   Strings.order_details,
                      //   style: AppFonts.subHeader,
                      // ),
                      // Gap(18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.appPrimaryColor,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.order_details,
                                style: AppFonts.subHeader,
                              ),
                              Gap(18),
                              ListView.builder(
                                  itemCount: widget.orderlist.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int count) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            children: [
                                              widget.orderlist[count][
                                                              'restaurantMenuType']
                                                          .toString()
                                                          .toLowerCase() ==
                                                      'veg'
                                                  ? Image.asset(
                                                      'assets/ic_veg.png',
                                                      width: 12,
                                                      height: 12,
                                                    )
                                                  : Image.asset(
                                                      'assets/ic_non_veg.png',
                                                      width: 12,
                                                      height: 12,
                                                    ),
                                              Gap(16),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Text(
                                                    '${widget.orderlist[count]['menuName']}',
                                                    style: AppFonts.title,
                                                  )),
                                              Gap(55),
                                              // Container(
                                              //     width: MediaQuery.of(context)
                                              //             .size
                                              //             .width *
                                              //         0.1,
                                              //     child: Text(
                                              //       '${widget.orderlist[count]['quantity']}',
                                              //       style: AppFonts.title,
                                              //     )),
                                              RoundedContainer(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.22,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.04,
                                                  cornerRadius: 12,
                                                  padding: 0,
                                                  color: AppColors
                                                      .appSecondaryColor,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Gap(6),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            // _orderCount = _orderCount + 1;
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.remove,
                                                            color:
                                                                AppColors.black,
                                                            size: 26),
                                                      ),
                                                      Gap(5),
                                                      Text(
                                                        '${widget.orderlist[count]['quantity']}',
                                                        style: AppFonts.title,
                                                      ),
                                                      Gap(6),
                                                      InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            // _orderCount = _orderCount - 1;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          color:
                                                              AppColors.black,
                                                          size: 24,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              // InkWell(
                                              //   onTap: () {
                                              //     Navigator.pop(context);
                                              //   },
                                              //   child: Image.asset(
                                              //     'assets/ic_edit.png',
                                              //     width: 12,
                                              //     height: 18,
                                              //   ),
                                              // ),
                                              /* Gap(12),
                                          Image.asset(
                                            'assets/ic_delete.png',
                                            width: 18,
                                            height: 18,
                                          ),*/
                                              // Gap(24),
                                              // Expanded(
                                              //   child: Text(
                                              //     '₹ ${(widget.orderlist[count]['quantity'] * widget.orderlist[count]['price'])}',
                                              //     textAlign: TextAlign.end,
                                              //     style: AppFonts.title,
                                              //   ),
                                              // ),
                                              // Gap(18),
                                            ],
                                          ),
                                          Gap(5),
                                          Row(
                                            children: [
                                              // CrossAxisAlignment.start
                                              Text(
                                                "Edit",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.edit_outlined),
                                                iconSize: 20,
                                              ),
                                              SizedBox(width: 170),
                                              Text(
                                                '₹ ${(widget.orderlist[count]['quantity'] * widget.orderlist[count]['price'])}',
                                                textAlign: TextAlign.end,
                                                style: AppFonts.title,
                                              ),
                                            ],
                                          ),
                                          Gap(5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 8),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Add more Items",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Gap(18),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: Align(
                      //     alignment: Alignment.topLeft,
                      //     child: Text(
                      //       'you have $uggiso_point_count in your wallet and you can redeem upto $uggiso_point_limit',
                      //       style: AppFonts.smallText,
                      //     ),
                      //   ),
                      // ),
                      // Gap(8),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Container(
                      //         width: MediaQuery.of(context).size.width * 0.6,
                      //         child: TextFieldCurvedEdges(
                      //             controller: points_controller,
                      //             backgroundColor: AppColors.white,
                      //             keyboardType: TextInputType.number,
                      //             borderRadius: 5,
                      //             borderColor: AppColors.appSecondaryColor),
                      //       ),
                      //       RoundedElevatedButton(
                      //           width: 80,
                      //           height: 50,
                      //           text: Strings.apply,
                      //           onPressed: () {
                      //             calculatePoints(
                      //                 double.parse(points_controller.text));
                      //           },
                      //           cornerRadius: 10,
                      //           buttonColor: AppColors.appSecondaryColor,
                      //           textStyle: AppFonts.smallText)
                      //     ],
                      //   ),
                      // ),

                      // Gap(18),
                      // Text(
                      //   Strings.bill_details,
                      //   style: AppFonts.subHeader,
                      // ),
                      Gap(18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.white,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.bill_details,
                                style: AppFonts.subHeader,
                              ),
                              Gap(10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Strings.item_total,
                                    style: AppFonts.title,
                                  ),
                                  Text(
                                    '${item_total}',
                                    style: AppFonts.title,
                                  )
                                ],
                              ),
                              _istakeAway ? Gap(18) : SizedBox(),
                              _istakeAway
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Strings.parcel_charges,
                                          style: AppFonts.title,
                                        ),
                                        Text(
                                          '${parcelCharges.toStringAsFixed(2)}',
                                          style: AppFonts.title,
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                              Gap(18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Strings.gst_charges,
                                    style: AppFonts.title,
                                  ),
                                  Text(
                                    '${gst_charges.toStringAsFixed(2)}',
                                    style: AppFonts.title,
                                  )
                                ],
                              ),
                              _isUggiso_points_selected &&
                                      item_sub_total.toInt() > 20
                                  ? Gap(18)
                                  : Container(),
                              _isUggiso_points_selected &&
                                      item_sub_total.toInt() > 20
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Strings.uggiso_points,
                                          style: AppFonts.title,
                                        ),
                                        Text(
                                          '- $uggiso_point_count',
                                          style: AppFonts.title,
                                        )
                                      ],
                                    )
                                  : Container(),
                              Gap(18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Strings.to_pay,
                                    style: AppFonts.title.copyWith(
                                        color: AppColors.appPrimaryColor),
                                  ),
                                  Text(
                                    '$item_sub_total',
                                    style: AppFonts.title,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Gap(18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.note
                                    .toUpperCase(), // "NOTE" in all caps
                                style: AppFonts.smallText.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                Strings.note_desc,
                                style: AppFonts.smallText.copyWith(
                                  color: Colors.grey.shade700,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap(25),
                      // Text(
                      //   Strings.payment_methods,
                      //   style: AppFonts.subHeader,
                      // ),
                      // Gap(100),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: RoundedElevatedButton(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 40.0,
                          text: 'PROCEED PAYMENT',
                          textStyle: AppFonts.title,
                          cornerRadius: 8,
                          buttonColor: AppColors.appPrimaryColor,
                          onPressed: () async {
                            if (await isLocationEnabled()) {
                              createOrder();
                            } else {
                              getUserLocation();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
        )),
      ),
    );
  }

  calculateTotalAmount(double price, int quantity, double parcelAmount) {
    setState(() {
      item_total = item_total + ((price) * quantity);
      print('this is item total amount : ${item_total}');
      if (item_total >= 20 && item_total <= 100) {
        item_sub_total = item_total - (uggiso_point_count!);
      } else {
        item_sub_total = item_total;
      }
      gst_charges = item_sub_total *
          (double.parse((widget.gstPercent! / 100).toStringAsFixed(2)));
      if (_istakeAway) {
        item_sub_total = item_sub_total +
            (double.parse(gst_charges.toStringAsFixed(2))) +
            parcelAmount;
      } else if (_isDineIn) {
        item_sub_total =
            item_sub_total + (double.parse(gst_charges.toStringAsFixed(2)));
      }
    });
    print('this is item sub total :$item_sub_total');
  }

  clearBillDetails() {
    setState(() {
      item_sub_total = 0.0;
      gst_charges = 0.0;
      item_total = 0.0;
      parcelCharges = 0.0;
    });
  }

  getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();

    LocationInfo _location = await LocationManager.getCurrentPosition();
    print(
        'this is user lat lng : ${_location.longitude} and ${_location.latitude}');
    prefs.setDouble('user_longitude', _location.longitude);
    prefs.setDouble('user_latitude', _location.latitude);
    createOrder();
  }

  getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      userNumber = prefs.getString('mobile_number') ?? '';
      userName = prefs.getString('user_name') ?? '';
      _isUggiso_points_selected = prefs.getBool('use_points_status') ?? false;
      // uggiso_coin_count = prefs.getDouble('use_coins_count') ?? 0.0;
    });
    if (_isUggiso_points_selected) {
      getPointsDetails();
    }
  }

  getPointsDetails() async {
    _createOrderBloc.add(OnGetRewardsDetails(userId: userId));
  }

  createOrder() async {
    setState(() {
      txnId = generateUUID();
    });
    print('this is item sub total : ${item_sub_total.toString()}');
    _createOrderBloc.add(InitiatePayment(
        name: userName,
        number: userNumber,
        amount: item_sub_total.toString(),
        txnId: txnId));

    // _createOrderBloc.add(OnPaymentClicked(
    //     restaurantId: widget.restaurantId!,
    //     restaurantName: widget.restaurantName!,
    //     customerId: userId,
    //     menuData: menuList,
    //     orderType: _istakeAway ? "PARCEL" : "DINEING",
    //     paymentType: 'UPI',
    //     orderStatus: 'CREATED',
    //     totalAmount: item_sub_total.toInt(),
    //     comments: 'Please do little more spicy',
    //     timeSlot: getTimeSlot(selectedSlot),
    //     transMode: 'BIKE',
    //     usedCoins: uggiso_point_count!.toInt(),
    //     paidAmount: item_sub_total,
    //     lat:widget.restLat!,lng:widget.restLng!));
  }

  gotoPaymentScreen(Object params) async {
    print('this is params : $params');
    final payment_response =
        await _channel.invokeMethod("payWithEasebuzz", params);

    if (payment_response['result'] == 'payment_successfull') {
      _createOrderBloc.add(OnPaymentClicked(
          restaurantId: widget.restaurantId!,
          restaurantName: widget.restaurantName!,
          customerId: userId,
          menuData: menuList,
          orderType: _istakeAway ? "PARCEL" : "DINEING",
          paymentType: 'UPI',
          orderStatus: 'CREATED',
          totalAmount: item_sub_total.toInt(),
          comments: 'Please do little more spicy',
          timeSlot: getTimeSlot(selectedSlot),
          transMode: 'BIKE',
          usedCoins: uggiso_point_count!.toInt(),
          paidAmount: item_sub_total,
          lat: widget.restLat ?? 0.0,
          lng: widget.restLng ?? 0.0));
    } else if (payment_response['result'] == 'payment_failed') {
      _showBottomSheet(context);
    }
  }

  String getTimeSlot(String slot) {
    switch (slot) {
      case 'Immediately':
        return 'IMMEDIATELY';
      case '10-15min':
        return 'TENTOFIFTEEN';
      case '5-10min':
        return 'FIVETOTEN';
      default:
        return 'IMMEDIATELY';
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isDismissible: false,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  '${Strings.transaction_failed}',
                  style: AppFonts.header.copyWith(color: Colors.red),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 80.0,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.003),
                Text(
                  '${Strings.transaction_failed_message}',
                  style: AppFonts.title,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void loadOrderData() {
    menuList.clear();
    print('this  is order list : ${widget.orderlist}');
    clearBillDetails();
    for (int i = 0; i < widget.orderlist.length; i++) {
      parcelCharges = parcelCharges + widget.orderlist[i]['parcelCharges'];

      calculateTotalAmount(widget.orderlist[i]['price'],
          widget.orderlist[i]['quantity'], parcelCharges);
      menuList.add({
        "menuId": widget.orderlist[i]['menuId'],
        "quantity": widget.orderlist[i]['quantity'],
        "quantityAmount":
            (widget.orderlist[i]['price'] * widget.orderlist[i]['quantity']),
        "parcelAmount": widget.orderlist[i]['parcelCharges'],
        "menuName": widget.orderlist[i]['menuName'],
        "photo": widget.orderlist[i]['photo'],
        "restaurantMenuType": widget.orderlist[i]['restaurantMenuType']
      });
    }
  }
}
