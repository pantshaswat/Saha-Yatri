import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:Saha_Yatri/Components/myIconButton.dart';
import 'package:Saha_Yatri/Components/textField.dart';

import 'dart:convert';
import 'busInfo.dart';
import 'package:http/http.dart' as http;
import '../consts/images.dart';
import 'package:latlong2/latlong.dart' as lat;

import 'busStopPreview.dart';

class MyMap extends StatefulWidget {
  List<String> route;
  int num;
  String routeName;
  MyMap(this.route, this.num, this.routeName);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final String apiKey = 'your api key';
  List<String> origin = [];
  List<String> destination = [];

  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  BitmapDescriptor largeIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor smallIcon = BitmapDescriptor.defaultMarker;

  var userLatitude;

  var userLongitude;
  var closestDistanceInMeters;
  List<double> userDistance = [];
  List<Marker> markers = [];
  List<Polyline> _polylines = [];

  void setLines(List<String> rout) {
    for (var i = 0; i < widget.num; i++) {
      origin.add(rout[i]);
      destination.add(rout[i + 1]);
    }
  }

  void getUserLocation() async {
    loc.LocationData currentLocation = await loc.Location().getLocation();
    try {
      setState(() {
        userLatitude = currentLocation.latitude;
        userLongitude = currentLocation.longitude;
      });
    } catch (e) {
      print("No location");
    }

    // await _controller.animateCamera(CameraUpdate.newLatLngZoom(
    //     LatLng(currentLocation.latitude!, currentLocation.longitude!), 14.47));
  }

