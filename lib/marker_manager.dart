import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {
  late Set<Marker> _markers;
  int _counter = 0;

  MarkerManager() {
    _markers = Set<Marker>();
  }

  Set<Marker> get markers => _markers;

  int get counter => _counter;

  void removeAll() {
    _markers.clear();
    _counter = 0;
  }

  void addMarker(LatLng point, String markerId) {
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: point,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
      ),
    );
    _counter++;
  }

  void addMarkerFromDB(LatLng point, String markerId) {
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: point,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
      ),
    );
  }

  void addUserMarker(
      LatLng point, String markerId, Function onTapFunc, BuildContext context) {
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: point,
        consumeTapEvents: true,
        onTap: () {
          onTapFunc(context);
        },
      ),
    );
  }
}
