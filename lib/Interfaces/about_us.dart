import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30, left: 50),
                child: Row(children: [
                  Container(
                    child: Text(
                      'Who we are ?',
                      style: TextStyle(
                          fontFamily: 'mainFont',
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 20),
                      height: 35,
                      width: 35,
                      child:
                          Image(image: AssetImage('assets/Photos/people.jpg')))
                ]),
              ),
              // Row(children: [
              //   Container(
              //     margin :const EdgeInsets.only(top:60,left:20),
              //   child:const Text ('Team Saha Yatri', style: TextStyle(fontFamily :'greatt',fontSize: 35 ),),),

              //  Container(
              //    margin :EdgeInsets.only(top:55,left:20),
              //      child: const Image(
              //   width: 30, height: 30,
              //   image: AssetImage('lib/images/logo.png')))] ) ,

              Container(
                width: 350,
                height: 240,
                margin: EdgeInsets.only(
                  top: 5,
                ),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)
                    //color: Colors.black,
                    ),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                      '  We are highly enthusiastic group of individuals wanting to help you make travelling through buses in Kathmandu valley easier.                                Our main goal is to make by bus travelling more systematic and predictable . You can surely make your travel more efficient just within a few clicks .',
                      style: TextStyle(fontSize: 20)),
                ),
              ),

              Row(children: [
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 20),
                  child: const Text(
                    'Team Saha Yatri',
                    style: TextStyle(
                        fontFamily: 'mainFont',
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 25, left: 10),
                    child: const Image(
                        width: 20,
                        height: 20,
                        image: AssetImage('assets/Photos/logo.png')))
              ]),

              //margin :const EdgeInsets.only(top: 5,),
              Container(
                child: Row(
                  children: [
                    //margin :const EdgeInsets.only(top: 5,),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: const Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.person),
                      ),
                    ),
                    Container(child: Text('Bibek Adhikari'))
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: const Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.person),
                      ),
                    ),
                    Container(child: Text('Diya Neupane'))
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    //margin :const EdgeInsets.only(top: 5,),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: const Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.person),
                      ),
                    ),
                    Container(child: Text('Prabesh Guragain'))
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: [
                    //margin :const EdgeInsets.only(top: 5,),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: const Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.person),
                      ),
                    ),
                    Container(child: Text('Sasa Dhungana'))
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: [
                    //margin :const EdgeInsets.only(top: 5,),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: const Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(Icons.person),
                      ),
                    ),
                    Container(child: Text('Shaswat Pant'))
                  ],
                ),
              ),

              Container(
                  child: Row(children: [
                Container(
                    margin: EdgeInsets.only(top: 10, left: 13),
                    child: const Text('Contact us through : ',
                        style: TextStyle(
                            fontFamily: 'mainFont',
                            color: Colors.black,
                            fontSize: 25))),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: const Text(
                      'semproject404@gmail.com',
                      style: TextStyle(color: Color.fromARGB(255, 84, 78, 78)),
                    ))
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
