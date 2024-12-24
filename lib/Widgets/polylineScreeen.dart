import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class Polylinescreeen extends StatefulWidget {
  const Polylinescreeen({super.key});

  @override
  State<Polylinescreeen> createState() => _PolylinescreeenState();
}

class _PolylinescreeenState extends State<Polylinescreeen> {
  late GoogleMapController mapController;
  double _originLatitude = 12.9913243, _originLongitude = 77.7301459;
  double _destLatitude = 13.072170, _destLongitude = 77.792221;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  String googleApiKey = "AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA";
  PolylineId? shortestPolylineId;

  @override
  void initState() {
    super.initState();

    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));

    _getPolylines();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          initialCameraPosition:
          CameraPosition(target: LatLng(_originLatitude, _originLongitude), zoom: 12),
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

  _addPolyLine(List<LatLng> polylineCoordinates, int index, bool isShortest) {
    // Ensure polyline starts and ends at origin and destination
    polylineCoordinates.insert(0, LatLng(_originLatitude, _originLongitude));
    polylineCoordinates.add(LatLng(_destLatitude, _destLongitude));

    PolylineId id = PolylineId("polyline_$index");
    Polyline polyline = Polyline(
      polylineId: id,
      color: isShortest ? Colors.blue : Colors.grey,
      points: polylineCoordinates,
      width: 5,
      onTap: () {
        print('Polyline tapped: $id'); // Debug log
        _onPolylineTapped(id);
      },
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolylines() async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$_originLatitude,$_originLongitude&destination=$_destLatitude,$_destLongitude&alternatives=true&key=$googleApiKey';

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

          // Add polyline with appropriate color
          bool isShortest = index == shortestIndex;
          _addPolyLine(polylineCoordinates, index, isShortest);

          index++;
        }
      } else {
        print('Error: ${data['status']} - ${data['error_message']}');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
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
    print('Polyline tapped: $polylineId'); // Debug log
    // Handle polyline tap if needed
  }
}
