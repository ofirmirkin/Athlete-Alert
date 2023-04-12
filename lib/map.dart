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
        .push(MaterialPageRoute(builder: (context) => CountdownPage()));
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
              // setState(() {
              // markerManager.addUserMarker(
              // point, 'marker', _navigateToNextScreen, context);
              // });
              //_sendData(point, 'redPin');
              //},
              onTap: (point) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select your Sport'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: Text('Mountain Biking'),
                              onTap: () {
                                Navigator.of(context).pop('bike.png');
                              },
                            ),
                            GestureDetector(
                              child: Text('Hiking'),
                              onTap: () {
                                Navigator.of(context).pop('hiking.png');
                              },
                            ),
                            GestureDetector(
                              child: Text('Kayaking'),
                              onTap: () {
                                Navigator.of(context).pop('kayaking.png');
                              },
                            ),
                            GestureDetector(
                              child: Text('Kitesurfing'),
                              onTap: () {
                                Navigator.of(context).pop('kitesurfing.png');
                              },
                            ),
                            GestureDetector(
                              child: Text('Snowboarding'),
                              onTap: () {
                                Navigator.of(context).pop('snowboarding.png');
                              },
                            ),
                            GestureDetector(
                              child: Text('Surfing'),
                              onTap: () {
                                Navigator.of(context).pop('surfing.png');
                              },
                            ),
                            GestureDetector(
                              child: Text('Swimming'),
                              onTap: () {
                                Navigator.of(context).pop('swimming.png');
                              },
                            ),
                          ],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.cyan,
                      titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      contentTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      markerManager.addCostumeMarker(
                        point,
                        "marker${markerManager.counter}",
                        _navigateToNextScreen,
                        context,
                        value,
                      );
                    });
                    _sendData(point, 'marker${markerManager.counter}', value);
                  }
                });
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
          ]),
        ],
      ),
    );
  }

  // ******* DB *********
  Future<void> _sendData(LatLng point, String name, String image) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("pins/${markerManager.counter}");
    await ref.set({
      "name": name,
      "image": image,
      "lat": point.latitude,
      "long": point.longitude,
      "users": {"1": true},
    });
    
    //increment the pin counter in the db
    DatabaseReference counterRef = FirebaseDatabase.instance.ref("counter/");
    counterRef.child("count").set(ServerValue.increment(1));
  }

  Future<void> _dataOnChange() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("pins/");
    ref.onChildAdded.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      Map data = event.snapshot.value as Map;
      setState(() {
        markerManager.addMarkerFromDB(LatLng(data['lat'], data['long']),
            data['name'], data['image'], _navigateToNextScreen, context);
      });
    });
    ref.onChildRemoved.listen((event) {
      setState(() {
        markerManager.removeAll();
      });
    });
    
    //to get the count of current pins in the db so we don't overwrite
    DatabaseReference counterRef = FirebaseDatabase.instance.ref("counter/");
    counterRef.child("count").get().then((DataSnapshot snapshot) {
      int count = snapshot.value != null ? snapshot.value as int : 0;
      markerManager.setCounter(count);
    });
  }

  //Function to delete data from the database
  Future<void> _deleteData() async {
    await FirebaseDatabase.instance.ref("pins/").remove();
    setState(() {
      markerManager.removeAll();
    });
    DatabaseReference counterRef = FirebaseDatabase.instance.ref("counter/");
    counterRef.child("count").set(0);
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
