import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:Saha_Yatri/Interfaces/busStopPreview.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Components/drawer.dart';
import '../consts/Routes.dart';
import '../consts/images.dart';
import 'myMap.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static const double rSize = 1;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

var user;

bool isDriver = false;
//for user
StreamSubscription<DocumentSnapshot>? _driverSubscription;

void checkDriver() async {
  isDriver = false;
  _driverSubscription = await FirebaseFirestore.instance
      .collection('Drivers')
      .doc(user.email!)
      .snapshots()
      .listen((docSnapshot) {
    var data = docSnapshot.data()!;
    isDriver = data['isDriver'] ?? false;
    print(isDriver);
  });
}

class _SearchPageState extends State<SearchPage> {
  List<RouteClass> displayList = List.from(mainRoutesList);
  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isLimited) {
      location.changeSettings(
          interval: 300, accuracy: loc.LocationAccuracy.low);
      location.enableBackgroundMode(enable: true);
      print('Limited Premitted');
    }
    if (status.isGranted) {
      location.changeSettings(
          interval: 300, accuracy: loc.LocationAccuracy.low);
      location.enableBackgroundMode(enable: true);
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text(
                'Location permission is required for full functionality. '),
            actions: [
              TextButton(
                child: Text('Open Settings'),
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print("all failed");
    }
  }

  bool isLocationplay = false;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    super.initState();
    _requestPermission();
    checkDriver();
    checkRoute();
    toggleIcon();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _driverSubscription?.cancel();
    super.dispose();
  }

  logUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Icon toggleIcon() {
    Icon pausePlay;
    if (isLocationplay) {
      return pausePlay = Icon(Icons.pause);
    } else {
      return pausePlay = Icon(Icons.play_arrow);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print("$onError ggg");
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('Drivers')
          .doc(user.email!)
          .set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.pause();
    _locationSubscription?.cancel();
  }

  void updateListByTitle(String value) {
    setState(() {
      print("called by title");
      displayList = mainRoutesList
          .where((element) =>
              element.Title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void updateListByStop(String value) {
    if (value == '') {
      setState(() {
        displayList = mainRoutesList;
      });
    } else {
      setState(() {
        print("called by stops");
        displayList = mainRoutesList.where((element) {
          List<String>? stops = element.Stops;
          for (var busStops in stops) {
            if (busStops.toLowerCase().contains(value.toLowerCase())) {
              return true;
            }
          }
          return false;
        }).toList();

        if (displayList.isEmpty) {
          updateListByTitle(value);
        }
      });
    }
  }

  void updateList(String value) {
    // by route no.
    try {
      int No = int.parse(value);
      setState(() {
        print("called by no");
        displayList = [];
        displayList.add(mainRoutesList[No - 1]);
      });
    } catch (e) {
      updateListByStop(value);
    }
  }

  List<dynamic> allRoutee = [];
  void checkRoute() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('Route details').get();
    setState(() {
      querySnapshot.docs.map((doc) => allRoutee.add(doc.id)).toList();
    });
  }

  deleteLocation() async {
    await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(user.email!)
        .set({
      'latitude': 0,
      'longitude': 0,
    }, SetOptions(merge: true));
  }

  List<String> polycoordinates = [];
  // Create a key

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //drawer
        drawer: NavigationDrawerDemo(
          isDriver: isDriver,
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            Visibility(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black, // Change this color to the desired color
                ),
                onPressed: () {
                  deleteLocation();
                },
                child: Text("Delete"),
              ),
              visible: isDriver,
            ),
            Visibility(
                visible: isDriver,
                child: IconButton(
                  onPressed: () {
                    if (isDriver) {
                      setState(() {
                        isLocationplay = !isLocationplay;
                      });
                      if (isLocationplay) {
                        _listenLocation();
                      } else if (!isLocationplay) {
                        _stopListening();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Only for drivers")),
                      );
                    }
                  },
                  icon: toggleIcon(),
                ))
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                alignment: Alignment.centerLeft,
                onPressed: () {
                  // Open drawer
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              );
            },
          ),
          centerTitle: true,
          title: const Text(
            'Saha-Yatri',
            style: TextStyle(fontFamily: 'mainFont', fontSize: 35),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              // search bar
              Container(
                padding: EdgeInsets.fromLTRB(
                    10 * SearchPage.rSize,
                    0 * SearchPage.rSize,
                    10 * SearchPage.rSize,
                    0 * SearchPage.rSize),
                child: TextField(
                  onChanged: (value) => updateList(value),
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffd9d9d9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search bus stops...",
                    suffixIcon: Icon(Icons.search),
                    suffixIconColor: Colors.black,
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: GestureDetector(
                      onTap: () => {
                        polycoordinates = [],
                        for (var cod in displayList[index].Coordinates)
                          {
                            polycoordinates.add(
                                cod[0].toString() + ", " + cod[1].toString())
                          },
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyMap(
                                  polycoordinates,
                                  (polycoordinates.length - 1),
                                  allRoutee[(displayList[index].RouteNo! - 1)],
                                )))
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(
                            0 * SearchPage.rSize,
                            0 * SearchPage.rSize,
                            1 * SearchPage.rSize,
                            0 * SearchPage.rSize),
                        width: double.infinity,
                        height: 150,
                        padding: EdgeInsets.fromLTRB(
                            5 * SearchPage.rSize,
                            10 * SearchPage.rSize,
                            10 * SearchPage.rSize,
                            10 * SearchPage.rSize),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          //for route 1
                          children: [
                            Column(
                              //C1
                              children: [
                                Text(
                                  'Route ${displayList[index].RouteNo}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(),
                                // Image.asset('route.png'),
                                Image.asset(route),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                            Column(
                              //C2
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    displayList[index].Title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        fontSize: 13),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'From: ${displayList[index].Stops.first}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'To: ${displayList[index].Stops.last}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                            Column(
                              //C3
                              children: [
                                Spacer(),
                                Image.asset(bus1),
                                Text(
                                  '${displayList[index].BusId.length}',
                                  style: TextStyle(fontSize: 13),
                                ),
                                Spacer(),
                                Image.asset(distance),
                                Text(
                                  displayList[index].Distance,
                                  style: TextStyle(fontSize: 13),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                            Column(
                                //C4
                                children: [
                                  Spacer(),
                                  Image.asset("assets/Photos/bus-stop.png"),
                                  Text(
                                    '${displayList[index].Stops.length}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Spacer(),
                                  Spacer(),
                                  Image.asset(clock),
                                  Text(
                                    '${displayList[index].Time}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Spacer(),
                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
