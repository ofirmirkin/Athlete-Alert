import 'dart:async';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:never_surf_alone/location_services.dart';
import 'timer.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  // Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(53.343667, -6.2544447),
  //   zoom: 14.4746,
  // );
  late GoogleMapController _controller;

  // Initial position of the map
  static const initialCameraPosition = CameraPosition(
    target: LatLng(53.343973854161774, -6.254634551749251),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(53.343667, -6.2544447));
    // Temporary example marker
    _addMarkerToSet(
        const LatLng(53.34327727028038, -6.250793787367582), 'Marker1');
    _addMarkerToSet(
        const LatLng(53.34647802009742, -6.256285970820735), 'Marker2');
  }

  void _addMarkerToSet(LatLng point, String markerId) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        ),
      );
    });
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('marker'),
            position: point,
            consumeTapEvents: true,
            onTap: () {
              _navigateToNextScreen(context);
            }),
      );
    });
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CountdownPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Never Surf Alone')),
      body: Column(
        children: [
          // Row(
          //   children: [
          //     Expanded(
          //         child: TextFormField(
          //       controller: _searchController,
          //       textCapitalization: TextCapitalization.words,
          //       decoration: InputDecoration(hintText: 'Search for Beaches'),
          //       onChanged: (value) {
          //         print(
          //             value); //Debugging console tool to help see whats going on..
          //       },
          //     )),
          //     IconButton(
          //       onPressed: () async {
          //         var place =
          //             await LocationService().getPlace(_searchController.text);
          //         _goToPlace(place);
          //       },
          //       icon: Icon(Icons.search),
          //     ),
          //   ],
          // ),
          Expanded(
            child: GoogleMap(
              // mapType: MapType.normal,
              mapType: MapType.satellite,
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,

              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              // onMapCreated: (GoogleMapController controller) {
              //   _controller.complete(controller);
              // },
              onTap: (point) {
                setState(() {
                  _setMarker(
                      point); //could be an issue but should be dynamic enough...
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();
        },
        label: const Text('Get location?'),
        icon: const Icon(Icons.location_pin),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

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

    _setMarker(LatLng(lat,
        lng)); //not Ideal outcome but an when pressed function can be added to do same result...
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
