import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// define class to store name and phone number
class RouteClass {
  static var counter = 1;

  int? RouteNo;
  String Title;
  List<String> BusId;
  List<String> Stops;
  String Distance;
  String Time;
  List<List<double>> Coordinates = [];
  // {"latitude":27.700341906169626,"longitude":85.35272948366354}
  List<String> coordinateStop = [];
  RouteClass(this.Title, this.BusId, this.Stops, this.Distance, this.Time,
      this.Coordinates) {
    RouteNo = counter++;
  }
}

// Contains all the routes present in collection
List<RouteClass> mainRoutesList = [];

// retrieve data from Firestore and store in list of classes
// final firestoreInstance = FirebaseFirestore.instance;
Future<int> getRoutes() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Route details").get();

  for (var doc in querySnapshot.docs) {
    String title = doc.get("Title").toString();
    // List<String> busId = (doc.get("BusId") as List<dynamic>).cast<String>();
    // List<String> stops = (doc.get("BusStops") as List<dynamic>).cast<String>();
    List<dynamic> busIdDyn = doc.get("BusId");
    List<String> busId = busIdDyn.map((element) => element.toString()).toList();
    List<dynamic> stopsDyn = doc.get("Stops");
    List<String> stops = stopsDyn.map((element) => element.toString()).toList();
    String distance = doc.get("Distance").toString();
    String time = doc.get("Time required").toString();
    //String docName = doc.get(doc.id);
    // List<List<double>> coordinate = getCoordinates();
    List<dynamic> locData = doc.get('stopCoordinates');
    Map locationData = doc.get('BusStops');
    List<List<double>> coordinates = [];
    locData.forEach((element) {
      double latitude = element.latitude;
      double longitude = element.longitude;
      coordinates.add([latitude, longitude]);
    });
    // get Coordinates
    // locationData.forEach((key, value) {
    //   double latitude = value.latitude;
    //   double longitude = value.longitude;

    //   coordinates.add([latitude, longitude]);
    // });
    RouteClass routeCollection = RouteClass(
      title,
      busId,
      stops,
      distance,
      time,
      coordinates,
    );
    mainRoutesList.add(routeCollection);
  }
  return 1;
}
