import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:Saha_Yatri/Components/textField.dart';

class fareCalculator extends StatefulWidget {
  List<String> route;
  List<String> busStops;
  String routeName;
  fareCalculator(
      {super.key,
      required this.route,
      required this.busStops,
      required this.routeName});

  @override
  State<fareCalculator> createState() => _fareCalculatorState();
}

class _fareCalculatorState extends State<fareCalculator> {
  String? selectedStop1;
  String? selectedStop2;
  // List<String> routee2 = [
  //   "27.618672074601207, 85.55380160470547",
  //   "27.625646944301387, 85.54010334631154",
  //   "27.705763150733148, 85.31418846746605",
  // ];
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double polyLength = 0.0;
  int fare = 0;
  List<LatLng> polylineCoordinates = [];
  final String apiKey = 'your api key';
  String? origin;
  String? destination;
  void setLines(String ori, String desti) {
    origin = ori;
    destination = desti;
  }

  Future<void> _addPolyline() async {
    // Build the URL for the Directions API request
    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin}'
        '&destination=${destination}'
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
    double poly = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      poly += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );

      setState(() {
        polyLength = poly;
      });
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

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.routeName,
          style: TextStyle(
            fontFamily: 'mainFont',
            fontSize: 33,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),

              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(20),
                  isExpanded: true,
                  underline: Container(),
                  hint: Text("Select 1st Stop"),
                  value: selectedStop1,
                  items: widget.busStops.map((option) {
                    int index = widget.busStops.indexOf(option);
                    String routeValue = widget.route[index];
                    return DropdownMenuItem<String>(
                      value: routeValue,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStop1 = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15)),
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(20),
                  isExpanded: true,
                  underline: Container(),
                  hint: Text("Select 2nd Stop"),
                  value: selectedStop2,
                  items: widget.busStops.map((option) {
                    int index = widget.busStops.indexOf(option);
                    String routeValue = widget.route[index];
                    return DropdownMenuItem<String>(
                      value: routeValue,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStop2 = value;
                    });
                  },
                ),
              ),
              elevatedButtons(() {
                calculate();
              }, 'Calculate', 45, 150),
              // ElevatedButton(
              //     onPressed: () {

              //     },
              //     child: Text("Show Fare")),
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                width: 350,
                height: 300,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The distance is: ${polyLength.toStringAsFixed(2)} km ",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "The estimated time is: ${(polyLength / 15 * 60).toStringAsFixed(2)} min",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        "रु $fare",
                        style: TextStyle(fontSize: 80, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void calculate() async {
    // showing loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });

    if (selectedStop1 != null || selectedStop2 != null) {
      setLines(selectedStop1!, selectedStop2!);
      await _addPolyline();
    }
    if (selectedStop1 == selectedStop2) {
      setState(() {
        polyLength = 0;
        fare = 20;
        Navigator.pop(context);
      });
    }
    if (polyLength != 0) {
      Navigator.pop(context);
    }
    if (polyLength > 0.0 && polyLength <= 5.0) {
      setState(() {
        fare = 20;
      });
    }
    if (polyLength > 5.0 && polyLength <= 10.0) {
      setState(() {
        fare = 25;
      });
    }
    if (polyLength > 10.0 && polyLength <= 15.0) {
      setState(() {
        fare = 30;
      });
    }
    if (polyLength > 15.0 && polyLength <= 20.0) {
      setState(() {
        fare = 33;
      });
    }
    if (polyLength > 20.0 && polyLength <= 25) {
      setState(() {
        fare = 38;
      });
    }
    if (polyLength > 25.0 && polyLength <= 33) {
      setState(() {
        fare = 60;
      });
    }
  }
}
