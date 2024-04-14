// ignore_for_file: avoid_print, unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Helper extends StatefulWidget {
  const Helper({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HelperState();
  }
}

class HelperState extends State<Helper> {
  int type_of_crop = 0, soil_type = 0, pesticide_use = 0, pesticide_count = 0;
  List<Map<String, double>> coordinates = [
    {'lat': 0.0, 'long': 0.0},
    {'lat': 0.0, 'long': 0.0},
    {'lat': 0.0, 'long': 0.0},
    {'lat': 0.0, 'long': 0.0},
  ];
  double pesticide_week = 0;
  int count = 1;
  bool isLoading = false, result = false;
  int ans = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> questions = [
      Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const CircleAvatar(
                  radius: 20,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage(
                    'assets/splash.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    child: Center(
                      child: Text(
                        'Can I get you location?',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    count = 2;
                    setState(() {});
                  },
                  child: const Text('Yes, you can.'),
                )),
          )
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                const CircleAvatar(
                  radius: 20,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.black,
                  backgroundImage: AssetImage(
                    'assets/splash.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: 230,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Please provide your location.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < coordinates.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 50,
                      child: Text("Lat:"),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: TextEditingController(
                            text: coordinates[i]['lat'].toString()),
                        onChanged: (value) {
                          coordinates[i]['lat'] = double.tryParse(value) ?? 0.0;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    const SizedBox(
                      width: 50,
                      child: Text("Long:"),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextField(
                        controller: TextEditingController(
                            text: coordinates[i]['long'].toString()),
                        onChanged: (value) {
                          coordinates[i]['long'] =
                              double.tryParse(value) ?? 0.0;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          Position position =
                              await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high,
                          );
                          setState(() {
                            coordinates[i]['lat'] = position.latitude;
                            coordinates[i]['long'] = position.longitude;
                          });
                        } catch (e) {
                          print('Error obtaining location: $e');
                        }
                      },
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text(''),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (coordinates.length < 5)
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() {
                        coordinates.add({'lat': 0.0, 'long': 0.0});
                      }),
                    ),
                  if (coordinates.length >= 5)
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() {
                        coordinates.add({'lat': 0.0, 'long': 0.0});
                      }),
                    ),
                  if (coordinates.length >= 5)
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => setState(() {
                        coordinates.removeLast();
                      }),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    ];
    Size size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      backgroundColor: Colors.green,
      body: (isLoading == false && result == false)
          ? Column(
              children: [
                SizedBox(
                  height: 275,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 90, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.green,
                          backgroundImage: AssetImage(
                            'assets/splash.png',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Climagrow Bot',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 32),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      height: height - 275 - 80,
                      width: size.width,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 214, 214, 214),
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(40))),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: count,
                        itemBuilder: (context, index) {
                          return questions[index];
                        },
                      )),
                ),
                Container(
                  color: const Color.fromARGB(255, 214, 214, 214),
                  height: 80,
                ),
              ],
            )
          : (result == false)
              ? const CircularProgressIndicator()
              : Container(
                  height: height,
                  width: size.width,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                          height: 250,
                          width: size.width,
                          color: Colors.green,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          AssetImage('assets/kisan_helper.jpg'),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                    'Climagrow has calculated and here are the results!',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16, color: Colors.white),
                                  )),
                                ],
                              ),
                              Text(
                                'Results',
                                style: GoogleFonts.poppins(
                                    fontSize: 36, color: Colors.white),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  )),
    );
  }

  void addRow() {
    setState(() {
      coordinates.add({'lat': 0.0, 'long': 0.0});
    });
  }

  void deleteRow(int index) {
    setState(() {
      coordinates.removeAt(index);
    });
  }
}
