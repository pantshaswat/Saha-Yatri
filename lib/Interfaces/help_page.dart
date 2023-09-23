import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  bool isVisible = false;
  bool isVisible2 = false;
  bool isVisible3 = false;
  bool isVisible4 = false;
  arrow1() {
    if (isVisible) {
      return Icon(Icons.arrow_right);
    } else
      return Icon(Icons.arrow_drop_down);
  }

  arrow2() {
    if (isVisible2) {
      return Icon(Icons.arrow_right);
    } else
      return Icon(Icons.arrow_drop_down);
  }

  arrow3() {
    if (isVisible3) {
      return Icon(Icons.arrow_right);
    } else
      return Icon(Icons.arrow_drop_down);
  }

  arrow4() {
    if (isVisible4) {
      return Icon(Icons.arrow_right);
    } else
      return Icon(Icons.arrow_drop_down);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Help ? ',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Row(children: [
                  Container(
                    child: Text(' What can we help you with?',
                        style: TextStyle(
                            fontFamily: 'mainFont',
                            fontSize: 35,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 25,
                    width: 25,
                    child: Image(image: AssetImage('assets/Photos/logo.png')),
                  )
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Row(
                  children: [
                    Container(
                        height: 35,
                        width: 35,
                        child: Image(
                            image: AssetImage('assets/Photos/thinking.png'))),
                    Container(
                      child: Text('Having problems in map ?',
                          style: TextStyle(fontSize: 18)),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                          icon: arrow1(),
                          onPressed: () {
                            setState(
                              () {
                                isVisible = !isVisible;
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: isVisible,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'If your map or routes or buses are not visible , please make sure you are connected to the internet. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Row(
                  children: [
                    Container(
                        height: 35,
                        width: 35,
                        child: Image(
                            image: AssetImage('assets/Photos/thinking.png'))),
                    Container(
                      child: Text('Unable to share your location?',
                          style: TextStyle(fontSize: 18)),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                          icon: arrow2(),
                          onPressed: () {
                            setState(
                              () {
                                isVisible2 = !isVisible2;
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: isVisible2,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'If you are a driver and you are having problems sharing your location , please make sure you are logged in as driver.The app only allows drivers to share location because of safety protocols. Also , do check your internet connection and make sure you have granted location access to the app. ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 15),
                child: Row(children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Image(
                          image: AssetImage('assets/Photos/thinking.png'))),
                  Container(
                    child: Text('Unable to get location of buses?',
                        style: TextStyle(fontSize: 18)),
                  ),
                  Container(
                    child: IconButton(
                      icon: arrow3(),
                      onPressed: () {
                        setState(() {
                          isVisible3 = !isVisible3;
                        });
                      },
                    ),
                  )
                ]),
              ),
              Visibility(
                visible: isVisible3,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    ' If you are a passenger and are unable to track the locations of buses on routes you are willing, first please make sure you are logged in as user and not driver and secondly , make sure you have a stable internet connection for the best experience.',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Row(children: [
                  Container(
                      height: 35,
                      width: 35,
                      child: Image(
                          image: AssetImage('assets/Photos/thinking.png'))),
                  Container(
                    child: Text('Unable to get routes?',
                        style: TextStyle(fontSize: 18)),
                  ),
                  Container(
                    child: IconButton(
                      icon: arrow4(),
                      onPressed: () {
                        setState(() {
                          isVisible4 = !isVisible4;
                        });
                      },
                    ),
                  )
                ]),
              ),
              Visibility(
                visible: isVisible4,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    ' If you are a passenger and are unable to get routes , please make sure you have turned on the location in your device and you have a stable internet connection',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 30, left: 5),
                  height: 190,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)
                      //color: Colors.black,
                      ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(children: [
                          Spacer(),
                          Container(
                              child: Text('Helpline !',
                                  style: TextStyle(
                                      fontFamily: 'mainFont',
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold))),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              width: 30,
                              height: 25,
                              child: Image(
                                image: AssetImage('assets/Photos/helpline.jpg'),
                              )),
                          Spacer(),
                        ]),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            'Did you lose or forget something ? Or do you have any complaints regarding the bus or the app? Click on the email mentioned below and let us know ! ',
                            style: TextStyle(fontSize: 16),
                          )),
                      Container(
                        child: TextButton(
                          onPressed: () async {
                            String? encodeQueryParameters(
                                Map<String, String> params) {
                              return params.entries
                                  .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                  .join('&');
                            }

                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'semproject404@gmail.com',
                              query: encodeQueryParameters(<String, String>{
                                'subject': 'This is Subject',
                              }),
                            );
                            if (await canLaunchUrl(emailLaunchUri)) {
                            } else {
                              throw Exception(
                                  'Could not launch $emailLaunchUri');
                            }
                            launchUrl(emailLaunchUri);
                          },
                          child: Text(
                            'semproject404@gmail.com',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
