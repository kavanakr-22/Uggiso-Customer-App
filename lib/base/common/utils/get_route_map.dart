import 'dart:convert';
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
import 'dart:math' as math;
import 'package:http/http.dart' as http;

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
  GoogleMapsPolyline googleMapPolyline =  GoogleMapsPolyline();
  final List<Polyline> polyline = [];
  List<LatLng> routeCoords = [];
  double latitude = 0.0;
  double longitude = 0.0;
  String userId = '';
  PolylineId? selectedPolylineId;  // Tracks the currently blue polyline
  late GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  String googleApiKey = "AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA";
  PolylineId? shortestPolylineId;

  @override
  void initState(){
    super.initState();
     getUserCurrentLocation();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        title: Text('By Route',style: TextStyle(color: AppColors.black),),
        centerTitle: false,
      ),
      body: Stack(
        children: [

      Expanded(
        child: Container(height:MediaQuery.of(context).size.height,
          child: GoogleMap(
            initialCameraPosition:
            CameraPosition(target: LatLng(12.9913243,77.7301459), zoom: 14),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),

        ),
      ),
          HomeHeaderContainer(),
        ],
      ),

    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    print('this is add marker lat lng : ${position.latitude} and ${position.longitude}');
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _getPolylines(double lat, double lng,double destLat,double destLng) async {
    print('this is getPolylines lat lng : $lat and $lng');

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$lat,$lng&destination=$destLat,$destLng&alternatives=true&key=$googleApiKey&polylineQuality=highQuality&polylineEncoding=encoded';

    print('this is direction api url : $url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        double shortestDistance = double.infinity;
        int shortestIndex = 0;

        int index = 0;
        for (var route in data['routes']) {
          List<LatLng> polylineCoordinates = [];
          var points = PolylinePoints().decodePolyline(route['overview_polyline']['points']);
          points.forEach((point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });

          // Calculate distance
          double distance = _calculateDistance(polylineCoordinates);

          // Determine if this route is the shortest
          if (distance < shortestDistance) {
            shortestDistance = distance;
            shortestIndex = index;
          }

          if(data['routes'].length>0){
            bool isShortest = index == data['routes'].length-1;
            _addPolyLine(polylineCoordinates, index, isShortest,destLat,destLng);
          }
          index++;
        }
      } else {
        print('Error: ${data['status']} - ${data['error_message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  List<LatLng> _offsetCoordinates(List<LatLng> coordinates) {
    const double offsetDistance = 0.00005;  // Small offset value (~5 meters)

    List<LatLng> offsetCoordinates = List.from(coordinates);

    if (coordinates.isNotEmpty) {
      // Apply offset to the first (origin) and last (destination) coordinates
      LatLng origin = coordinates.first;
      LatLng destination = coordinates.last;

      // Offset origin by increasing both latitude and longitude
      offsetCoordinates[0] = LatLng(origin.latitude + offsetDistance, origin.longitude + offsetDistance);

      // Offset destination by decreasing both latitude and longitude
      offsetCoordinates[coordinates.length - 1] = LatLng(destination.latitude - offsetDistance, destination.longitude - offsetDistance);
    }

    return offsetCoordinates;
  }
  _addPolyLine(List<LatLng> polylineCoordinates, int index, bool isShortest,double destLat,double destLng ) {
    // Ensure polyline starts and ends at origin and destination
    if (!isShortest) {
      polylineCoordinates = _offsetCoordinates(polylineCoordinates);
    }
    // polylineCoordinates.insert(0, LatLng(latitude, longitude));
    polylineCoordinates.add(LatLng(destLat, destLng));

    PolylineId id = PolylineId("polyline_$index");
    Polyline polyline = Polyline(
      polylineId: id,
      color:isShortest ? Colors.blue : Colors.grey ,
      points: polylineCoordinates,
      width: 5,
      onTap: () {
        _onPolylineTapped(id);

      },
      consumeTapEvents: true
    );
    polylines[id] = polyline;
    setState(() {});
  }

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
        (math.cos(lat1 * pi / 180) * math.cos(lat2 * pi / 180) *
            math.sin(dLon / 2) * math.sin(dLon / 2));
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  void _onPolylineTapped(PolylineId polylineId) {
    print('Polyline tapped: $polylineId');

    // If the tapped polyline is already the selected one, return
    if (selectedPolylineId == polylineId) return;

    // Change the previous selected polyline (blue) to grey
    if (selectedPolylineId != null) {
      setState(() {
        polylines[selectedPolylineId!] = polylines[selectedPolylineId!]!.copyWith(
          colorParam: Colors.grey,
        );
      });
    }

    // Set the tapped polyline to blue
    setState(() {
      polylines[polylineId] = polylines[polylineId]!.copyWith(
        colorParam: Colors.blue,
      );
      selectedPolylineId = polylineId;  // Update the selected polyline
    });
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
                    addDestinationMarker(double.parse(prediction.lat!),double.parse(prediction.lng!));
                    _getPolylines(latitude,longitude,double.parse(prediction.lat!),double.parse(prediction.lng!));
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
    _addMarker(LatLng(latitude, longitude), "origin",
        BitmapDescriptor.defaultMarker);
    addDestinationMarker(latitude, longitude);

    _getPolylines(latitude,longitude,latitude,longitude);
    // getNearByRestaurants(userId,latitude, longitude, selectedDistance,selectedMode);
  }
  addDestinationMarker(double lat, double lng){
    _addMarker(LatLng(lat, lng), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
  }

}
