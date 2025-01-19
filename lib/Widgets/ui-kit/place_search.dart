import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/colors.dart';

class PlaceSearchScreen extends StatefulWidget {
  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final String apiKey = 'AIzaSyB8UoTxemF5no_Va1aJn4x8s10VsFlLQHA';
  final Location location = Location();
  LocationData? _currentLocation;
  String? _currentAddress;

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _predictions = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (await location.serviceEnabled() || await location.requestService()) {
        final permission = await location.requestPermission();
        if (permission == PermissionStatus.granted) {
          _currentLocation = await location.getLocation();
          _getAddressFromLatLng(
              _currentLocation!.latitude!, _currentLocation!.longitude!);
        }
      }
    } catch (e) {
      print("Error fetching current location: $e");
    }
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
            _currentAddress = data['results'][0]['formatted_address'];
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

  Future<void> _fetchPredictions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _predictions.clear();
      });
      return;
    }

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _predictions = data['predictions'];
        });
      } else {
        print("Error fetching predictions: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];
        print("Place Details:");
        print("Latitude: ${location['lat']}, Longitude: ${location['lng']}");
        setLatLng(location['lat'].toString(),location['lng'].toString());
      } else {
        print("Failed to fetch place details: ${response.body}");
      }
    } catch (e) {
      print("Error fetching place details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Search"),
        backgroundColor: AppColors.appPrimaryColor,
        leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 12),
            child: IconButton(
              iconSize: 12,
              icon: Image.asset('assets/ic_back_arrow.png'),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search places...",
                focusColor: AppColors.appPrimaryColor,
                border: OutlineInputBorder(
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _predictions.clear();
                    });
                  },
                ),
              ),
              onChanged: _fetchPredictions,
            ),
          ),
          ListTile(
            leading: Icon(Icons.my_location),
            title: Text("Current Location"),
            subtitle: Text(
              _currentAddress ?? "Fetching address...",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              if (_currentLocation != null) {
                print("Current Location selected");
              }
            },
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                final prediction = _predictions[index];
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(prediction['description']),
                  onTap: () {
                    print("Selected: ${prediction['description']}");
                    _fetchPlaceDetails(prediction['place_id']);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  setLatLng(String lat, String lng)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('user_longitude', double.parse(lng));
    prefs.setDouble('user_latitude', double.parse(lat));
    print('this is user lng : ${ double.parse(lng)}');
    print('this is user lat : ${ double.parse(lat)}');
    goBack();
  }
  goBack(){
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home_landing_screen, // The new route
          (Route<dynamic> route) => false, // Condition to remove all routes
    );
  }
}
