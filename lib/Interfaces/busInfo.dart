import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:Saha_Yatri/Components/textField.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../Components/myDivider.dart';
import '../consts/images.dart';

class busInformation extends StatefulWidget {
  final String companyName;
  final String busNum;
  final double latitude;
  final double longitude;
  final String busColor;
  final String busCapacity;
  final String driverFirstName;
  final String driverLastName;
  final String driverNumber;
  final String driverEmail;
  List<dynamic> ratesArray;
  busInformation(
    this.companyName,
    this.busNum,
    this.latitude,
    this.longitude,
    this.busColor,
    this.busCapacity,
    this.driverFirstName,
    this.driverLastName,
    this.driverNumber,
    this.driverEmail,
    this.ratesArray,
  );

  @override
  State<busInformation> createState() => _busInformationState();
}

class _busInformationState extends State<busInformation> {
  double averageRate = 0.0;
  @override
  final reviewController = TextEditingController();

  void initState() {
    super.initState();
    setLocation();
    //ratingsGetter();
    ratingSetter();
    percentSetter();
  }

  // void ratingsGetter() async {
  //   await FirebaseFirestore.instance
  //       .collection('Drivers')
  //       .doc(widget.driverEmail)
  //       .snapshots()
  //       .listen((docSnapshot) {
  //     var data = docSnapshot.data()!;
  //     ratesArray = data['Rating'];
  //   });
  // }
  // void ratingsGetter() async {
  //   await FirebaseFirestore.instance
  //       .collection('Drivers')
  //       .doc(widget.driverEmail)
  //       .snapshots()
  //       .listen((docSnapshot) {
  //     var data = docSnapshot.data()!;
  //     ratesArray = data['Rating'];
  //   });
  // }

  double percent5 = 0.0;
  double percent4 = 0.0;
  double percent3 = 0.0;
  double percent2 = 0.0;
  double percent1 = 0.0;
  percentSetter() {
    for (var i = 0; i < widget.ratesArray.length; i++) {
      if (widget.ratesArray[i] == 1) {
        setState(() {
          percent1++;
        });
      }

      if (widget.ratesArray[i] == 2) {
        setState(() {
          percent2++;
        });
      }

      if (widget.ratesArray[i] == 3) {
        setState(() {
          percent3++;
        });
      }

      if (widget.ratesArray[i] == 4) {
        setState(() {
          percent4++;
        });
      }

      if (widget.ratesArray[i] == 5) {
        setState(() {
          percent5++;
        });
      }
    }
  }

  ratingSetter() {
    double sum = 0.0;
    for (var i = 0; i < widget.ratesArray.length; i++) {
      sum += widget.ratesArray[i];
    }
    setState(() {
      averageRate = sum / widget.ratesArray.length;
    });
  }

  double rating = 1;

  String? locationName;
  setLocation() async {
    List<loc.Placemark> palceMarks =
        await loc.placemarkFromCoordinates(widget.latitude, widget.longitude);
    setState(() {
      locationName = palceMarks[0].subLocality;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "Saha Yatri",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'mainFont',
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Container(
                        height: 50,
                        width: 50,
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(busLogo)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Bus Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Company: ${widget.companyName}"),
                SizedBox(
                  height: 5,
                ),
                Text("Bus Number: ${widget.busNum}"),
                SizedBox(
                  height: 5,
                ),
                Text("Current Location: ${locationName}"),
                SizedBox(
                  height: 5,
                ),
                Text("Bus Color: ${widget.busColor}"),
                SizedBox(
                  height: 5,
                ),
                Text("Bus Capacity: ${widget.busCapacity}"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Driver Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      "${widget.driverFirstName}  ${widget.driverLastName}",
                      style: TextStyle(fontSize: 18),
                    ),
                    Spacer(),
                    Container(
                      width: 70,
                      height: 70,
                      color: Colors.green,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Contact Number: ${widget.driverNumber}"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Reviews & Ratings",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Row(
                  children: [
                    Text("${averageRate.toStringAsFixed(1)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 60)),
                    Spacer(),
                    Spacer(),
                    Column(
                      children: [
                        Text(
                          "5",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text("4", style: TextStyle(fontSize: 10)),
                        Text("3", style: TextStyle(fontSize: 10)),
                        Text("2", style: TextStyle(fontSize: 10)),
                        Text("1", style: TextStyle(fontSize: 10)),
                      ],
                    ),
                    Column(
                      children: [
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 8.0,
                          percent: (percent5 / widget.ratesArray.length),
                          backgroundColor: Colors.grey,
                          progressColor: Colors.black54,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 8.0,
                          percent: (percent4 / widget.ratesArray.length),
                          backgroundColor: Colors.grey,
                          progressColor: Colors.black54,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 8.0,
                          percent: (percent3 / widget.ratesArray.length),
                          backgroundColor: Colors.grey,
                          progressColor: Colors.black54,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 8.0,
                          percent: (percent2 / widget.ratesArray.length),
                          backgroundColor: Colors.grey,
                          progressColor: Colors.black54,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        LinearPercentIndicator(
                          width: 200.0,
                          lineHeight: 8.0,
                          percent: (percent1 / widget.ratesArray.length),
                          backgroundColor: Colors.grey,
                          progressColor: Colors.black54,
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Text("${widget.ratesArray.length} Ratings"),
                    Spacer(),
                  ],
                ),
                Divider(
                  thickness: 2,
                  indent: 15,
                  endIndent: 15,
                ),
                Row(
                  children: [
                    Spacer(),
                    RatingBar.builder(
                        initialRating: rating,
                        updateOnDrag: true,
                        glow: true,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                        onRatingUpdate: (value) {
                          setState(() {
                            rating = value;
                          });
                        }),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Spacer(),
                    Text("Your Rating: $rating"),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Spacer(),
                    elevatedButtons(() {
                      widget.ratesArray.add(rating);
                      ratingSubmit();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Your rating has been submitted")),
                      );
                      widget.ratesArray.add(rating);
                      ratingSubmit();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Your rating has been submitted")),
                      );
                    }, 'Submit', 40, 80),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ratingSubmit() async {
    await FirebaseFirestore.instance
        .collection('Drivers')
        .doc(widget.driverEmail)
        .set({
      'Rating': widget.ratesArray,
    }, SetOptions(merge: true));
  }
}
