import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeBloc.dart';
import 'package:uggiso/Widgets/HomeTab.dart';
import 'package:uggiso/Widgets/OrdersTab.dart';
import 'package:uggiso/Widgets/ProfileTab.dart';
import 'package:uggiso/Widgets/bookmark.dart';
import 'package:uggiso/Widgets/menu_details_screen.dart';
import 'package:uggiso/Widgets/ui-kit/HorizontalGrid.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedElevatedButton.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/get_route_map.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserFirstScreen extends StatefulWidget {
  const UserFirstScreen({Key? key}) : super(key: key);

  @override
  State<UserFirstScreen> createState() => _UserFirstScreenState();
}

class _UserFirstScreenState extends State<UserFirstScreen> {
  int _selectedIndex = 0;
  String currentLocation = '';
  final String apiKey = 'AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA';

  final List<String> _labels = [
    Strings.home,
    Strings.orders,
    Strings.by_route,
  ];

  final List<Widget> _tabs = <Widget>[HomeTab(), OrdersTab(), GetRouteMap()];

  final List<String> sliderImages = [
    'assets/slider1.jpg',
    'assets/slider2.jpg',
    // 'assets/slider3.jpg',
  ];

  final List<Payload> favoriteRestaurants = List.generate(
    5,
    (i) => Payload(
      restaurantId: 'fav_$i',
      restaurantName: 'Restaurant $i',
      restaurantMenuType: 'VEG',
      ratings: 4.0 + i,
      imageUrl: 'assets/intro_3.png',
      distance: '${i + 1} km',
      duration: '${i + 5} mins',
      favourite: true,
    ),
  );

  final List<Payload> topRatedRestaurants = List.generate(
    5,
    (i) => Payload(
      restaurantId: 'top_$i',
      restaurantName: 'Top Rated $i',
      restaurantMenuType: 'VEG',
      ratings: 4.5 + i,
      imageUrl: 'assets/intro_3.png',
      distance: '${i + 2} km',
      duration: '${i + 4} mins',
      favourite: false,
    ),
  );

  final List<Payload> nearbyRestaurants = List.generate(
    5,
    (i) => Payload(
      restaurantId: 'near_$i',
      restaurantName: 'Nearby $i',
      restaurantMenuType: 'VEG',
      ratings: 3.5 + i,
      imageUrl: 'assets/intro_3.png',
      distance: '${i + 1} km',
      duration: '${i + 3} mins',
      favourite: i % 2 == 0,
    ),
  );

  @override
  void initState() {
    super.initState();
    fetchUserLocation();
  }

  Future<void> fetchUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('user_latitude') ?? 0.0;
    double longitude = prefs.getDouble('user_longitude') ?? 0.0;

    if (latitude != 0.0 && longitude != 0.0) {
      await getAddressFromLatLng(latitude, longitude);
    }
  }

  Future<void> getAddressFromLatLng(double lat, double lng) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          setState(() {
            currentLocation = data['results'][0]['formatted_address'];
          });
        }
      } else {
        print("Failed to get address: ${response.body}");
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  void _onItemTapped(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';
    if (userId.isEmpty) {
      _requestSignInDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<bool?> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.exit_to_app_rounded,
                  size: 48,
                  color: Colors.black.withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                Text(
                  'Exit App?',
                  style: AppFonts.subHeader.copyWith(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to exit the app?',
                  textAlign: TextAlign.center,
                  style: AppFonts.smallText.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: AppColors.textColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.appPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Exit',
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final HomeBloc _homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc,
      child: WillPopScope(
        onWillPop: () async {
          final shouldExit = await showExitConfirmationDialog(context);
          return shouldExit ?? false;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: _selectedIndex == 0
              ? AppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 125,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.appPrimaryGradient,
                    ),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.google_place_search);
                            },
                            child: ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons
                                        .keyboard_arrow_down, // iOS-style down arrow
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                currentLocation.isNotEmpty
                                    ? currentLocation
                                    : 'Fetching location...',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const ProfileTab()),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search restaurants...',
                                  prefixIcon: Icon(Icons.search),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null,
          body: SafeArea(
            child: _selectedIndex == 0
                ? ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      // const SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.95, // 90% of screen width
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 200.0,
                                autoPlay: true,
                                viewportFraction: 1.0,
                              ),
                              items: sliderImages.map((imageUrl) {
                                return Image.asset(
                                  imageUrl,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      HorizontalRestaurantSlider(
                        title: 'Nearby Restaurants',
                        restaurants: nearbyRestaurants,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeTab()));
                        },
                      ),
                      SizedBox(height: 25),
                      HorizontalRestaurantSlider(
                        title: 'Top Rated Restaurants',
                        restaurants: topRatedRestaurants,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestaurantMockScreen(
                                        restaurantName: 'Idly Paradise', restaurantId: '', foodType: '', ratings: null, landmark: '', distance: '', duration: '', payload: null,
                                      )));
                        },
                      ),
                      SizedBox(height: 25),
                      HorizontalRestaurantSlider(
                        title: 'Favorite Restaurants',
                        restaurants: favoriteRestaurants,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookmarkScreen()));
                        },
                      ),
                      const SizedBox(height: 80),
                    ],
                  )
                : _tabs[_selectedIndex],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xFFFFB508), // Orange-Yellow
                    Color(0xFFF6D365), // Light Yellow
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _labels.length,
                  (index) => _buildNavBarItem(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index) {
    List<IconData> icons = [
      Icons.home_outlined,
      Icons.receipt_long,
      Icons.alt_route_outlined,
    ];

    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        // decoration: _selectedIndex == index
        //     ? BoxDecoration(
        //         color: Colors.white.withOpacity(0.15),
        //         borderRadius: BorderRadius.circular(12),
        //       )
        //     : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icons[index],
              size: 26,
              color: _selectedIndex == index
                  ? Colors.white
                  : AppColors.bottomTabInactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              _labels[index],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _selectedIndex == index
                    ? Colors.white
                    : AppColors.bottomTabInactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _requestSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                  AppFonts.title.copyWith(color: AppColors.appPrimaryColor),
            ),
            RoundedElevatedButton(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              text: 'Sign In',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.signupScreen,
                  (Route<dynamic> route) => false,
                );
              },
              cornerRadius: 8,
              buttonColor: AppColors.appPrimaryColor,
              textStyle: AppFonts.title.copyWith(color: AppColors.white),
            )
          ],
        );
      },
    );
  }
}
