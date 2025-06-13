import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_polyline/google_maps_polyline.dart';
import 'package:google_search_place/google_search_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeBloc.dart';
import 'package:uggiso/Bloc/HomeBloc/HomeState.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/MenuListArgs.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:google_search_place/model/prediction.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:ui' as ui;
import '../../../Bloc/HomeBloc/HomeEvent.dart';

class GetRouteMap extends StatefulWidget {
  const GetRouteMap({super.key});

  @override
  State<GetRouteMap> createState() => _GetRouteMapState();
}

class _GetRouteMapState extends State<GetRouteMap> {
  TextEditingController departureController = new TextEditingController();
  TextEditingController arrivalController = new TextEditingController();

  TextEditingController _placeSearchEditingController = TextEditingController();
  bool _showPlaceSearchWidget = false;
  String currentLocation = 'Current Location';
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  List<Marker> markersList = [];
  GoogleMapsPolyline googleMapPolyline = GoogleMapsPolyline();
  final List<Polyline> polyline = [];
  List<LatLng> routeCoords = [];
  double latitude = 0.0;
  double longitude = 0.0;
  String userId = '';
  PolylineId? selectedPolylineId; // Tracks the currently blue polyline
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  String googleApiKey = "AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA";
  PolylineId? shortestPolylineId;
  HomeBloc _homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appPrimaryColor,
          title: Text(
            Strings.by_route,
            style: AppFonts.appBarText.copyWith(color: AppColors.white),
          ),
          centerTitle: false,
        ),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (BuildContext context, HomeState state) {
            if (state is RestaurantsLocationFound) {
              print(
                  'this is result payload length from my route: ${state.result.payload?.length}');
              print(
                  'this is result payload lat lng : ${state.result.payload?.first.lat} and ${state.result.payload?.first.lng}');

              for (int i = 0; i < state.result.payload!.length; i++) {
                addRestaurantMarker(
                    state.result.payload?[i].lat,
                    state.result.payload?[i].lng,
                    state.result.payload?[i].restaurantName,
                    state.result.payload?[i]);
                // _setMarkers(state.result.payload);
              }
            }
            // addRestaurantMarker(12.9444567,77.7495071);
            // addRestaurantMarker(12.9444489,77.7495071);
          },
          child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, HomeState state) {
                if (state is LoadingHotelState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                    ),
                  );
                }
                return Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                          target: LatLng(latitude, longitude), zoom: 8),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: _onMapCreated,
                      markers: Set<Marker>.of(markers.values),
                      polylines: Set<Polyline>.of(polylines.values),
                    ),
                    HomeHeaderContainer(),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Future<BitmapDescriptor> _getCustomIcon(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 100);
    final ui.FrameInfo fi = await codec.getNextFrame();

    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    if (latitude != 0.0 && longitude != 0.0) {
      _moveCameraToCurrentLocation();
    }
  }

  void _moveCameraToCurrentLocation() {
    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 13),
      );
    }
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor,
      Payload? payload) {
    print(
        'this is add marker lat lng : ${position.latitude} and ${position.longitude}');
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      onTap: () => print('this is on marker tap with marker id : ${markerId}'),
      infoWindow: InfoWindow(
          snippet: markerId.value,
          title: markerId.value,
          onTap: () => {
            print('this is on marker tap inside info window'),
            if(payload!=null){
              Navigator.pushNamed(context, AppRoutes.menuList,
                  arguments: MenuListArgs(

                      restaurantId: payload.restaurantId,
                      name: payload.restaurantName,
                      foodType: payload.restaurantMenuType,
                      ratings: payload.ratings,
                      landmark: payload.landmark,
                      distance: payload.distance,
                      duration: payload.duration,
                      payload: payload))
            }
          }),
    );
    markers[markerId] = marker;
  }

  // _getPolylines(double lat, double lng, double destLat, double destLng) async {
  //   print('this is getPolylines lat lng : $lat and $lng');
  //   print('this is getPolylines destinationlat lng : $destLat and $destLng');
  //
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$lng&destination=$destLat,$destLng&alternatives=true&key=$googleApiKey&polylineQuality=highQuality&polylineEncoding=encoded';
  //
  //   print('this is direction api url : $url');
  //
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //
  //     if (data['status'] == 'OK') {
  //       double shortestDistance = double.infinity;
  //       int shortestIndex = 0;
  //       List<LatLng> shortestRoute = [];
  //       int index = 0;
  //       for (var route in data['routes']) {
  //         List<LatLng> polylineCoordinates = [];
  //         var points = PolylinePoints()
  //             .decodePolyline(route['overview_polyline']['points']);
  //         points.forEach((point) {
  //           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //         });
  //
  //         // Calculate distance
  //         double distance = _calculateDistance(polylineCoordinates);
  //
  //         // Determine if this route is the shortest
  //         if (distance < shortestDistance) {
  //           shortestDistance = distance;
  //           shortestRoute = polylineCoordinates;
  //           shortestIndex = index;
  //         }
  //         //
  //         // if (data['routes'].length > 0) {
  //         //   bool isShortest = index == data['routes'].length - 1;
  //         //   _addPolyLine(
  //         //       polylineCoordinates, index, isShortest, destLat, destLng);
  //         // }
  //         index++;
  //       }
  //       // Add only the shortest route to the map
  //       if (shortestRoute.isNotEmpty) {
  //         _addPolyLine(shortestRoute, shortestIndex, true, destLat, destLng);
  //       }
  //       print('calling api resp :');
  //       _homeBloc.add(OnGetRestaurantByRoute(
  //           userId: userId,
  //           polylinePoints: data['routes'][0]['overview_polyline']['points']
  //               .toString()
  //               .replaceAll(r'\', r'\\'),
  //           originLat: lat,
  //           originLng: lng));
  //     } else {
  //       print('Error: ${data['status']} - ${data['error_message']}');
  //     }
  //   } else {
  //     print('Request failed with status: ${response.statusCode}');
  //   }
  // }

  _getPolylines(double lat, double lng, double destLat, double destLng) async {
    print('Fetching routes from lat: $lat, lng: $lng to destLat: $destLat, destLng: $destLng');

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$lng&destination=$destLat,$destLng&alternatives=true&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        polylines.clear();

        int index = 0;
        double shortestDistance = double.infinity;
        int shortestIndex = 0;
        List<LatLng> shortestRoute = [];

        for (var route in data['routes']) {
          List<LatLng> polylineCoordinates = [];
          var points = PolylinePoints().decodePolyline(route['overview_polyline']['points']);

          for (var point in points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          double distance = _calculateDistance(polylineCoordinates);
          if (distance < shortestDistance) {
            shortestDistance = distance;
            shortestRoute = polylineCoordinates;
            shortestIndex = index;
          }

          index++;
        }

        // Now add polylines with the shortest one highlighted
        index = 0;
        for (var route in data['routes']) {
          List<LatLng> polylineCoordinates = [];
          var points = PolylinePoints().decodePolyline(route['overview_polyline']['points']);

          for (var point in points) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
          bool hasNext = (index + 1) < data['routes'].length;
          // bool isShortest = index == shortestIndex;
          _addPolyLine(polylineCoordinates, index, hasNext);
          index++;
        }

        setState(() {});

        _homeBloc.add(OnGetRestaurantByRoute(
                      userId: userId,
                      polylinePoints: data['routes'][0]['overview_polyline']['points']
                          .toString()
                          .replaceAll(r'\', r'\\'),
                      originLat: lat,
                      originLng: lng));
      } else {
        print('Error: ${data['status']} - ${data['error_message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }


  List<LatLng> _offsetCoordinates(List<LatLng> coordinates, double offset) {
    List<LatLng> offsetCoordinates = [];

    for (int i = 0; i < coordinates.length; i++) {
      double latOffset = (i.isEven ? offset : -offset);
      double lngOffset = (i.isOdd ? offset : -offset);

      offsetCoordinates.add(
        LatLng(
          coordinates[i].latitude + latOffset,
          coordinates[i].longitude + lngOffset,
        ),
      );
    }
    return offsetCoordinates;
  }

  _addPolyLine(List<LatLng> polylineCoordinates, int index, bool hasNext) {
    PolylineId id = PolylineId("polyline_$index");

    Color routeColor = hasNext? Colors.grey : Colors.blue;

    Polyline polyline = Polyline(
      polylineId: id,
      color: routeColor,
      points: polylineCoordinates,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      consumeTapEvents: true,
      onTap: () => _onPolylineTapped(id),
    );

    polylines[id] = polyline;

    // Ensure the last polyline is always blue
    selectedPolylineId = id;

    setState(() {
    });
  }



  // _addPolyLine(List<LatLng> polylineCoordinates, int index, bool isShortest,
  //     double destLat, double destLng) {
  //   // Ensure polyline starts and ends at origin and destination
  //   if (!isShortest) {
  //     polylineCoordinates = _offsetCoordinates(polylineCoordinates);
  //   }
  //   // polylineCoordinates.insert(0, LatLng(latitude, longitude));
  //   polylineCoordinates.add(LatLng(destLat, destLng));
  //
  //   PolylineId id = PolylineId("polyline_$index");
  //   Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: isShortest ? Colors.blue : Colors.grey,
  //       points: polylineCoordinates,
  //       width: 5,
  //       onTap: () {
  //         _onPolylineTapped(id);
  //       },
  //       consumeTapEvents: true);
  //   polylines[id] = polyline;
  //   setState(() {});
  // }

  double _calculateDistance(List<LatLng> coordinates) {
    double distance = 0.0;
    for (int i = 0; i < coordinates.length - 1; i++) {
      distance += _distanceBetween(
        coordinates[i].latitude,
        coordinates[i].longitude,
        coordinates[i + 1].latitude,
        coordinates[i + 1].longitude,
      );
    }
    return distance;
  }

  double _distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    const double pi = 3.1415926535897932;
    const double R = 6371000; // Radius of Earth in meters
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;
    double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        (math.cos(lat1 * pi / 180) *
            math.cos(lat2 * pi / 180) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  void _onPolylineTapped(PolylineId polylineId) {
    if (selectedPolylineId == polylineId) return;

    setState(() {
      // Change all to grey first
      polylines.updateAll((id, polyline) => polyline.copyWith(
        colorParam: Colors.grey,
        widthParam: 5,
        zIndexParam: 1,
      ));

      // Move the tapped polyline to the last index by recreating the list
      if (polylines.containsKey(polylineId)) {
        final tappedPolyline = polylines[polylineId]!;
        polylines.remove(polylineId);
        polylines[polylineId] = tappedPolyline.copyWith(
          colorParam: Colors.blue,
          widthParam: 5,
          zIndexParam: 2,
        );
      }

      // Highlight the last one as blue
      final lastPolylineId = polylines.keys.last;
      if (polylines.containsKey(lastPolylineId)) {
        polylines[lastPolylineId] = polylines[lastPolylineId]!.copyWith(
          colorParam: Colors.blue,
          widthParam: 5,
          zIndexParam: 2,
        );
      }

      selectedPolylineId = polylineId;
    });
  }



  // void _onPolylineTapped(PolylineId polylineId) {
  //   print('Polyline tapped: $polylineId');
  //
  //   // If the tapped polyline is already the selected one, return
  //   if (selectedPolylineId == polylineId) return;
  //
  //   // Change the previous selected polyline (blue) to grey
  //   if (selectedPolylineId != null) {
  //     setState(() {
  //       polylines[selectedPolylineId!] =
  //           polylines[selectedPolylineId!]!.copyWith(
  //             colorParam: Colors.grey,
  //           );
  //     });
  //   }
  //
  //   // Set the tapped polyline to blue
  //   setState(() {
  //     polylines[polylineId] = polylines[polylineId]!.copyWith(
  //       colorParam: Colors.blue,
  //     );
  //     selectedPolylineId = polylineId; // Update the selected polyline
  //   });
  // }

  Widget HomeHeaderContainer() => Container(
    height: MediaQuery.of(context).size.height * 0.16,
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
      color: AppColors.appPrimaryColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Gap(12),
          RoundedContainer(
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
                ],
              )),
          Gap(8),
          PlaceSearchWidget()
        ],
      ),
    ),
  );

  Widget PlaceSearchWidget() => RoundedContainer(
    color: AppColors.white,
    borderColor: AppColors.white,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.06,
    cornerRadius: 8,
    padding: 0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.search,
            size: 18,
            color: AppColors.textGrey,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.69,
          padding: EdgeInsets.zero,
          child: SearchPlaceAutoCompletedTextField(
              googleAPIKey: googleApiKey,
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

                  // currentLocation = _placeSearchEditingController.text;
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
                addDestinationMarker(double.parse(prediction.lat!),
                    double.parse(prediction.lng!));
                _getPolylines(
                    latitude,
                    longitude,
                    double.parse(prediction.lat!),
                    double.parse(prediction.lng!));
              }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _showPlaceSearchWidget = false;
                _placeSearchEditingController.clear();
              });
            },
            child: Icon(
              Icons.close,
              size: 18,
              color: AppColors.textGrey,
            ),
          ),
        ),
        // IconButton(
        //   padding: EdgeInsets.zero,
        //   icon: const
        //   onPressed: () {
        //
        //   },
        // )
      ],
    ),
  );

  getUserCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getDouble('user_latitude') ?? 0.0;
      longitude = prefs.getDouble('user_longitude') ?? 0.0;
      userId = prefs.getString('userId') ?? '';
    });
    print('lat  : $latitude and lng: $longitude');
  }

  addDestinationMarker(double lat, double lng) {
    _addMarker(
        LatLng(lat, lng), "destination", BitmapDescriptor.defaultMarker, null);
  }

  addRestaurantMarker(double? hotel_lat, double? hotel_lng,
      String? restaurant_name, Payload? payload) {
    _addMarker(
        LatLng(hotel_lat!, hotel_lng!),
        restaurant_name!,
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        payload);
  }

  void _setMarkers(List<Payload>? payload) {
    if (payload != null) {
      setState(() {
        _markers = payload.map((restaurant) {
          print(
              'this is restaurant lat lng : ${restaurant.lat} and ${restaurant.lng}');
          return Marker(
            markerId: MarkerId(restaurant.restaurantName!),
            position: LatLng(restaurant.lat!, restaurant.lng!),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange),
            infoWindow: InfoWindow(
                title: restaurant.restaurantName!,
                onTap: () => print('info window clicked')
              // Navigator.pushNamed(context, AppRoutes.menuList,
              //     arguments: MenuListArgs(
              //         restaurantId: restaurant.restaurantId,
              //         name: restaurant.restaurantName,
              //         foodType: restaurant.restaurantMenuType,
              //         ratings: restaurant.ratings,
              //         landmark: restaurant.landmark,
              //         distance: restaurant.distance,
              //         duration: restaurant.duration,
              //         payload: restaurant))
            ),
          );
        }).toSet();
      });
    }
  }
}