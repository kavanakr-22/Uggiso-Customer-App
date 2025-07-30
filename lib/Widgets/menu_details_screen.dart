// ✅ Full working file with cart item ID tracking and order screen navigation

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/MenuListBloc/MenuListBloc.dart';
import 'package:uggiso/Bloc/MenuListBloc/MenuListEvent.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/CreateOrderArgs.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fliters.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/itemsCard.dart';
import 'package:video_player/video_player.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import '../../Model/MenuListModel.dart' as menuListPayload;
import '../Bloc/MenuListBloc/MenuListState.dart';

class RestaurantMockScreen extends StatefulWidget {
  final String? restaurantId;
  final String? restaurantName;
  final String? foodType;
  final double? ratings;
  final String? landmark;
  final String? distance;
  final String? duration;
  final Payload? payload;
  const RestaurantMockScreen(
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
  State<RestaurantMockScreen> createState() => _RestaurantMockScreenState();
}

class _RestaurantMockScreenState extends State<RestaurantMockScreen> {
  int _currentSlide = 0;
  VideoPlayerController? _videoController;
  bool _isVideoStarted = false;
  int totalQuantity = 0;
  List<Map<String, dynamic>> cartItems = [];
  bool _isVeg = false;
  bool _isNonVeg = false;
  bool _isbestSeller = true;
  bool _showButton = false;
  int _totalItemCount = 0;
  final MenuListBloc _menuListBloc = MenuListBloc();
  // final List cartItems = [];
  // List vegMenuItems = [];
  // List nonvegMenuItems = [];
  List bestSellerMenuItems = [];
  Map<String, Map<String, dynamic>> uniqueMenuMap = {};
  String userId = '';
  List<menuListPayload.Payload> vegMenu = [];
  List<menuListPayload.Payload> nonVegMenu = [];
  List<menuListPayload.Payload> allMenuItems = [];

  final String videoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  String selectedFilter = 'All';

  // final List<Map<String, dynamic>> menuItems = [
  //   {
  //     'id': 'idli',
  //     'title': 'Plain Idli',
  //     'subtitle': 'Soft steamed rice cakes',
  //     'price': 40,
  //     'type': 'veg',
  //     'parcelCharges': 20
  //   },
  //   {
  //     'id': 'dosa',
  //     'title': 'Masala Dosa',
  //     'subtitle': 'Crispy dosa with masala',
  //     'price': 65,
  //     'type': 'veg',
  //     'parcelCharges': 20
  //   },
  //   {
  //     'id': 'chicken',
  //     'title': 'Chicken Curry',
  //     'subtitle': 'Spicy chicken gravy',
  //     'price': 120,
  //     'type': 'non-veg',
  //     'parcelCharges': 20
  //   },
  //   {
  //     'id': 'coffee',
  //     'title': 'Filter Coffee',
  //     'subtitle': 'Strong South Indian coffee',
  //     'price': 25,
  //     'type': 'veg',
  //     'parcelCharges': 20
  //   },
  // ];

  // final MenuListBloc _menuListBloc = MenuListBloc();

