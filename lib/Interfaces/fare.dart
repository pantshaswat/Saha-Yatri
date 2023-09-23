import 'package:flutter/material.dart';
import 'package:Saha_Yatri/Interfaces/routeCalculator.dart';

import '../consts/Routes.dart';
import '../consts/images.dart';

class myFare extends StatefulWidget {
  const myFare({super.key});
  static const double rSize = 1;
  @override
  State<myFare> createState() => _myFareState();
}

class _myFareState extends State<myFare> {
  List<RouteClass> displayList = List.from(mainRoutesList);
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

  List<String> polycoordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Fare Calculator",
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
              padding: EdgeInsets.fromLTRB(10 * myFare.rSize, 0 * myFare.rSize,
                  10 * myFare.rSize, 0 * myFare.rSize),
              child: TextField(
                onChanged: (value) => updateList(value),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffd9d9d9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search bus stops...",
                  suffixIcon: Icon(Icons.search),
                  suffixIconColor: Colors.white,
                ),
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
                          polycoordinates
                              .add(cod[0].toString() + ", " + cod[1].toString())
                        },
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => fareCalculator(
                              route: polycoordinates,
                              busStops: displayList[index].Stops,
                              routeName: displayList[index].Title,
                            ),
                          )),
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0 * myFare.rSize,
                          0 * myFare.rSize, 1 * myFare.rSize, 0 * myFare.rSize),
                      width: double.infinity,
                      height: 150,
                      padding: EdgeInsets.fromLTRB(
                          5 * myFare.rSize,
                          10 * myFare.rSize,
                          10 * myFare.rSize,
                          10 * myFare.rSize),
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
                              Image.asset(clock),
                              Text(
                                '${displayList[index].Time}',
                                style: TextStyle(fontSize: 13),
                              ),
                              Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
