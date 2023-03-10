import 'dart:async';
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

// void main() => runApp(MyApp());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

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
  // TextEditingController _searchController = TextEditingController();

  MarkerManager markerManager = MarkerManager();

  late GoogleMapController _controller;

  // Initial position of the map
  static const initialCameraPosition = CameraPosition(
    target: LatLng(53.343973854161774, -6.254634551749251),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();
    _dataOnChange2();
    markerManager.addUserMarker(const LatLng(53.343667, -6.2544447), 'marker',
        _navigateToNextScreen, context);
    // Temporary example marker
    // markerManager.addMarker(const LatLng(53.34327727028038, -6.250793787367582),
    //     'Marker${markerManager.counter}');
    // markerManager.addMarker(const LatLng(53.34647802009742, -6.256285970820735),
    //     'Marker${markerManager.counter}');
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CountdownPage()));
  }

  @override
  Widget build(BuildContext context) {
    _dataOnChange2();
    return Scaffold(
      appBar: AppBar(title: const Text('Never Surf Alone')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              // mapType: MapType.normal,
              mapType: MapType.satellite,
              // markers: _markers,
              markers: markerManager.markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,

              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              onTap: (point) {
                setState(() {
                  markerManager.addUserMarker(
                      point, 'marker', _navigateToNextScreen, context);
                });
                _sendData(point, 'redPin');
              },
              onLongPress: (point) {
                setState(() {
                  markerManager.addMarker(
                      point, "marker${markerManager.counter}");
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
                  setState(() {
                    markerManager.removeAll();
                  });
                },
                icon: const Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  _readData();
                },
                icon: const Icon(Icons.arrow_downward))
          ]),
        ],
      ),
      //   floatingActionButton: FloatingActionButton.extended(
      //     onPressed: () async {
      //       _deleteData();
      //       setState(() {
      //         markerManager.removeAll();
      //       });
      //       Position position = await _determinePosition();
      //     },
      //     label: const Text('Get location?'),
      //     icon: const Icon(Icons.location_pin),
      //   ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

    // _setUserMarker(LatLng(lat,
    //     lng)); //not Ideal outcome but an when pressed function can be added to do same result...
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  // ******* DB *********
  //We are storing the first pin with id = 1,
  DatabaseReference ref = FirebaseDatabase.instance.ref("pins/0");

  Future<void> _sendData(LatLng point, String name) async {
    // setState(() async {
    await ref.set({
      "name": name,
      "lat": point.latitude,
      "long": point.longitude,
      "users": {"1": true}
      // });
    });
    ref = FirebaseDatabase.instance.ref("pins/${markerManager.counter}");
  }

  // Function to read data from the database
  Future<void> _dataOnChange() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("pins/");

// Get the Stream
    Stream<DatabaseEvent> stream = ref.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      print("*************************************");
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      print('Snapshot: ${event.snapshot}'); // DataSnapshot
    });
    // stream.first
  }

  Future<void> _dataOnChange2() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("pins/");
    ref.onChildAdded.listen((event) {
      print("*************************************");
      print(event.snapshot.value);
      if (event.snapshot.value == null) {
        return;
      }
      Map data = event.snapshot.value as Map;
      setState(() {
        markerManager.addMarker(
            LatLng(data['lat'], data['long']), data['name']);
      });
    });
    ref.onChildRemoved.listen((event) {
      _deleteData();
    });
  }

  void _readData() async {
    DatabaseEvent event = await ref.once();
    // Print the data of the snapshot
    print("*************************************");
    Map data = event.snapshot.value as Map;
    markerManager.addMarker(LatLng(data['lat'], data['long']), data['name']);
    print(event.snapshot.value);
    if (event.snapshot.value == null) {
      return;
    }
    // event.snapshot.value.forEach((key, value) {
    //   // print("*************************************");
    //   // print(key);
    //   // print(value);
    //   // print(value['lat']);
    //   // print(value['long']);
    //   // print(value['name']);
    //   // print(value['users']);
    //   markerManager.addMarker(
    //       LatLng(value['lat'], value['long']), value['name']);
    // });
  }

  // Function to delete data from the database
  Future<void> _deleteData() async {
    for (var i = 0; i < 50; i++) {
      // ref = FirebaseDatabase.instance.ref("pins/$i");
      // await ref.remove();
      await FirebaseDatabase.instance.ref("pins/$i").remove();
    }
    ref = FirebaseDatabase.instance.ref("pins/0");
  }
}
