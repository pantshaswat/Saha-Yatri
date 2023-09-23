import 'package:flutter/material.dart';
import '../consts/Routes.dart';

class BusStopsPreview extends StatefulWidget {
  BusStopsPreview({super.key});

  @override
  State<BusStopsPreview> createState() => _BusStopsPreviewState();
}

class _BusStopsPreviewState extends State<BusStopsPreview> {
  int routeNo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(mainRoutesList[routeNo].Title)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              if (routeNo > 0) {
                routeNo--;
              }
            });
          },
        ),
        actions: [
          // For next
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              setState(() {
                if (routeNo < mainRoutesList.length - 1) {
                  routeNo++;
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mainRoutesList[routeNo].Stops.length,
        itemBuilder: (context, index) => ListTile(
          title: Text('${index + 1}. ${mainRoutesList[routeNo].Stops[index]}'),
        ),
      ),
    );
  }
}
