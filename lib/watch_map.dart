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
import 'watchTimer_manager.dart';
// import 'package:timer_button/timer_button.dart';

class WatchMap extends StatefulWidget {
  @override
  State<WatchMap> createState() => WatchMapState();
}

class WatchMapState extends State<WatchMap> {
  int counter = 0;
  bool timerRunning = false;
  // WatchTimerManager timerManager = WatchTimerManager();
  MarkerManager markerManager = MarkerManager();
  // final user = FirebaseAuth.instance.currentUser!;
  late GoogleMapController _controller;

  // Initial position of the map
  static const initialCameraPosition = CameraPosition(
    target: LatLng(53.343973854161774, -6.254634551749251),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
  }

  // void _navigateToNextScreen(BuildContext context) {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => CountdownPage()));
  // }

  @override
  Widget build(BuildContext context) {
    // _dataOnChange();
    return Scaffold(
      body: SafeArea(
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
        ),
      ),
      floatingActionButton: InkWell(
        splashColor: Colors.blue,
        onLongPress: () {
          print('Log Pressed');
        },
        child: FloatingActionButton.extended(
          icon: const Icon(Icons.timer),
          onPressed: () {
            if (timerRunning == false) {
              timerRunning = true;
              _startTimer();
            } else {
              timerRunning = false;
              _stopTimer();
            }
          },
          label: Text('${_remainingSeconds}'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  int _remainingSeconds = 0;
  Timer _timer = Timer.periodic(Duration.zero, (_) {});
  // final _durationController = TextEditingController();
  int duration = 15;

  void _startTimer() {
    // int duration = int.tryParse(_durationController.text) ?? 0;
    if (duration > 0) {
      setState(() {
        _remainingSeconds = duration;
      });
      const oneSec = const Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(
          () {
            if (_remainingSeconds < 1) {
              timer.cancel();
            } else {
              _remainingSeconds = _remainingSeconds - 1;
            }
          },
        ),
      );
    }
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _remainingSeconds = 0;
    });
  }

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
