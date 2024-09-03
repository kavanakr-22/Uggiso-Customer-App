import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_polyline/google_maps_polyline.dart';
import 'package:google_search_place/google_search_place.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:google_search_place/model/prediction.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:uggiso/base/common/utils/strings.dart';


class GetRouteMap extends StatefulWidget {
  const GetRouteMap({super.key});

  @override
  State<GetRouteMap> createState() => _GetRouteMapState();
}

class _GetRouteMapState extends State<GetRouteMap> {
  TextEditingController departureController = new TextEditingController();
  TextEditingController arrivalController = new TextEditingController();
  Completer<GoogleMapController> mapController = Completer();

  TextEditingController _placeSearchEditingController = TextEditingController();
  bool _showPlaceSearchWidget = false;
  String currentLocation = 'Current Location';
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  List<Marker> markersList = [];
  GoogleMapsPolyline googleMapPolyline =  GoogleMapsPolyline();
  final List<Polyline> polyline = [];
  List<LatLng> routeCoords = [];
  static LatLng currLocation = LatLng(12.934730, 77.690483);
  static LatLng destLocation = LatLng(13.072170, 77.792221);
  double latitude = 0.0;
  double longitude = 0.0;
  String userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCurrentLocation();
    drawPolylines();
    // getPolyLinePoints();
  }
  drawPolylines()async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA',
      request: PolylineRequest(
        origin: PointLatLng(12.9913243,77.7301459),
        destination: PointLatLng(13.072170, 77.792221),
        mode: TravelMode.driving,
        // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );
    print('this is polyline points : ${result.points}');
    List<PointLatLng> decodeResult = polylinePoints.decodePolyline("_p~iF~ps|U_ulLnnqC_mqNvxq`@");
    print('this is decoded polyline result : ${decodeResult}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        title: Text('By Route',style: TextStyle(color: AppColors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          HomeHeaderContainer(),
      Expanded(
        child: Container(height:MediaQuery.of(context).size.height*0.62,
          child: GoogleMap(
            onMapCreated: (controller) {
              _controller = controller;
            },

            initialCameraPosition:  CameraPosition(
              target: LatLng(12.9913243,77.7301459),
              zoom: 10,
            ),
            markers: {
              Marker(markerId: MarkerId('Current Location'),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(latitude, longitude)
              ),
              Marker(markerId: MarkerId('Dest Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  position: destLocation
              ),
            },
            polylines: Set.from(polyline),
          ),
        ),
      )
        ],
      ),

    );
  }

  Widget HomeHeaderContainer() =>
      Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.16,
        width: MediaQuery
            .of(context)
            .size
            .width,
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
          Gap(8),
          PlaceSearchWidget()

          ],
        ),
      )

  ,

  );

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
                  googleAPIKey: 'AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA',
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

                    // getNearByRestaurants(userId,double.parse(prediction.lat.toString()), double.parse(prediction.lng.toString()), selectedDistance,selectedMode);
                    // Get place Detail
                    debugPrint("Place Detail : ${prediction.placeDetails}");
                  }),
            ),
            Flexible(
                flex: 1,
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 22,
                    color: AppColors.textGrey,
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

  getUserCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getDouble('user_latitude') ?? 0.0;
      longitude = prefs.getDouble('user_longitude') ?? 0.0;
      userId = prefs.getString('userId') ?? '';
    });
    print('lat  : $latitude and lng: $longitude');
    // await getPolyLinePoints();
    // getNearByRestaurants(userId,latitude, longitude, selectedDistance,selectedMode);
  }
  Future<List<LatLng>> getPolyLinePoints() async{

    List<LatLng> polyLineCoOrdinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(googleApiKey: 'AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA',
        request: PolylineRequest(
          origin: PointLatLng(latitude, longitude),
          destination: PointLatLng(destLocation.latitude, destLocation.longitude),
          mode: TravelMode.driving,
          // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        )
    );
    if(polylineResult.points.isNotEmpty){
      polylineResult.points.forEach((PointLatLng point){
        polyLineCoOrdinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        polyline.add(Polyline(
          polylineId: PolylineId('polyline'),
          color: Colors.blue,
          width: 5,
          points: polyLineCoOrdinates,
        ));
      });
    }
    else{
      print('error from Polyline : ${polylineResult.errorMessage}');
    }
    print('this is polyline result : ${polyLineCoOrdinates}');
    return polyLineCoOrdinates;
  }
}
