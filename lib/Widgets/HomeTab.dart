import 'dart:convert';
import 'dart:io';
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
      child: BlocListener<HomeBloc,HomeState>(
        listener: (BuildContext context, HomeState state) {
          if(state is onFavHotelAddedState){
            print('fav hotel added for lat : $latitude and lng : $longitude, for userId : $userId with travelMode: $selectedMode');
          }
          if(state is onFavHotelDeleteState){
            print('this is result : ${state.result}');
            if(state.result=='success'){
              print('this is inside home tab');

              print('fav hotel deleted for lat : $latitude and lng : $longitude, for userId : $userId with travelMode: $selectedMode');

            }
          }
        },
        child: WillPopScope(
          onWillPop: ()=>exit(0),
          child: Scaffold(
            backgroundColor: AppColors.textFieldBg,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                backgroundColor: AppColors.appPrimaryColor,
                elevation: 0,
                centerTitle: false,
                title:  Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                          flex:2,child: locationHeader()),
                      Flexible(
                        flex: 1,
                        child: RoundedContainer(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width*0.25,
                            height: 40,
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

                              menuMaxHeight: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.4,
                              icon:Icon(Icons.keyboard_arrow_down,size: 20,),
                              items: Strings.distance_type.map((double value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text('${value} KM',style: AppFonts.smallText.copyWith(fontWeight: FontWeight.bold),),
                                );
                              }).toList(),
                              onChanged: (double? newValue) {
                                setState(() {
                                  selectedDistance = newValue!;
                                  print('lat lng after change distance : $latitude and $longitude');
                                  getNearByRestaurants(userId,
                                      latitude, longitude, selectedDistance,selectedMode);
                                });
                              },
                            )),
                      ),
                    ],
                  ),
                ),
                // actions: [
                //   IconButton(
                //     onPressed: () {
                //       // Add your action here, e.g., navigate to notifications or settings
                //       Navigator.pushNamed(context, AppRoutes.myOrders);
                //     },
                //     icon: Icon(
                //       Icons.receipt_long, // Replace with your preferred icon
                //       color: AppColors.white,
                //       size: 24, // Adjust size as needed
                //     ),
                //   ),
                // ],
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

            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 8.0),
              child: FloatingActionButton(
                backgroundColor: AppColors.appPrimaryColor,
                onPressed: () {
                  setState(() {
                    if (_isShowMaps) {
                      _isShowMaps = false;
                    } else {
                      _isShowMaps = true;
                    }
                  });
                },
                elevation: 8.0,
                child: _isShowMaps
                    ? const Icon(
                  Icons.location_on,
                  color: AppColors.white,
                  size: 32,
                )
                    : const Icon(
                  Icons.list_alt_rounded,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchWidget(),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (BuildContext context, HomeState state) {
                    if (state is onLoadedHotelState) {
                      print('this is state data : ${state.data.payload}');
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(24),
                            const Text(
                              Strings.near_by_restaurants,
                              style: AppFonts.subHeader,
                            ),
                            const Gap(12),
                            _isShowMaps ? Container(
                              child: HotelListGrid(
                                  state.data.payload,userId,latitude,longitude,selectedMode,selectedDistance),
                            ):GetHotelListinMap(state.data.payload,userId) ,
                          ],
                        ),
                      );
                      // Navigator.pushNamed(context, AppRoutes.verifyOtp);
                    } else if (state is ErrorState) {

                      return Expanded(
                        child: Column(
                          children: [
                            Gap(MediaQuery
                                .of(context)
                                .size
                                .height * 0.2),
                            Icon(Icons.no_food,color: AppColors.rewardsText,size: 86),
                            const Gap(20),
                            Container(
                              child: Center(
                                child: Text(
                                  '${state.message}',
                                  style: AppFonts.title,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is LoadingHotelState) {
                      return const HomeScreen();
                    } else {
                      return Container();
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

  Widget locationHeader()=>
  RoundedContainer(
    width: MediaQuery.of(context).size.width*0.65,
    cornerRadius: 5,
    color: AppColors.white,
    child: InkWell(
      onTap: ()=>Navigator.pushNamed(context, AppRoutes.google_place_search),
      child: Row(
        children: [
         Icon(Icons.location_on_outlined,color: AppColors.black,),
          Expanded(child: Text('$currentLocation',style: AppFonts.smallText,maxLines: 1,overflow: TextOverflow.ellipsis,)),
          Icon(Icons.keyboard_arrow_right,color: AppColors.appPrimaryColor,),
        ],
      ),
    ),
  );

  Widget searchWidget()=>
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.07,
        decoration: BoxDecoration(
          color: AppColors.appPrimaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: InkWell(
          onTap: ()=>Navigator.pushNamed(context, AppRoutes.search_screen),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundedContainer(
                width: MediaQuery.of(context).size.width*0.9,
                height: MediaQuery.of(context).size.height*0.04,
                color: AppColors.white,
                padding: 10,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedPositioned(
                    duration: const Duration(seconds: 1),
                    left: _position,
                    child: Text('Search Restaurant',
                      style: AppFonts.smallText.copyWith(color: AppColors.grey,),
                      textAlign: TextAlign.center,),
                  ),
                ), cornerRadius: 5),
          )
        ),
      );

  Widget HomeHeaderContainer() =>
      Container(
        decoration: const BoxDecoration(
          color: AppColors.appPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 4.0),
          child: Column(
            children: [
              const Gap(12),
              _showPlaceSearchWidget
                  ? PlaceSearchWidget()
                  : RoundedContainer(
                  color: AppColors.white,
                  borderColor: AppColors.white,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05,
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
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.05,
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

                          menuMaxHeight: MediaQuery
                              .of(context)
                              .size
                              .height * 0.4,
                          icon:Icon(Icons.keyboard_arrow_down,size: 20,),
                          items: Strings.distance_type.map((double value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text('${value} KM',style: AppFonts.title,),
                            );
                          }).toList(),
                          onChanged: (double? newValue) {
                            setState(() {
                              selectedDistance = newValue!;
                              getNearByRestaurants(userId,
                                  latitude, longitude, selectedDistance,selectedMode);
                            });
                          },
                        )),
                  ),
                  SizedBox(width: 8,),
                  //
                  // Flexible(
                  //   flex:2,
                  //   child: RoundedContainer(
                  //       width: MediaQuery
                  //           .of(context)
                  //           .size
                  //           .width,
                  //       height: MediaQuery
                  //           .of(context)
                  //           .size
                  //           .height * 0.05,
                  //       color: AppColors.white,
                  //       cornerRadius: 8,
                  //       padding: 0,
                  //       child: DropdownButtonFormField(
                  //         decoration: const InputDecoration(
                  //           contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //           border: InputBorder.none,
                  //         ),
                  //         padding: const EdgeInsets.symmetric(horizontal: 12),
                  //         value: selectedMode,
                  //         menuMaxHeight: MediaQuery
                  //             .of(context)
                  //             .size
                  //             .height * 0.4,
                  //         icon:Icon(Icons.keyboard_arrow_down,size: 20,),
                  //         items: Strings.travel_mode.map((String value) {
                  //           return DropdownMenuItem(
                  //             value: value,
                  //             child: Text('${value}',style: AppFonts.title,),
                  //           );
                  //         }).toList(),
                  //         onChanged: (String? newValue) {
                  //           setState(() {
                  //             selectedMode = newValue!;
                  //             getNearByRestaurants(userId,
                  //                 latitude, longitude, selectedDistance,selectedMode);
                  //           });
                  //         },
                  //       )),
                  // ),
                  // SizedBox(width: 8,),
                  // Flexible(
                  //   flex: 2,
                  //   child: InkWell(
                  //     onTap: (){
                  //       Navigator.pushNamed(context, AppRoutes.getRouteMap);
                  //     },
                  //     child: RoundedContainer(
                  //         width: MediaQuery
                  //             .of(context)
                  //             .size
                  //             .width,
                  //         height: MediaQuery
                  //             .of(context)
                  //             .size
                  //             .height * 0.05,
                  //         color: AppColors.white,
                  //         cornerRadius: 8,
                  //         padding: 0,
                  //         child:Center(child: const Text('My Route', style: AppFonts.title,))),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );

  getUserCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    // final List<Object?> result = await platform.invokeMethod('callSabPaisaSdk',
    //     ['TIlak', "", "", '9964367047', '100']);
    // print('this is the transaction result : $result');
    // print('this is the transaction result status: ${result[0].toString()}');
    // print('this is the transaction result txnId: ${result[1].toString()}');
    //
    // String txnStatus = result[0].toString();
    // setState(() {
    //   txnId = result[1].toString();
    // });
    setState(() {
      latitude = prefs.getDouble('user_latitude') ?? 0.0;
      longitude = prefs.getDouble('user_longitude') ?? 0.0;
      userId = prefs.getString('userId') ?? '';
      print('received user lat lng :$latitude and $longitude');

    });
    _getAddressFromLatLng(latitude,longitude);
    getNearByRestaurants(userId,latitude, longitude, selectedDistance,selectedMode);
  }

  getNearByRestaurants(String userId,double lat, double lng, double distance,String mode) {
    print('userId : $userId');
    _homeBloc.add(
        OnInitilised(userId:userId,lat: lat, lag: lng, distance: distance,mode: mode));
  }

  Widget PlaceSearchWidget() =>
      RoundedContainer(
        color: AppColors.white,
        borderColor: AppColors.white,
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.05,
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
                      _placeSearchEditingController.text = prediction.description!;
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

                    getNearByRestaurants(userId,double.parse(prediction.lat.toString()), double.parse(prediction.lng.toString()), selectedDistance,selectedMode);
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
