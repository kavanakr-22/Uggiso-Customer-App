import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Location Permission")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showLocationPermissionDialog(context);
          },
          child: Text("Request Location Permission"),
        ),
      ),
    );
  }

  Future<void> showLocationPermissionDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission Required"),
          content: Text(
              "This app needs location access to track your location even when the app is in the background. Please allow location access to proceed."),
          actions: <Widget>[
            TextButton(
              child: Text("Deny"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Allow"),
              onPressed: () async {
                Navigator.of(context).pop();
                await requestLocationPermission(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    // Request location permission for foreground access
    var status = await Permission.location.request();

    if (status.isGranted) {
      // After foreground permission is granted, ask for background location access
      var backgroundStatus = await Permission.locationAlways.request();
      if (backgroundStatus.isGranted) {
        // Get the current location and show lat/lng
        Position position = await _getCurrentLocation(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Background Location Permission Granted! Lat: ${position.latitude}, Lng: ${position.longitude}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Background Location Permission Denied!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location Permission Denied!")),
      );
    }
  }

  // Function to get the current location using geolocator
  Future<Position> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location services are disabled.")),
      );
      return Future.error('Location services are disabled.');
    }

    // Check for permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permissions are denied.")),
        );
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permissions are permanently denied, we cannot request permissions.")),
      );
      return Future.error('Location permissions are permanently denied');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}

