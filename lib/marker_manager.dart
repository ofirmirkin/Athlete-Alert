import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerManager {
  late Set<Marker> _markers;

  MarkerManager() {
    _markers = Set<Marker>();
  }

  Set<Marker> get markers => _markers;

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
