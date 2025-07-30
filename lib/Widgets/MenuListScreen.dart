import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/MenuListBloc/MenuListBloc.dart';
import 'package:uggiso/Bloc/MenuListBloc/MenuListState.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import '../../Model/MenuListModel.dart' as menuListPayload;
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/base/common/utils/CreateOrderArgs.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import '../Bloc/MenuListBloc/MenuListEvent.dart';
import '../app_routes.dart';
import '../base/common/utils/MenuItemCard.dart';
import '../base/common/utils/colors.dart';
import '../base/common/utils/fonts.dart';

class MenuListScreen extends StatefulWidget {
  final String? restaurantId;
  final String? restaurantName;
  final String? foodType;
  final double? ratings;
  final String? landmark;
  final String? distance;
  final String? duration;
  final Payload? payload;

  const MenuListScreen(
      {super.key,
      required this.restaurantId,
      required this.restaurantName,
      required this.foodType,
      required this.ratings,
      required this.landmark,
      required this.distance,
      required this.duration,
      required this.payload});

  @override
  State<MenuListScreen> createState() => _MenuListScreenState();
}

class _MenuListScreenState extends State<MenuListScreen> {
  bool _isVeg = false;
  bool _isNonVeg = false;
  bool _isbestSeller = true;
  bool _showButton = false;
  int _totalItemCount = 0;
  final MenuListBloc _menuListBloc = MenuListBloc();
  final List cartItems = [];
  List vegMenuItems = [];
  List nonvegMenuItems = [];
  List bestSellerMenuItems = [];
  Map<String, Map<String, dynamic>> uniqueMenuMap = {};
  String userId = '';
  List<menuListPayload.Payload> vegMenu = [];
  List<menuListPayload.Payload> nonVegMenu = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.restaurantId != null) loadData(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.restaurantName!,
          style: AppFonts.title,
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
        // backgroundColor: AppColors.appPrimaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.appPrimaryGradient,
          ),
        ),
      ),
      floatingActionButton: _showButton
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.appPrimaryColor,
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                var _isUserLoggedIn =
                    prefs.getBool('is_user_logged_in') ?? false;
                List<Map<String, dynamic>> uniqueMenuList = [];
                uniqueMenuMap.clear();
                for (var menu in cartItems) {
                  var menuId = menu['menuId'];
                  if (!uniqueMenuMap.containsKey(menuId) ||
                      menu['quantity'] > uniqueMenuMap[menuId]!['quantity']) {
                    uniqueMenuMap[menuId] = menu;
                  }
                }
                uniqueMenuList = uniqueMenuMap.values.toList();
                if (Platform.isIOS) {
                  if (_isUserLoggedIn) {
                    Navigator.pushNamed(context, AppRoutes.createOrder,
                        arguments: CreateOrderArgs(
                            orderlist: uniqueMenuList,
                            restaurantId: widget.restaurantId,
                            restaurantName: widget.restaurantName!,
                            restaurantLat: widget.payload?.lat,
                            restaurantLng: widget.payload?.lng,
                            gstPercent: widget.payload?.gstPercent));
                  } else {
                    requestSignInDialog(context);
                  }
                } else if (Platform.isAndroid) {
                  print(
                      'this is gst percentage : ${widget.payload?.gstPercent}');
                  Navigator.pushNamed(context, AppRoutes.createOrder,
                      arguments: CreateOrderArgs(
                          orderlist: uniqueMenuList,
                          restaurantId: widget.restaurantId,
                          restaurantName: widget.restaurantName!,
                          restaurantLat: widget.payload?.lat,
                          restaurantLng: widget.payload?.lng,
                          gstPercent: widget.payload?.gstPercent ?? 0.0));
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              label: const Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10.0), // ↓ Less vertical padding here
                child: Text(
                  'CONTINUE',
                  style: AppFonts.title,
                ),
              ),
            )
          : Container(),
      body: BlocProvider(
        create: (context) => _menuListBloc,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.textGrey.withOpacity(0.7),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.textGrey.withOpacity(0.4), // First color
                      Colors.blueGrey.withOpacity(0.5)
                    ],
                    begin: Alignment.topCenter, // Gradient starts from top-left
                    end:
                        Alignment.bottomCenter, // Gradient ends at bottom-right
                  ),
                  // image: DecorationImage(
                  //   image: AssetImage('assets/ic_gradiant_bg.png'),
                  //   fit: BoxFit.cover, // Adjust the BoxFit property as needed
                  // ),
                ),
                child: Column(
                  children: [
                    const Gap(24),
                    widget.restaurantName != ''
                        ? Text(
                            widget.restaurantName!,
                            style: AppFonts.appBarText
                                .copyWith(fontWeight: FontWeight.w600),
                          )
                        : Container(),
                    const Gap(12),
                    widget.foodType == 'VEG'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/ic_veg.png',
                                height: 12,
                                width: 12,
                              ),
                              const Gap(4),
                              Text(
                                'Veg',
                                style: AppFonts.title
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/ic_non_veg.png',
                                height: 12,
                                width: 12,
                              ),
                              const Gap(4),
                              Text(
                                'Non Veg',
                                style: AppFonts.title
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                    const Gap(24),
                    widget.ratings == null
                        ? Container()
                        : RoundedContainer(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.04,
                            cornerRadius: 20,
                            color: AppColors.white,
                            borderColor: AppColors.appPrimaryColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('4.3',
                                    style: AppFonts.title
                                        .copyWith(fontWeight: FontWeight.w500)),
                                Image.asset(
                                  'assets/ic_star.png',
                                  width: 18,
                                  height: 18,
                                )
                              ],
                            ),
                          ),
                    const Gap(24),
                    RoundedContainer(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.05,
                      cornerRadius: 8,
                      color: AppColors.white,
                      borderColor: AppColors.appPrimaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Text(
                              '${widget.landmark!} | ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.title
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              '${widget.distance!} | ',
                              style: AppFonts.title,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              widget.duration!,
                              style: AppFonts.title,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(18)
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Gap(18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.003,
                          color: AppColors.appPrimaryColor,
                        ),
                        const Gap(12),
                        Image.asset(
                          'assets/ic_right_circle.png',
                          width: 12,
                          height: 12,
                        ),
                        const Gap(16),
                        const Text(
                          Strings.menu,
                          style: AppFonts.smallText,
                        ),
                        const Gap(16),
                        Image.asset(
                          'assets/ic_left_circle.png',
                          width: 12,
                          height: 12,
                        ),
                        const Gap(12),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.003,
                          color: AppColors.appPrimaryColor,
                        ),
                      ],
                    ),
                    const Gap(12),
                    widget.foodType == 'VEG'
                        ? Container()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isbestSeller = false;
                                      _isNonVeg = false;
                                      _isVeg = true;
                                    });
                                  },
                                  child: RoundedContainer(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      cornerRadius: 20,
                                      color: _isVeg
                                          ? AppColors.grey
                                          : AppColors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/ic_veg.png',
                                            height: 12,
                                            width: 12,
                                          ),
                                          const Gap(4),
                                          Text(
                                            Strings.veg,
                                            style: AppFonts.title.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )),
                                ),
                                const Gap(18),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isbestSeller = false;
                                      _isNonVeg = true;
                                      _isVeg = false;
                                    });
                                  },
                                  child: RoundedContainer(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      cornerRadius: 20,
                                      color: _isNonVeg
                                          ? AppColors.grey
                                          : AppColors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/ic_non_veg.png',
                                            height: 12,
                                            width: 12,
                                          ),
                                          const Gap(4),
                                          Text(
                                            Strings.non_veg,
                                            style: AppFonts.title.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )),
                                ),
                                const Gap(18),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isbestSeller = true;
                                      _isNonVeg = false;
                                      _isVeg = false;
                                    });
                                  },
                                  child: RoundedContainer(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      cornerRadius: 20,
                                      color: _isbestSeller
                                          ? AppColors.grey
                                          : AppColors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Gap(4),
                                          Text(
                                            Strings.all,
                                            style: AppFonts.title.copyWith(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                    const Gap(24),
                    BlocListener<MenuListBloc, MenuListState>(
                      listener: (BuildContext context, MenuListState state) {
                        if (state is FetchedListsState) {
                          print('inside listener');

                          print('ALL MENU ITEMS:');
                          for (var item in state.data!) {
                            print(
                                'Menu: ${item.menuName}, Type: ${item.menuType}, RestaurantMenuType: ${item.restaurantMenuType}, Price: ${item.price}');
                            if (item.restaurantMenuType == 'VEG') {
                              vegMenu.add(item);
                            } else if (item.restaurantMenuType == 'NONVEG') {
                              nonVegMenu.add(item);
                            }
                          }
                          print('inside listener veg menu : $vegMenu');
                          print('inside listener non veg menu : $nonVegMenu');

                          MenuItemCardDisplay(vegMenu);
                        }
                      },
                      child: BlocBuilder<MenuListBloc, MenuListState>(
                        builder: (context, state) {
                          if (state is FetchingState) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: AppColors.white,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: AppColors.appPrimaryColor,
                                )));
                          } else if (state is FetchedListsState) {
                            return state.data?.length == 0
                                ? Center(child: Text('No Items Found'))
                                : MenuItemCardDisplay(_isVeg
                                    ? vegMenu
                                    : _isNonVeg
                                        ? nonVegMenu
                                        : state.data);
                          } else if (state is ErrorState) {
                            return Center(child: Text(state.message!));
                          }
                          return Container();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadData(String? restId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
    _menuListBloc
        .add(onInitialised(userId: userId, restaurantId: widget.restaurantId));
  }

  Widget MenuItemCardDisplay(List? data) {
    // List vegData = data?.where((item) => item.menuType == 'VEG').toList() ?? [];
    // print('this is veg data : $vegData');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ListView.builder(
          itemCount: data?.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return MenuItemCard(
              listData: data![index],
              itemLength: data!.length,
              onItemAdded: () {
                setState(() {
                  _totalItemCount++;
                  _showButton = true;
                });
                cartItems.add({
                  'menuId': data[index].menuId.toString(),
                  'menuName': data[index].menuName.toString(),
                  'menuType': data[index].menuType.toString(),
                  'price': data[index].price!,
                  'restaurantMenuType': data[index].restaurantMenuType!,
                  'quantity': 1,
                  'parcelCharges': data[index].parcelCharges!,
                  "photo": data[index].photo!
                });
              },
              onEmptyCart: (value) {
                setState(() {
                  _totalItemCount--;
                  if (_totalItemCount == 0) _showButton = false;
                });
                cartItems.removeWhere((item) => item['menuId'] == value);
              },
              onQuantityChanged: (int value) {
                cartItems.add({
                  'menuId': data[index].menuId.toString(),
                  'menuName': data[index].menuName.toString(),
                  'menuType': data[index].menuType.toString(),
                  'price': data[index].price!,
                  'restaurantMenuType': data[index].restaurantMenuType!,
                  'quantity': value,
                  'parcelCharges': data[index].parcelCharges!,
                  "photo": data[index].photo!
                });
              },
              userId: userId,
            );
          }),
    );
  }

  void requestSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Reduced corner radius
          ),
          title: Text(
            "You are not logged in. Please sign in to continue with creating your order.",
            style: AppFonts.title,
            textAlign: TextAlign.center,
          ),
          actions: [
            RoundedElevatedButton(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                text: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                },
                cornerRadius: 8,
                buttonColor: AppColors.grey,
                textStyle:
                    AppFonts.title.copyWith(color: AppColors.appPrimaryColor)),
            RoundedElevatedButton(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 40,
                text: 'Sign In',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.signupScreen, // The new route
                    (Route<dynamic> route) =>
                        false, // Condition to remove all routes
                  );
                },
                cornerRadius: 8,
                buttonColor: AppColors.appPrimaryColor,
                textStyle: AppFonts.title.copyWith(color: AppColors.white))
          ],
        );
      },
    );
  }
}