  void _onItemQuantityChanged(dynamic item) {
    setState(() {
      final itemId = item['id'].toString();
      final existing = cartItems.indexWhere((i) => i['id'] == itemId);

      if (item['quantity'] > 0) {
        if (existing >= 0) {
          cartItems[existing]['quantity'] = item['quantity'];
        } else {
          cartItems.add({
            'id': itemId,
            'quantity': item['quantity'],
            'price': item['price'] ?? 0.0,
            'parcelCharges': 20.0,
          });
        }
      } else {
        if (existing >= 0) cartItems.removeAt(existing);
      }

      totalQuantity =
          cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.restaurantId != null) loadData(widget.restaurantId);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _initializeAndPlayVideo() async {
    _videoController = VideoPlayerController.network(videoUrl);
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    await _videoController!.play();
    setState(() {
      _isVideoStarted = true;
    });
  }

  void loadData(String? restId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
    _menuListBloc
        .add(onInitialised(userId: userId, restaurantId: widget.restaurantId));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> mediaItems = [
      for (int i = 0; i < 5; i++)
        Image.asset(
          'assets/idli.png',
          fit: BoxFit.fill,
          width: double.infinity,
          height: 280,
        ),
      _isVideoStarted &&
              _videoController != null &&
              _videoController!.value.isInitialized
          ? SizedBox(
              width: double.infinity,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_videoController!),
                  IconButton(
                    iconSize: 50,
                    icon: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_videoController!.value.isPlaying) {
                          _videoController!.pause();
                        } else {
                          _videoController!.play();
                        }
                      });
                    },
                  ),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/idli.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 280,
                ),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.play_circle_fill, color: Colors.white),
                  onPressed: () {
                    _initializeAndPlayVideo();
                  },
                ),
              ],
            ),
    ];

    return BlocProvider.value(
      value: _menuListBloc,
      child: Scaffold(
        backgroundColor: AppColors.textFieldBg,
        body: Stack(
          children: [
            // Banner
            SizedBox(
              height: 280,
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 280,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() => _currentSlide = index);
                      },
                    ),
                    items: mediaItems,
                  ),
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        mediaItems.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentSlide == index
                                ? Colors.red
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Draggable Menu List
            DraggableScrollableSheet(
              initialChildSize: 0.64,
              minChildSize: 0.64,
              maxChildSize: 1.0,
              builder: (context, scrollController) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 70),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Text(
                          widget.restaurantName ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '${widget.distance!} | ',
                              style: AppFonts.title,
                            ),
                            Gap(2),
                            Text(
                              widget.duration!,
                              style: AppFonts.title,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Delicious food served hot and fresh.',
                          style: TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Menus',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        FoodTypeFilter(
                          onFilterSelected: (String selected) {
                            setState(() {
                              selectedFilter = selected;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<MenuListBloc, MenuListState>(
                          builder: (context, state) {
                            if (state is FetchingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is FetchedListsState) {
                              allMenuItems = List<menuListPayload.Payload>.from(
                                  state.data ?? []);

                              vegMenu = allMenuItems
                                  .where((item) =>
                                      item.restaurantMenuType?.toUpperCase() ==
                                      'VEG')
                                  .toList();

                              nonVegMenu = allMenuItems
                                  .where((item) =>
                                      item.restaurantMenuType?.toUpperCase() ==
                                      'NONVEG')
                                  .toList();

                              final normalizedFilter =
                                  selectedFilter.toUpperCase();
                              List<menuListPayload.Payload> displayItems;

                              if (normalizedFilter == 'VEG') {
                                displayItems = vegMenu;
                              } else if (normalizedFilter == 'NON-VEG' ||
                                  normalizedFilter == 'NONVEG') {
                                displayItems = nonVegMenu;
                              } else {
                                displayItems = allMenuItems;
                              }

                              return Column(
                                children: displayItems.map((item) {
                                  return ItemsCard(
                                    id: item.menuId.toString(),
                                    title: item.menuName ?? '',
                                    subtitle: item.description ?? '',
                                    price: item.price?.toDouble() ?? 0.0,
                                    rating: item.ratings?.toDouble(), 
                                    type: item.restaurantMenuType
                                            ?.toLowerCase() ??
                                        'veg',
                                    onQuantityChanged: (data) {
                                      data['id'] = item.menuId;
                                      data['price'] =
                                          item.price?.toDouble() ?? 0.0;
                                      _onItemQuantityChanged(data);
                                    },
                                  );
                                }).toList(),
                              );
                            } else if (state is ErrorState) {
                              return Center(
                                  child: Text(
                                      state.message ?? "Something went wrong"));
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Bottom Search & Cart
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.appPrimaryColor),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Search Menus...',
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.appPrimaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (totalQuantity > 0)
                      GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          var _isUserLoggedIn =
                              prefs.getBool('is_user_logged_in') ?? false;

                          if (!_isUserLoggedIn) {
                            print("Please log in");
                          } else {
                            final restaurantId = "";
                            // final restaurantName = "Idly Paradise";
                            final restaurantName = widget.restaurantName;
                            final lat = 0.0;
                            final lng = 0.0;
                            final gstPercent = 0.0;
                            print(cartItems);
                            Navigator.pushNamed(
                              context,
                              AppRoutes.createOrder,
                              arguments: CreateOrderArgs(
                                orderlist: cartItems,
                                restaurantId: restaurantId,
                                restaurantName: restaurantName,
                                restaurantLat: lat,
                                restaurantLng: lng,
                                gstPercent: gstPercent,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$totalQuantity item${totalQuantity > 1 ? 's' : ''} added',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Icon(Icons.shopping_bag,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
