import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'timer.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

import 'package:never_surf_alone/location_services.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:never_surf_alone/main_page.dart';
import 'login_page.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

const kGoogleApiKey =
    'AIzaSyCqz6Y9rQo9PnOV33HOpInCSm-2K1ImYLs'; // Api key for use in map
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class MapSampleState extends State<MapSample> {
  final Mode _mode = Mode.overlay;

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
    // determinePosition();
    // markerManager.addUserMarker(const LatLng(53.343667, -6.2544447), 'marker',
    //     _navigateToNextScreen, context);
  }

  @override
  Widget build(BuildContext context) {
    _dataOnChange();
    return Scaffold(
      appBar: AppBar(
        key: homeScaffoldKey,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(47, 36, 255, 1),
        flexibleSpace: const CustomAppBar(),
      ),
      //Refactored as stack to allow floating location search button
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  // mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  mapType: MapType.satellite,
                  markers: markerManager.markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: initialCameraPosition,
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
                                    Navigator.of(context)
                                        .pop('kitesurfing.png');
                                  },
                                ),
                                GestureDetector(
                                  child: Text('Snowboarding'),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop('snowboarding.png');
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
                          backgroundColor: Color.fromRGBO(47, 36, 255, 1),
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
                            _pinOption,
                            context,
                            value,
                          );
                        });
                        _sendData(
                            point, 'marker${markerManager.counter}', value);
                      }
                    });
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                IconButton(
                    onPressed: (() {
                      determinePosition();
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
          // Elevated button for searching location
          Positioned(
            top: 5, // Postion of button
            left: 10,
            child: ElevatedButton(
              onPressed:
                  searchLocationHandler, // Call function for searching location when pressed
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(47, 36, 255, 1),
              ),
              child: const Icon(Icons.search), // 'Search' Icon
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pinOption(BuildContext context, String markerId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Marker Options',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    'Set Timer',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _setTimer();
                  },
                ),
                SizedBox(height: 10),
                TextButton.icon(
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    'Delete Marker',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteMarker(markerId);
                  },
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Color.fromRGBO(47, 36, 255, 1),
        );
      },
    );
  }

  void _setTimer() {
    ////*********USE THIS TO GET TO TIMER PAGE****************
  }

  //For showing autocompletion suggestions
  Future<void> searchLocationHandler() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: 'Search Location',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      components: [
        Component(Component.country,
            'IE'), //Currently just shows locations in Ireland ('IE')
      ],
    );

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

// Displays Predictions when searching for location, moves map to location selected
  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail
        .result.geometry!.location.lat; //Get Lat & Lng from location selected
    final lng = detail.result.geometry!.location.lng;

    setState(() {});

    //Animate Map camera to given coordinates
    _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
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

  //function to always update pins based on database
  Future<void> _dataOnChange() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("pins/");
    ref.onChildAdded.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      Map data = event.snapshot.value as Map;
      setState(() {
        markerManager.addMarkerFromDB(LatLng(data['lat'], data['long']),
            data['name'], data['image'], _pinOption, context);
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
    counterRef.child("count").set(2);
  }

  Future<void> _deleteMarker(String markerId) async {
    setState(() {
      markerManager.removeMarker(markerId);
    });

    //increment the counter
    DatabaseReference counterRef = FirebaseDatabase.instance.ref("counter/");
    counterRef.child("count").set(
        ServerValue.increment(0)); //needs to be +1, -1 will end up overwriting

    //to remove specific pin from db
    DatabaseReference pinsRef = FirebaseDatabase.instance.ref("pins");
    pinsRef
        .orderByChild("name")
        .equalTo(markerId)
        .get()
        .then((DataSnapshot snapshot) {
      Map data = snapshot.value as Map;
      final String key = data.keys.toList()[0];
      pinsRef.child(key).remove();
    });
  }

// --------------- Ask for location permission -----------------

  Future<Position> determinePosition() async {
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
