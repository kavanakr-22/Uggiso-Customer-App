import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderEvent.dart';
import 'package:uggiso/Bloc/CreateOrderBloc/CreateOrderState.dart';
import 'package:uggiso/Network/constants.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
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
      required this.restLng,required this.gstPercent})
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
  double? uggiso_point_limit = 0.0;
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
      backgroundColor: AppColors.textFieldBorderColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Hotel Name',
          style: AppFonts.appBarText,
        ),
        leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: IconButton(
              iconSize: 18,
              icon: Image.asset('assets/ic_back_arrow.png'),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        backgroundColor: AppColors.white,
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
              initializeService(widget.restLat!, widget.restLng!,
                  state.data.payload!.orderId!);
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.orderSuccessScreen,
                  (Route<dynamic> route) => false);
            }
            if (state is onCoinDetailsFetched) {
              setState(() {
                showLoader = false;
              });

              if ((state.data.payload?.balance! ?? 0.0) > 10.0) {
                uggiso_point_count = 10.0;
              } else {
                uggiso_point_count = 0.0;
              }
              item_sub_total = double.parse(
                  (item_sub_total - uggiso_point_count!).toStringAsFixed(2));
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
            if(state is InitiatePaymentFailed){
              Fluttertoast.showToast(
                  msg: state.message.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },

          child: showLoader
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColors.appPrimaryColor,
                ))
              : Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     Image.asset(
                            //       'assets/ic_home.png',
                            //       width: 24,
                            //       height: 24,
                            //       color: AppColors.appPrimaryColor,
                            //     ),
                            //     SizedBox(
                            //       width: 8,
                            //     ),
                            //     Text('Distance from Home',
                            //         style: AppFonts.title)
                            //   ],
                            // ),
                            // Gap(12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _istakeAway = true;
                                      _isDineIn = false;
                                    });
                                    loadOrderData();
                                  },
                                  child: RoundedContainer(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          Strings.take_away,
                                          style: AppFonts.title.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      color: _istakeAway
                                          ? AppColors.appSecondaryColor
                                          : AppColors.white,
                                      cornerRadius: 10),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _istakeAway = false;
                                      _isDineIn = true;
                                    });
                                    loadOrderData();
                                  },
                                  child: RoundedContainer(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                          Strings.dine_in,
                                          style: AppFonts.title.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      color: _isDineIn
                                          ? AppColors.appSecondaryColor
                                          : AppColors.white,
                                      cornerRadius: 10),
                                )
                              ],
                            ),
                            Gap(12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(Strings.select_time_slot,
                                    style: AppFonts.title),
                                Gap(24),
                                RoundedContainer(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    color: AppColors.white,
                                    cornerRadius: 8,
                                    padding: 0,
                                    child: DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 0),
                                        border: InputBorder.none,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      value: selectedSlot,
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      icon: Image.asset(
                                        'assets/ic_dropdown_arrow.png',
                                        width: 12.0,
                                        height: 12.0,
                                      ),
                                      items:
                                          Strings.time_slot.map((String value) {
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
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(18),
                    Text(
                      Strings.order_details,
                      style: AppFonts.subHeader,
                    ),
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
                        child: ListView.builder(
                            itemCount: widget.orderlist.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int count) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.orderlist[count]
                                                    ['restaurantMenuType']
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
                                    Gap(4),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                          '${widget.orderlist[count]['menuName']}',
                                          style: AppFonts.title,
                                        )),
                                    Gap(12),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: Text(
                                          '${widget.orderlist[count]['quantity']}',
                                          style: AppFonts.title,
                                        )),
                                    /* RoundedContainer(
                                    width: MediaQuery.of(context).size.width * 0.22,
                                    height:
                                        MediaQuery.of(context).size.height * 0.04,
                                    cornerRadius: 12,
                                    padding: 0,
                                    color: AppColors.appPrimaryColor,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                            color: AppColors.white,
                                            size: 24,
                                          ),
                                        ),
                                        Text(
                                          '1',
                                          style: AppFonts.title
                                              .copyWith(color: AppColors.white),
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
                                            color: AppColors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    )),*/
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset(
                                        'assets/ic_edit.png',
                                        width: 12,
                                        height: 18,
                                      ),
                                    ),
                                    /* Gap(12),
                                Image.asset(
                                  'assets/ic_delete.png',
                                  width: 18,
                                  height: 18,
                                ),*/
                                    Gap(24),
                                    Expanded(
                                      child: Text(
                                        '₹ ${(widget.orderlist[count]['quantity'] * widget.orderlist[count]['price'])}',
                                        textAlign: TextAlign.end,
                                        style: AppFonts.title,
                                      ),
                                    ),
                                    Gap(18),
                                  ],
                                ),
                              );
                            }),
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

                    Gap(18),
                    Text(
                      Strings.bill_details,
                      style: AppFonts.subHeader,
                    ),
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
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            _istakeAway?Gap(18):SizedBox(),
                            _istakeAway?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ):SizedBox(),
                            Gap(18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            _isUggiso_points_selected ? Gap(18) : Container(),
                            _isUggiso_points_selected
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.white,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              Strings.note,
                              style: AppFonts.smallText
                                  .copyWith(color: Colors.red),
                            ),
                            Gap(4),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Text(
                                  Strings.note_desc,
                                  style: AppFonts.smallText,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Gap(36),
                    // Text(
                    //   Strings.payment_methods,
                    //   style: AppFonts.subHeader,
                    // ),
                    // Gap(100),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: RoundedElevatedButton(
                        width: MediaQuery.of(context).size.width * 0.8,
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
        )),
      ),
    );
  }

  calculateTotalAmount(double price, int quantity,double parcelAmount) {
    setState(() {
      item_total = item_total + ((price) * quantity);
      print('this is item total amount : ${item_total}');
      item_sub_total = item_total - (uggiso_point_count!);
      print('this is sub total ${item_total - (uggiso_point_count!)}');
      gst_charges = item_sub_total *
          (double.parse((widget.gstPercent! / 100).toStringAsFixed(2)));
      if(_istakeAway){
        item_sub_total =
            item_sub_total + (double.parse(gst_charges.toStringAsFixed(2)))+parcelAmount;
      }
      else if(_isDineIn){
        item_sub_total =
            item_sub_total + (double.parse(gst_charges.toStringAsFixed(2)));
      }

    });
  }
  clearBillDetails(){
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
    // final List<Object?> result = await platform.invokeMethod('callSabPaisaSdk',
    //     [userName, "", "", userNumber, item_sub_total.toString()]);
    setState(() {
      txnId = generateUUID();
    });
    print('this is item sub total : ${item_sub_total.toString()}');
    _createOrderBloc.add(InitiatePayment(
        name: userName,
        number: userNumber,
        amount: item_sub_total.toString(),
        txnId: txnId));
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
          paidAmount: item_sub_total));
    } else if (payment_response['result'] == 'payment_failed') {
      _showBottomSheet(context);
    }
  }


  String getTimeSlot(String slot){
    switch(slot){
      case 'Immediately': return 'IMMEDIATELY';
      case '10-15min': return 'TENTOFIFTEEN';
      case '5-10min': return 'FIVETOTEN';
      default : return 'IMMEDIATELY';
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
    print('this  is order list : ${widget.orderlist}');
    clearBillDetails();
    for (int i = 0; i < widget.orderlist.length; i++) {
      parcelCharges = parcelCharges + widget.orderlist[i]['parcelCharges'];

      calculateTotalAmount(
          widget.orderlist[i]['price'], widget.orderlist[i]['quantity'],parcelCharges);
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
