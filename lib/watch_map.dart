import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'SOS_confirmation.dart';
import 'marker_manager.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'accdetails.dart';
import 'watchSetTimePage.dart';

// import 'package:timer_button/timer_button.dart';

class WatchMap extends StatefulWidget {
  @override
  State<WatchMap> createState() => WatchMapState();
}

class WatchMapState extends State<WatchMap> {
  int counter = 0;
  bool timerRunning = false;
  bool showButtons = true;
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

  Future<int> nav() async {
    var result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WatchSetTimePage();
    }));
    if (result == null) {
      return defautDuration;
    }
    return result;
  }
  // --------------- Timer -----------------

  int _remainingSeconds = 900;
  Timer _timer = Timer.periodic(Duration.zero, (_) {});
  int defautDuration = 900;
  int userDurarion = 0;

  void startTimer(int duration) {
    timerRunning = true;
    if (duration > 0) {
      setState(() {
        _remainingSeconds = duration;
      });
      const oneSec = Duration(seconds: 1);
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

  void stopTimer() {
    timerRunning = false;
    _timer.cancel();
  }

  void resetTimer() {
    setState(() {
      _remainingSeconds = 0;
    });
  }

  void stopAndReset() {
    stopTimer();
    resetTimer();
  }

  void setTimer(int duration) {
    setState(() {
      _remainingSeconds = duration;
    });
  }

  formatDuration(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
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
            onTap: (LatLng location) {
              if (showButtons == false) {
                setState(() {
                  showButtons = true;
                });
              } else {
                setState(() {
                  showButtons = false;
                });
              }
            },
          ),
        ),
        floatingActionButton: InkWell(
          splashColor: Colors.blue,
          onLongPress: () async {
            stopAndReset();
            userDurarion = await nav();
            setTimer(userDurarion);
            startTimer(userDurarion);
          },
          child: Visibility(
            visible: showButtons,
            child: FloatingActionButton.extended(
              heroTag: "timer",
              icon: const Icon(Icons.timer),
              onPressed: () {
                int duration;
                if (userDurarion == 0) {
                  duration = defautDuration;
                } else {
                  duration = userDurarion;
                }
                if (timerRunning == false) {
                  startTimer(duration);
                } else {
                  stopTimer();
                }
              },
              label: Text(
                  '${formatDuration(Duration(seconds: _remainingSeconds))}'),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Visibility(
          visible: showButtons,
          child: FloatingActionButton.small(
            heroTag: "SOS",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SOS_confirmation()));
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.sos),
          ),
        ),
      )
    ]);
  }
}
