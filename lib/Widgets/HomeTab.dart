import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_search_place/google_search_place.dart';
import 'package:google_search_place/model/prediction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeBloc.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeEvent.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeState.dart';
import 'package:uggiso/Widgets/Shimmer/HomeScreen.dart';
import 'package:uggiso/Widgets/ui-kit/HotelListGrid.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/base/common/utils/GetHotelListinMap.dart';
import 'package:uggiso/base/common/utils/MenuListArgs.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import '../app_routes.dart';
import '../base/common/utils/fonts.dart';
import '../base/common/utils/strings.dart';
import 'package:http/http.dart' as http;

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final HomeBloc _homeBloc = HomeBloc();
  double latitude = 0.0;
  double longitude = 0.0;
  double selectedDistance = 5.0;
  double selectedRatings = 0.0;
  String selectedMode = "BIKE";
  String userId = '';
  bool _isShowMaps = true;
  bool _showPlaceSearchWidget = false;
  String currentLocation = 'Current Location';
  TextEditingController userlocationController = TextEditingController();
  TextEditingController userDistanceController = TextEditingController();
  TextEditingController _placeSearchEditingController = TextEditingController();
  String txnId = '';
  final String apiKey = 'AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA';
  double _position = 0;
  // int _selectedIndex = 0;
  //
  // final List<Widget> _pages = [
  //   const HomeTab(), // Home tab content
  //   const OrdersTab(), // Orders tab content
  //   const ProfileTab(), // Profile tab content
  // ];
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCurrentLocation();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _position = 100; // Move text to the right
        });
      }
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        if (!isLoadingMore && hasMoreData) {
          fetchMoreRestaurants();
        }
      }
    });
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          setState(() {
            currentLocation = data['results'][0]['formatted_address'];
          });
        } else {
          print("No address found for the coordinates.");
        }
      } else {
        print("Error fetching address: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc,
      child: BlocListener<HomeBloc, HomeState>(
        listener: (BuildContext context, HomeState state) {
          if (state is onFavHotelAddedState) {
            print(
                'fav hotel added for lat : $latitude and lng : $longitude, for userId : $userId with travelMode: $selectedMode');
          }
          if (state is onFavHotelDeleteState) {
            print('this is result : ${state.result}');
            if (state.result == 'success') {
              print('this is inside home tab');

              print(
                  'fav hotel deleted for lat : $latitude and lng : $longitude, for userId : $userId with travelMode: $selectedMode');
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.textFieldBg,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              centerTitle: false,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.appPrimaryGradient,
                ),
              ),
              title: Row(
                children: [
                  /// iOS-style back arrow
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.black, // You can adjust this color
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// Search bar
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Restaurants...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: 1,
          //   // onTap: _onItemTapped,
          //   selectedItemColor: AppColors.appPrimaryColor,
          //   unselectedItemColor: Colors.grey,
          //   items: const [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.home),
          //       label: 'Home',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.receipt_long),
          //       label: 'Orders',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.person),
          //       label: 'Profile',
          //     ),
          //   ],
          // ),

          // floatingActionButton: Padding(
          //   padding:
          //       const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
          //   child: FloatingActionButton(
          //     backgroundColor: AppColors.appPrimaryColor,
          //     onPressed: () {
          //       setState(() {
          //         if (_isShowMaps) {
          //           _isShowMaps = false;
          //         } else {
          //           _isShowMaps = true;
          //         }
          //       });
          //     },
          //     elevation: 8.0,
          //     child: _isShowMaps
          //         ? const Icon(
          //             Icons.location_on,
          //             color: AppColors.white,
          //             size: 32,
          //           )
          //         : const Icon(
          //             Icons.list_alt_rounded,
          //             color: AppColors.white,
          //             size: 32,
          //           ),
          //   ),
          // ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // searchWidget(),
                // BlocBuilder<HomeBloc, HomeState>(
                //   builder: (BuildContext context, HomeState state) {
                //     if (state is onLoadedHotelState) {
                //       print('this is state data : ${state.data.payload}');
                //       return Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             const Gap(12),
                //             _isShowMaps
                //                 ? Container(
                //                     child: HotelListGrid(
                //                         state.data.payload,
                //                         userId,
                //                         latitude,
                //                         longitude,
                //                         selectedMode,
                //                         selectedDistance),
                //                   )
                //                 : GetHotelListinMap(
                //                     state.data.payload, userId),
                //           ],
                //         ),
                //       );
                //       // Navigator.pushNamed(context, AppRoutes.verifyOtp);
                //     } else if (state is ErrorState) {
                //       return Column(
                //         children: [
                //           Gap(MediaQuery.of(context).size.height * 0.2),
                //           Icon(Icons.no_food,
                //               color: AppColors.rewardsText.withOpacity(0.4),
                //               size: 86),
                //           const Gap(20),
                //           Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Center(
                //               child: Text(
                //                 'We\'re currently unavailable in your location, but we\'re expanding fast! Stay tuned—we\'ll be reaching your area very soon!',
                //                 style: AppFonts.header1.copyWith(
                //                     color:
                //                         AppColors.textGrey.withOpacity(0.4)),
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //           ),
                //         ],
                //       );
                //     } else if (state is LoadingHotelState) {
                //       return const HomeScreen();
                //     } else {
                //       return Container();
                //     }
                //   },
                // ),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (BuildContext context, HomeState state) {
                    if (state is FetchedMoreState) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        isLoadingMore = false;
                        hasMoreData = state.hasMore;
                      });

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(12),
                            _isShowMaps
                                ? HotelListGrid(
                                    state.updatedRestaurants,
                                    userId,
                                    latitude,
                                    longitude,
                                    selectedMode,
                                    selectedDistance,
                                    selectedRatings,
                                    scrollController: _scrollController,
                                  )
                                : GetHotelListinMap(
                                    state.updatedRestaurants, userId),
                            if (isLoadingMore && hasMoreData)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: HomeScreen(),
                              ),
                          ],
                        ),
                      );
                    } else if (state is PaginationErrorState) {
                      return Column(
                        children: [
                          Gap(MediaQuery.of(context).size.height * 0.2),
                          Icon(Icons.no_food,
                              color: AppColors.rewardsText.withOpacity(0.4),
                              size: 86),
                          const Gap(20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'We\'re currently unavailable in your location, but we\'re expanding fast! Stay tuned—we\'ll be reaching your area very soon!',
                                style: AppFonts.header1.copyWith(
                                  color: AppColors.textGrey.withOpacity(0.4),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is FetchingMoreState &&
                        _currentPage == 1) {
                      return const HomeScreen(); // initial shimmer
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget locationHeader() => RoundedContainer(
        width: MediaQuery.of(context).size.width * 0.91,
        cornerRadius: 5,
        color: AppColors.white,
        child: InkWell(
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.google_place_search),
          child: Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.black,
              ),
              Expanded(
                  child: Text(
                '$currentLocation',
                style: AppFonts.smallText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
              Icon(
                Icons.keyboard_arrow_right,
                color: AppColors.appPrimaryColor,
              ),
            ],
          ),
        ),
      );

  Widget searchWidget() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07,
        decoration: BoxDecoration(
          // color: AppColors.appPrimaryColor,
          gradient: AppColors.appPrimaryGradient,
          borderRadius: const BorderRadius.only(
              // bottomLeft: Radius.circular(20),
              // bottomRight: Radius.circular(20),
              ),
        ),
        child: InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search_screen,
                arguments: RestaurantSearchArgs(
                    lat: latitude, lag: longitude, userId: userId)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RoundedContainer(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.04,
                  color: AppColors.white,
                  padding: 10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Search Restaurant',
                      style: AppFonts.smallText.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  cornerRadius: 5),
            )),
      );

  Widget HomeHeaderContainer() => Container(
        decoration: const BoxDecoration(
          color: AppColors.appPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
          child: Column(
            children: [
              const Gap(12),
              _showPlaceSearchWidget
                  ? PlaceSearchWidget()
                  : RoundedContainer(
                      color: AppColors.white,
                      borderColor: AppColors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.05,
                      cornerRadius: 8,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              '$currentLocation',
                              style: AppFonts.title,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _showPlaceSearchWidget = true;
                              });
                            },
                            child: Text(
                              'Change',
                              style: AppFonts.smallText
                                  .copyWith(color: AppColors.appPrimaryColor),
                            ),
                          ),
                        ],
                      )),
              const Gap(12),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: RoundedContainer(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        color: AppColors.white,
                        cornerRadius: 8,
                        padding: 0,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            border: InputBorder.none,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          value: selectedDistance,
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.4,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                          ),
                          items: Strings.distance_type.map((double value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                '${value} KM',
                                style: AppFonts.title,
                              ),
                            );
                          }).toList(),
                          onChanged: (double? newValue) {
                            setState(() {
                              selectedDistance = newValue!;
                              getNearByRestaurants(userId, latitude, longitude,
                                  selectedDistance, selectedMode);
                            });
                          },
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  getUserCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      latitude = prefs.getDouble('user_latitude') ?? 0.0;
      longitude = prefs.getDouble('user_longitude') ?? 0.0;
      userId = prefs.getString('userId') ?? '';
      print('received user lat lng :$latitude and $longitude');
    });
    _getAddressFromLatLng(latitude, longitude);
    getNearByRestaurants(
        userId, latitude, longitude, selectedDistance, selectedMode);
  }

  getNearByRestaurants(
      String userId, double lat, double lng, double distance, String mode) {
    _currentPage = 0;
    hasMoreData = true;
    _homeBloc.add(OnFetchMoreRestaurants(
      userId: userId,
      lat: lat,
      lag: lng,
      distance: distance,
      mode: mode,
      page: _currentPage,
      size: 10,
    ));
  }

  // + Fetch More Method
  void fetchMoreRestaurants() {
    if (isLoadingMore || !hasMoreData) return; // ✅ Prevent duplicate fetches

    setState(() {
      isLoadingMore = true; // ✅ Mark as loading
    });

    _currentPage++;

    _homeBloc.add(OnFetchMoreRestaurants(
      userId: userId,
      lat: latitude,
      lag: longitude,
      distance: selectedDistance,
      mode: selectedMode,
      page: _currentPage,
      size: 10, // ✅ Keep as 10 or change to 20 if needed
    ));
  }

  Widget PlaceSearchWidget() => RoundedContainer(
        color: AppColors.white,
        borderColor: AppColors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.05,
        cornerRadius: 8,
        padding: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: SearchPlaceAutoCompletedTextField(
                  googleAPIKey: apiKey,
                  textStyle: AppFonts.title,
                  countries: ['in'],
                  isLatLngRequired: true,
                  inputDecoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // No border
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  controller: _placeSearchEditingController,
                  itmOnTap: (Prediction prediction) {
                    setState(() {
                      _placeSearchEditingController.text =
                          prediction.description!;
                      currentLocation = _placeSearchEditingController.text;
                      _showPlaceSearchWidget = false;
                    });

                    _placeSearchEditingController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: prediction.description?.length ?? 0));
                  },
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    _placeSearchEditingController.text =
                        prediction.description ?? "";

                    _placeSearchEditingController.selection =
                        TextSelection.fromPosition(TextPosition(
                            offset: prediction.description?.length ?? 0));

                    // Get search place latitude and longitude
                    debugPrint("====>${prediction.lat} ${prediction.lng}");

                    getNearByRestaurants(
                        userId,
                        double.parse(prediction.lat.toString()),
                        double.parse(prediction.lng.toString()),
                        selectedDistance,
                        selectedMode);
                    // Get place Detail
                    debugPrint("Place Detail : ${prediction.placeDetails}");
                  }),
            ),
            Flexible(
                flex: 1,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 12,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPlaceSearchWidget = false;
                      _placeSearchEditingController.clear();
                    });
                  },
                ))
          ],
        ),
      );
}
