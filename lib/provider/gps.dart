import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GPS extends ChangeNotifier {
  LatLng fixed, grocery, current;
  bool flag = false;
  int distance;
  Placemark placemark;

  void setFixed({double latitude, double longitude}) {
    fixed = new LatLng(latitude: latitude, longitude: longitude);
  }

  void setGrocery({double latitude, double longitude}) {
    grocery = new LatLng(latitude: latitude, longitude: longitude);
    if (!flag) {
      setFixed(latitude: latitude, longitude: longitude);
      flag = true;
    }
  }

  Future<int> calculateDistance() async {
    await getLocation();
    await getAddress();
    distance = Geolocator.distanceBetween(fixed.latitude, fixed.longitude,
            current.latitude, current.longitude)
        .round();
    distance ~/= 1000;
    return distance;
  }

  Future<void> getAddress() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(current.latitude, current.longitude);
    placemark = placemarks[0];
    // placemark = placeMark.street + " " + placeMark.locality;
  }

  Future<LatLng> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    current =
        LatLng(latitude: position.latitude, longitude: position.longitude);
  }
}

class LatLng {
  double latitude;
  double longitude;

  LatLng({this.latitude, this.longitude});
}
