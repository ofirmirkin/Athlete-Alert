import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'timer.dart';
import 'marker_manager.dart';
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

const kGoogleApiKey = 'AIzaSyCqz6Y9rQo9PnOV33HOpInCSm-2K1ImYLs';  // Api key for use in map 
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
        key: homeScaffoldKey,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
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
          // Elevated button for searching location
          Positioned(
            top: 5,     // Postion of button
            left: 10,
            child: ElevatedButton(
              onPressed: searchLocationHandler,   // Call function for searching location when pressed
              child: const Icon(Icons.search),    // 'Search' Icon
            ),
          )
        ],
      ),
    );
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
        Component(Component.country, 'IE'), //Currently just shows locations in Ireland ('IE')
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

    final lat = detail.result.geometry!.location.lat;   //Get Lat & Lng from location selected
    final lng = detail.result.geometry!.location.lng;

    setState(() {});

    //Animate Map camera to given coordinates
    _controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
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