  @override
  void initState() {
    setLines(widget.route);
    super.initState();
    _addPolyline();
    getUserLocation();
    addCustomIcon();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the GoogleMapController
    super.dispose();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), largeBus).then(
      (icon) {
        setState(() {
          largeIcon = icon;
        });
      },
    );
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), smallBus).then(
      (icon) {
        setState(() {
          smallIcon = icon;
        });
      },
    );
  }

  bool showTraffic = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: Text(
              ' Distance : ${polyLength.toStringAsFixed(2)} Km \t',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      body: Stack(children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Drivers').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // if (_added) {
            //   mymap(snapshot);
            // }
            double closestLat = 0;
            double closestLng = 0;
            if (!snapshot.hasData || userLatitude == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              closestDistanceInMeters = 10000000;
              Marker marker;

              markers.clear();
              snapshot.data!.docs.forEach((QueryDocumentSnapshot document) {
                if (document.get('isDriver')) {
                  if (document.get('latitude') != 0 &&
                      document.get('longitude') != 0) {
                    double latitude = document.get('latitude');
                    double longitude = document.get('longitude');
                    String busName = document.get('Bus Company');
                    String busNum = document.get('Bus Number');
                    String busColor = document.get('Bus Color');
                    String busCapacity = document.get('Bus Capacity');
                    String driverFirstName = document.get('First Name');
                    String driverLastName = document.get('Last Name');
                    String driverNumber = document.get('Phone Number');
                    String driverEmail = document.get('Email');
                    List<dynamic> ratesArray = document.get('Rating');

                    // double bearing = atan2(
                    //         sin(currentLong - prevLng) * cos(currentLat),
                    //         cos(prevLat) * sin(currentLat) -
                    //             sin(prevLat) *
                    //                 cos(currentLat) *
                    //                 cos(currentLong - prevLng)) *
                    //     180 /
                    //     pi;

                    if (document.get('route') == widget.routeName) {
                      double lat1 = document.get('latitude');
                      double lng1 = document.get('longitude');
                      final lat.Distance distance = lat.Distance();

                      var currentDistanceInMeters = distance.as(
                          lat.LengthUnit.Meter,
                          lat.LatLng(userLatitude, userLongitude),
                          lat.LatLng(lat1, lng1));

                      if (currentDistanceInMeters < closestDistanceInMeters) {
                        closestDistanceInMeters = currentDistanceInMeters;
                        closestLat = lat1;
                        closestLng = lng1;
                      }

                      marker = Marker(
                          onTap: () async {
                            await _controller.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    LatLng(latitude, longitude), 14.47));
                          },
                          markerId: MarkerId(busName),
                          position: LatLng(latitude, longitude),
                          icon: largeIcon,
                          infoWindow: InfoWindow(
                            title: busName,
                            snippet: busNum,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => busInformation(
                                        busName,
                                        busNum,
                                        latitude,
                                        longitude,
                                        busColor,
                                        busCapacity,
                                        driverFirstName,
                                        driverLastName,
                                        driverNumber,
                                        driverEmail,
                                        ratesArray,
                                      )));
                            },
                          ));
                    } else {
                      marker = Marker(
                          onTap: () async {
                            await _controller.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                    LatLng(latitude, longitude), 14.47));
                          },
                          markerId: MarkerId(busName),
                          position: LatLng(latitude, longitude),
                          icon: smallIcon,
                          infoWindow: InfoWindow(
                            title: busName,
                            snippet: busNum,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => busInformation(
                                        busName,
                                        busNum,
                                        latitude,
                                        longitude,
                                        busColor,
                                        busCapacity,
                                        driverFirstName,
                                        driverLastName,
                                        driverNumber,
                                        driverEmail,
                                        ratesArray,
                                      )));
                            },
                          ));
                    }
                    markers.add(marker);
                  } else if (document.get('latitude') == 0 &&
                      document.get('longitude') == 0) {
                    closestLat = userLatitude;
                    closestLng = userLongitude;
                  }
                }
              });
            }

            return GoogleMap(
              mapType: MapType.normal,
              markers: Set<Marker>.of(markers),
              initialCameraPosition: CameraPosition(
                  target: LatLng(closestLat, closestLng), zoom: 14.47),
              onMapCreated: (GoogleMapController controller) async {
                setState(
                  () {
                    _controller = controller;
                    _addPolyline();
                    _added = true;
                  },
                );
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              trafficEnabled: showTraffic,
              // trafficEnabled: true,
              polylines: Set<Polyline>.of(_polylines),
            );
          },
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              elevatedButtons(() {
                setState(() {
                  showTraffic = !showTraffic;
                });
              }, showTraffic == false ? "Show Traffic" : "Hide Traffic", 40,
                  150),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BusStopsPreview()));
                },
                child: Image.asset(bus1),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(40, 40),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
          ],
        )
      ]),
    );
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    final p = 0.017453292519943295;
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  final lat.Distance polyDistance = lat.Distance();
  double polyLength = 0.0;
  List<LatLng> polylineCoordinates = [];
  void _addPolyline() async {
    _polylines.clear();
    Polyline polyline;
    for (var i = 0; i < widget.num; i++) {
      // Build the URL for the Directions API request
      final String url = 'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin[i]}'
          '&destination=${destination[i]}'
          '&key=$apiKey';

      // Send the HTTP request to the Directions API
      final response = await http.get(Uri.parse(url));

      // Parse the JSON responses
      final Map<String, dynamic> data = json.decode(response.body);

      // Extract the coordinates for the polyline from the response
      polylineCoordinates =
          _decodePolyline(data['routes'][0]['overview_polyline']['points']);

      if (!mounted)
        return; // Check if widget is still mounted before calling setState()

      setState(() {
        // Add the polyline to the map
        polyline = Polyline(
          polylineId: PolylineId("poly$i"),
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        );
        _polylines.add(polyline);
      });
      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        setState(() {
          polyLength += _coordinateDistance(
                polylineCoordinates[i].latitude,
                polylineCoordinates[i].longitude,
                polylineCoordinates[i + 1].latitude,
                polylineCoordinates[i + 1].longitude,
              ) /
              2;
        });
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polylineCoordinates.add(LatLng((lat / 1E5), (lng / 1E5)));
    }

    return polylineCoordinates;
  }
}
