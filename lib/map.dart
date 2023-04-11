import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:never_surf_alone/location_services.dart';
import 'timer.dart';
import 'package:geolocator/geolocator.dart';
import 'marker_manager.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:never_surf_alone/main_page.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'accdetails.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  MarkerManager markerManager = MarkerManager();
  final user = FirebaseAuth.instance.currentUser!;
  late GoogleMapController _controller;

  // Initial position of the map
  static const initialCameraPosition = CameraPosition(
    target: LatLng(53.343973854161774, -6.254634551749251),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();
    _dataOnChange();
    // markerManager.addUserMarker(const LatLng(53.343667, -6.2544447), 'marker',
    //     _navigateToNextScreen, context);
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CountdownPage1()));
  }

  @override
  Widget build(BuildContext context) {
    _dataOnChange();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        flexibleSpace: const CustomAppBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              // mapType: MapType.normal,
              mapType: MapType.satellite,
              markers: markerManager.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              // onLongPress: (point) {
              //   setState(() {
              //     markerManager.addUserMarker(
              //         point, 'marker', _navigateToNextScreen, context);
              //   });
              //   _sendData(point, 'redPin');
              // },
              onTap: (point) {
                setState(() {
                  markerManager.addMarker(
                      point, "marker${markerManager.counter}", context);
                });
                _sendData(point, 'marker${markerManager.counter}');
              },
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
                onPressed: (() {
                  _determinePosition();
                }),
                icon: const Icon(Icons.location_pin)),
            IconButton(
                onPressed: () async {
                  _deleteData();
                },
                icon: const Icon(Icons.refresh)),
            // IconButton(
            //     onPressed: () {
            //       // _readData();
            //     },
            //     icon: const Icon(Icons.arrow_downward))
          ]),
        ],
      ),
    );
  }

  // ******* DB *********
  Future<void> _sendData(LatLng point, String name) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("pins/${markerManager.counter}");
    await ref.set({
      "name": name,
      "lat": point.latitude,
      "long": point.longitude,
      "users": {"1": true}
    });
  }

  Future<void> _dataOnChange() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("pins/");
    ref.onChildAdded.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      Map data = event.snapshot.value as Map;
      setState(() {
        markerManager.addMarkerFromDB(
            LatLng(data['lat'], data['long']), data['name'], context);
      });
    });
    ref.onChildRemoved.listen((event) {
      setState(() {
        markerManager.removeAll();
      });
    });
  }

  // Function to delete data from the database
  Future<void> _deleteData() async {
    await FirebaseDatabase.instance.ref("pins/").remove();
    setState(() {
      markerManager.removeAll();
    });
  }

  // void _readData() async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref("pins/");
  //   DatabaseEvent event = await ref.once();
  //   if (event.snapshot.value == null) {
  //     return;
  //   }
  //   Map data = event.snapshot.value as Map;
  //   markerManager.addMarker(LatLng(data['lat'], data['long']), data['name']);
  // }

// --------------- Ask for location permission -----------------

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));

    // _setUserMarker(LatLng(lat,
    //     lng)); //not Ideal outcome but an when pressed function can be added to do same result...
  }
}
