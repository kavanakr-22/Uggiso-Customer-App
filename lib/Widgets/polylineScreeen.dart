import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uggiso/base/common/utils/colors.dart';

class Polylinescreeen extends StatefulWidget {
  const Polylinescreeen({super.key});

  @override
  State<Polylinescreeen> createState() => _PolylinescreeenState();
}

class _PolylinescreeenState extends State<Polylinescreeen> {
  late GoogleMapController mapController;
  double _originLatitude = 6.5212402, _originLongitude = 3.3679965;
  double _destLatitude = 6.849660, _destLongitude = 3.648190;
  // double _originLatitude = 26.48424, _originLongitude = 50.04551;
  // double _destLatitude = 26.46423, _destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "Please provide your api key";

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(12.9913243,77.7301459), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(13.072170, 77.792221), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(12.9913243,77.7301459), zoom: 12),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: AppColors.textBlue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA',
      request: PolylineRequest(
        origin: PointLatLng(12.9913243,77.7301459),
        destination: PointLatLng(13.072170, 77.792221),
        mode: TravelMode.driving,
        alternatives: true
        // wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      print('this is result : ${result.overviewPolyline}');
    }
    _addPolyLine();
  }
}
