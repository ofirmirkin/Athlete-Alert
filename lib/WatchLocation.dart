import 'package:location/location.dart';

class WatchLocation {
  late Location location;

  WatchLocation() {
    location = Location();
  }

  void askPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }
    location.enableBackgroundMode(enable: true);
  }

  Future<LocationData> determinePosition() {
    askPermission();
    return location.getLocation();
  }

}