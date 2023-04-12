import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'timer.dart';

class MarkerManager {
  late Set<Marker> _markers;
  int _counter = 0;
  //TODO: store counter in the database and fix the bug that downloaded markers are rewritten

  MarkerManager() {
    _markers = Set<Marker>();
  }

  Set<Marker> get markers => _markers;

  int get counter => _counter;

  void setCounter(int counter) {
    _counter = counter;
  }

  void removeAll() {
    _markers.clear();
    _counter = 0;
  }

  void removeMarker(String markerId) {
    _markers.removeWhere((marker) => MarkerId(markerId).value == markerId);
  }

  void addMarker(LatLng point, String markerId, BuildContext context) {
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: point,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
        /*onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CountdownPage()));
          },*/
      ),
    );
    _counter++;
  }

  void addMarkerFromDB(LatLng point, String markerId, String image,
      Function onTapFunc, BuildContext context) async {
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: point,
        consumeTapEvents: true,
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(32, 32)), "assets/$image"),
        onTap: () {
          onTapFunc(context, markerId);
        },
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

  void addCostumeMarker(LatLng point, String markerId, Function onTapFunc,
      BuildContext context, String iconName) async {
    _markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: point,
        consumeTapEvents: true,
        onTap: () {
          onTapFunc(context);
        },
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(32, 32)), "assets/$iconName"),
      ),
    );
    _counter++;
  }
}
