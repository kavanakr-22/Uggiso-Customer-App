import 'package:flutter/material.dart';
import 'dart:async';
import'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Network/apiProvider.dart';
import 'package:uggiso/base/common/utils/strings.dart';


class Routemapscreen extends StatefulWidget {
  const Routemapscreen({Key? key}) : super(key: key);

  @override
  State<Routemapscreen> createState() => _RoutemapscreenState();
}

class _RoutemapscreenState extends State<Routemapscreen> {

  double latitude = 0.0;
  double longitude = 0.0;
  List<Marker> markers = [];
  static LatLng currLocation = LatLng(12.934730, 77.690483);
  static LatLng destLocation = LatLng(13.072170, 77.792221);
  List<Marker> markers_list = [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(13.072170, 77.792221),
      infoWindow: InfoWindow(
        title: 'current Location'
      )
    )
  ];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late GoogleMapController googleMapController;
  final Completer<GoogleMapController> completer = Completer();

  static final CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(12.934730, 77.690483),
      zoom: 12);

  void onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
    if (!completer.isCompleted) {
      completer.complete(controller);
    }
  }

  addMarker(latLng, newSetState) {
    markers.add(
        Marker(
            consumeTapEvents: true,
            markerId: MarkerId(latLng.toString()),
            position: LatLng(13.072170, 77.792221),
            onTap: () {
              markers.removeWhere((element) =>
              element.markerId == MarkerId(latLng.toString()));
// markers length must be greater than 1 because polyline needs two // points
              if (markers.length > 1) {
                getDirections(markers, newSetState);
              }
// When we added markers then removed all, this time polylines seems //in map because of we should clear polylines
              else {
                polylines.clear();
              }
// newState parameter of function, we are openin map in alertDialog, // contexts are different in page and alert dialog because of we use // different setState
              newSetState(() {});
            }
        ));
    if (markers.length > 1) {
      getDirections(markers, newSetState);
    }
  }

// This functions gets real road polyline routes
  getDirections(List<Marker> markers, newSetState) async {
    List<LatLng> polylineCoordinates = [];
    List<PolylineWayPoint> polylineWayPoints = [];
    for (var i = 0; i < markers.length; i++) {
      polylineWayPoints.add(PolylineWayPoint(
          location: "${markers[i].position.latitude.toString()},${markers[i]
              .position.longitude.toString()}", stopOver: true));
    }
// result gets little bit late as soon as in video, because package // send http request for getting real road routes
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: Strings.google_map_api_key,
        request: PolylineRequest(
          origin: PointLatLng(markers.first.position.latitude,
              markers.first.position.longitude), //first added marker
          destination: PointLatLng(
              markers.last.position.latitude, markers.last.position.longitude),
          mode: TravelMode.driving,
          // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
        ) //GoogleMap ApiKey
      //last added marker
// define travel mode driving for real roads
//       travelMode: TravelMode.driving,
// waypoints is markers that between first and last markers        wayPoints: polylineWayPoints

    );
// Sometimes There is no result for example you can put maker to the // ocean, if results not empty adding to polylineCoordinates
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    newSetState(() {});

    addPolyLine(polylineCoordinates, newSetState);
  }

  addPolyLine(List<LatLng> polylineCoordinates, newSetState) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;

    newSetState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCurrentLocation().then((value){
      print('this is current location value : ${value.latitude} and ${value.longitude}');
    });
    markers.addAll(markers_list);
    getMYCurrentLocation();
    getDirectionsFromMap();
  }
  getDirectionsFromMap() async {
    var res = ApiProvider().getDirections('${currLocation.latitude},${currLocation.longitude}', '${destLocation.latitude},${destLocation.longitude}');
  }

  getMYCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      latitude = prefs.getDouble('user_latitude') ?? 0.0;
      longitude = prefs.getDouble('user_longitude') ?? 0.0;
      // userId = prefs.getString('userId') ?? '';
    });
    print('lat  : $latitude and lng: $longitude');
    markers.add(Marker(markerId: MarkerId('0'),position: LatLng(latitude, longitude)
    ));
    // await getPolyLinePoints();
    // getNearByRestaurants(userId,latitude, longitude, selectedDistance,selectedMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(initialCameraPosition:_cameraPosition,
          mapType: MapType.normal,
          myLocationEnabled: true,
          markers: Set<Marker>.of(markers),
          onMapCreated: (GoogleMapController controller){
          completer.complete(controller);
          },
        )
    );
  }

  Future<Position> getUserCurrentLocation() async{

    await Geolocator.requestPermission().then((value){

    }).onError((error,stackTrace){

      print('Error found : $error');
    });

    return await Geolocator.getCurrentPosition();
  }
}