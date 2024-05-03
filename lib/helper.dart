// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Helper extends StatefulWidget {
  const Helper({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HelperState();
  }
}

class HelperState extends State<Helper> {
  double centerLat = 0.0,
      centerLong = 0.0,
      avgElevation = 0.0,
      slope = 0.0,
      avgMaxTemp = 0.0,
      avgMinTemp = 0.0,
      avgRH = 0.0,
      totalPrecip = 0.0,
      finalTemp = 0.0,
      finalSlope = 0.0;
  int temperature = 0, slp = 0, count = 1;
  List<Map<String, double>> coordinates = [
    {'lat': 0.0, 'long': 0.0},
    {'lat': 0.0, 'long': 0.0},
  ];

  List<dynamic> predictions = [];

  String _loadingText = '', title = '', crop = '';
  bool isBotOff = false,
      result = false,
      isTopographyProcessing = false,
      isWeatherProcessing = false,
      isClassifying = false,
      btn = false;

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
                  width: 20,
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
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    child: const Center(
                      child: Text(
                        'Can I get you location?',
                        style: TextStyle(color: Colors.white, fontSize: 16.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          btn
              ? const SizedBox()
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Click the button to start.',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
            child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    count = 2;
                    setState(() {
                      btn = true;
                    });
                  },
                  child: const Text('Yes, you can.'),
                )),
          ),
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
                  width: 20,
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
                    width: 220,
                    height: 65,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 5, 10),
                        child: Text(
                          'Please plot the coordinate of your land.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < coordinates.length; i++)
            Padding(
              padding: const EdgeInsets.all(10),
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
                      width: 75,
                      child: TextField(
                        controller: TextEditingController(
                            text: coordinates[i]['lat'].toString()),
                        onChanged: (value) {
                          coordinates[i]['lat'] =
                              double.tryParse(value) ?? 0.00;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    const SizedBox(
                      width: 50,
                      child: Text("Long:"),
                    ),
                    SizedBox(
                      width: 75,
                      child: TextField(
                        controller: TextEditingController(
                            text: coordinates[i]['long'].toString()),
                        onChanged: (value) {
                          coordinates[i]['long'] =
                              double.tryParse(value) ?? 0.0;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
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
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (coordinates.length < 2)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            coordinates.add({'lat': 0.00, 'long': 0.00});
                          });
                        },
                      ),
                    ),
                  if (coordinates.length >= 2)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            coordinates.add({'lat': 0.00, 'long': 0.00});
                          });
                        },
                      ),
                    ),
                  const SizedBox(width: 10),
                  if (coordinates.length >= 2)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.remove),
                        color: Colors.white, // Icon color
                        onPressed: () {
                          setState(() {
                            coordinates.removeLast();
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
            child: Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: isTopographyProcessing
                    ? null
                    : () async {
                        setState(() {
                          isTopographyProcessing = true;
                          _loadingText = 'Extracting Topographical Data...';
                        });
                        List<Map<String, dynamic>> elevationData = [];
                        for (var coord in coordinates) {
                          final response = await http.get(Uri.parse(
                              'https://api.open-elevation.com/api/v1/lookup?locations=${coord['lat']},${coord['long']}'));
                          if (response.statusCode == 200) {
                            final elevation =
                                json.decode(response.body)['results'][0];
                            elevationData.add({
                              'latitude': elevation['latitude'],
                              'longitude': elevation['longitude'],
                              'elevation': elevation['elevation'].toDouble()
                            });
                          }
                        }
                        double sumLat = 0, sumLong = 0;
                        for (var coord in elevationData) {
                          sumLat += coord['latitude'];
                          sumLong += coord['longitude'];
                        }
                        centerLat = sumLat / elevationData.length;
                        centerLong = sumLong / elevationData.length;
                        double sumElevation = 0;
                        for (var coord in elevationData) {
                          sumElevation += coord['elevation'];
                        }
                        avgElevation = sumElevation / elevationData.length;

                        int indexOfMaxElevation = 0;
                        for (int i = 1; i < elevationData.length; i++) {
                          if (elevationData[i]['elevation'] >
                              elevationData[indexOfMaxElevation]['elevation']) {
                            indexOfMaxElevation = i;
                          }
                        }
                        int indexOfMinElevation = 0;
                        for (int i = 1; i < elevationData.length; i++) {
                          if (elevationData[i]['elevation'] <
                              elevationData[indexOfMinElevation]['elevation']) {
                            indexOfMinElevation = i;
                          }
                        }

                        if (elevationData.length == 1) {
                          slope = 0.00;
                        } else {
                          double distance = calculateDistance(
                              elevationData[indexOfMaxElevation]['latitude'],
                              elevationData[indexOfMaxElevation]['longitude'],
                              elevationData[indexOfMinElevation]['latitude'],
                              elevationData[indexOfMinElevation]['longitude']);

                          if (distance != 0) {
                            double distanceMeter = distance * 1000;
                            double slopeRatio =
                                (elevationData[indexOfMaxElevation]
                                            ['elevation'] -
                                        elevationData[indexOfMinElevation]
                                            ['elevation']) /
                                    distanceMeter;
                            slope = math.atan(slopeRatio) * (180 / math.pi);
                          } else {
                            slope = 0.00;
                          }
                        }
                        count = 3;
                        setState(() {
                          isTopographyProcessing = false;
                        });
                      },
                child: Text('Done'),
              ),
            ),
          ),
          isTopographyProcessing
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(
                        _loadingText,
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
      Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 170,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Center coordinates',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 190,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '${centerLat.toStringAsFixed(6)}, ${centerLong.toStringAsFixed(6)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 130,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Elevation(m): ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: TextFormField(
                    initialValue: avgElevation.toStringAsFixed(2),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      avgElevation = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 80,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Slope: ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(10),
                child: Center(
                    child: TextFormField(
                  initialValue: slope.toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    slope = double.tryParse(value) ?? 0.0;
                  },
                )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: isWeatherProcessing
                    ? null
                    : () async {
                        setState(() {
                          isWeatherProcessing = true;
                          _loadingText = 'Extracting Weather Data...';
                        });
                        double centerLatitude = centerLat;
                        double centerLongitude = centerLong;

                        final url = Uri.parse(
                            'https://api.open-meteo.com/v1/gfs?latitude=$centerLatitude&longitude=$centerLongitude&hourly=relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min,precipitation_sum,rain_sum,showers_sum&past_days=14&forecast_days=16');

                        try {
                          final response = await http.get(url);
                          if (response.statusCode == 200) {
                            final jsonData = json.decode(response.body);
                            if (jsonData.containsKey('daily') &&
                                jsonData.containsKey('hourly') &&
                                jsonData['daily'] is Map<String, dynamic> &&
                                jsonData['hourly'] is Map<String, dynamic>) {
                              final dailyData =
                                  jsonData['daily'] as Map<String, dynamic>;
                              final hourlyData =
                                  jsonData['hourly'] as Map<String, dynamic>;
                              double sumPrecipitation = 0.0;
                              double sumRain = 0.0;
                              double sumShowers = 0.0;
                              double sumRH = 0.0;
                              double countDaily = 0;
                              int countHourly = 0;
                              final hourlyRH =
                                  hourlyData['relative_humidity_2m'];
                              if (hourlyRH is List<dynamic>) {
                                for (final rh in hourlyRH) {
                                  if (rh != null) {
                                    sumRH += rh;
                                    countHourly++;
                                  }
                                }
                              } else {
                                print(
                                    'Error: Hourly relative humidity data is not in the expected format.');
                                return;
                              }
                              List<dynamic>? timeData = dailyData['time'];
                              List<dynamic>? maxTemps =
                                  dailyData['temperature_2m_max'];
                              List<dynamic>? minTemps =
                                  dailyData['temperature_2m_min'];
                              List<dynamic>? precipitationSum =
                                  dailyData['precipitation_sum'];
                              List<dynamic>? rainSum = dailyData['rain_sum'];
                              List<dynamic>? showersSum =
                                  dailyData['showers_sum'];
                              if (timeData != null &&
                                  maxTemps != null &&
                                  minTemps != null &&
                                  precipitationSum != null &&
                                  rainSum != null &&
                                  showersSum != null) {
                                for (int i = 0; i < timeData.length; i++) {
                                  double maxTemp =
                                      (maxTemps[i] ?? 0.0) as double;
                                  double minTemp =
                                      (minTemps[i] ?? 0.0) as double;
                                  double precip =
                                      (precipitationSum[i] ?? 0.0) as double;
                                  double rain = (rainSum[i] ?? 0.0) as double;
                                  double showers =
                                      (showersSum[i] ?? 0.0) as double;
                                  sumPrecipitation += precip;
                                  sumRain += rain;
                                  sumShowers += showers;
                                  countDaily++;
                                }
                                avgMaxTemp = maxTemps
                                        .cast<double>()
                                        .reduce((a, b) => a + b) /
                                    countDaily;
                                avgMinTemp = minTemps
                                        .cast<double>()
                                        .reduce((a, b) => a + b) /
                                    countDaily;
                                avgRH =
                                    countHourly > 0 ? sumRH / countHourly : 0.0;
                                totalPrecip =
                                    sumPrecipitation + sumRain + sumShowers;
                              } else {
                                print(
                                    'Error: Daily data not found or not in the expected format.');
                              }
                            } else {
                              print(
                                  'Error: Daily or hourly data not found or not in the expected format.');
                            }
                          } else {
                            print(
                                'Failed to load weather data: ${response.statusCode}');
                          }
                        } catch (e) {
                          print('Error fetching weather data: $e');
                        } finally {
                          count = 4;
                          setState(() {
                            isWeatherProcessing = false;
                          });
                        }
                      },
                child: const Text('Okay'),
              ),
            ),
          ),
          isWeatherProcessing
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 1),
                      Text(
                        _loadingText,
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
      Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 130,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Temperature:',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 35,
                    child: Text("Max:"),
                  ),
                  SizedBox(
                    width: 75,
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: TextFormField(
                          initialValue: avgMaxTemp.toStringAsFixed(2),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            avgMaxTemp = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const SizedBox(
                    width: 35,
                    child: Text("Min:"),
                  ),
                  SizedBox(
                    width: 75,
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: TextFormField(
                          initialValue: avgMinTemp.toStringAsFixed(2),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            avgMinTemp = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 160,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Relative Humidity: ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: TextFormField(
                    initialValue: avgRH.toStringAsFixed(2),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      avgRH = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 130,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Precipitation: ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: 80,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: TextFormField(
                    initialValue: totalPrecip.toStringAsFixed(2),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      totalPrecip = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
              child: ElevatedButton(
                onPressed: () {
                  count = 5;
                  setState(() {});
                },
                child: const Text('Nice'),
              ),
            ),
          ),
        ],
      ),
      Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 240,
                    height: 65,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Choose a Temperature to use for recommending a crop',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
              child: Container(
                height: 50,
                width: 220,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton<int>(
                        value: temperature,
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text("  Maximum Temperature"),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text("  Minimum Temperature"),
                          ),
                        ],
                        onChanged: (int? value) {
                          setState(() {
                            temperature = value!;
                          });
                        }),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
            child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (temperature == 0) {
                      finalTemp = avgMaxTemp;
                    } else if (temperature == 1) {
                      finalTemp = avgMinTemp;
                    }

                    count = 6;
                    setState(() {});
                  },
                  child: const Text('OK'),
                )),
          )
        ],
      ),
      Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
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
                    width: 180,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25)),
                    ),
                    child: const Center(
                      child: Text(
                        'Is this land terraced?',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
              child: Container(
                height: 50,
                width: 70,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton<int>(
                        value: slp,
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text("  Yes"),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text("  No"),
                          ),
                        ],
                        onChanged: (int? value) {
                          setState(() {
                            slp = value!;
                          });
                        }),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 20, 10),
            child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: isClassifying
                      ? null
                      : () async {
                          setState(() {
                            isClassifying = true;
                            _loadingText = 'Classifying a Crop...';
                          });

                          if (finalSlope == 0) {
                            finalSlope = slope;
                          } else {
                            finalSlope = 0;
                          }

                          String apiUrl =
                              'https://delicious-benedetta-usm.koyeb.app/predict?temp=$finalTemp&rh=$avgRH&precip=$totalPrecip&elevation=$avgElevation&slope=$finalSlope';

                          try {
                            final response = await http.get(Uri.parse(apiUrl));
                            final responseData = json.decode(response.body);

                            predictions = responseData['predictions'];
                          } catch (e) {
                            print('Error obtaining recommended crops: $e');
                          }

                          setState(() {
                            isClassifying = false;
                            isBotOff = true;
                            result = true;
                          });
                        },
                  child: const Text('Submit'),
                )),
          ),
          isClassifying
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(
                        _loadingText,
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    ];
    Size size = MediaQuery.of(context).size;
    var height = size.height;
    return Scaffold(
      backgroundColor: Colors.green,
      body: (isBotOff == false && result == false)
          ? Column(
              children: [
                SizedBox(
                  height: 240,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: 43),
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.green,
                              backgroundImage: AssetImage('assets/splash.png'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Image.asset(
                          'assets/title.png',
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: height - 275 - 80,
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: count,
                      itemBuilder: (context, index) {
                        return questions[index];
                      },
                    ),
                  ),
                ),
                Container(
                  color: Colors.white70,
                  height: 80,
                ),
              ],
            )
          : (result == false)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 240,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 50, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                SizedBox(width: 43),
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.green,
                                  backgroundImage:
                                      AssetImage('assets/splash.png'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Image.asset(
                              'assets/title.png',
                              width: 200,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  'Recommended Crop:',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (predictions[0]['crop'] == 'banana')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/1.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] == 'cacao')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/2.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] == 'coffee')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/3.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] ==
                                        'coconut')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/4.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] ==
                                        'watermelon')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/5.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] == 'mango')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/6.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] ==
                                        'sugarcane')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/7.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] == 'rice')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/8.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] == 'corn')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/9.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      )
                                    else if (predictions[0]['crop'] ==
                                        'groundnut')
                                      Column(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/10.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    const SizedBox(width: 30),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${predictions[0]['crop']}',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                        Text(
                                          '${predictions[0]['probability'].toStringAsFixed(2)}%',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'Top Predictions:',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildPredictionText(predictions, 1),
                                    _buildPredictionText(predictions, 2),
                                    _buildPredictionText(predictions, 3),
                                    _buildPredictionText(predictions, 4),
                                    _buildPredictionText(predictions, 5),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isBotOff = false;
                                          result = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text(
                                        'Back',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showTitleInputDialog(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue),
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPredictionText(List predictions, int index) {
    if (predictions.length > index) {
      return Text(
        '  Top ${index + 1}: ${predictions[index]['crop']} ${predictions[index]['probability'].toStringAsFixed(2)}%',
        style: TextStyle(
          fontSize: 20,
          color: Colors.green[800],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
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

  Future<void> _showTitleInputDialog(BuildContext context) async {
    String? title;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Title'),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (title != null && title!.isNotEmpty) {
                  saveDataToFirestore(title!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter a title.'),
                  ));
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveDataToFirestore(String title) async {
    try {
      await Firebase.initializeApp();

      FirebaseAuth auth = FirebaseAuth.instance;

      User? user = auth.currentUser;

      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        Map<String, dynamic> data = {
          'title': title,
          'coordinate': {'lat': centerLat, 'long': centerLong},
          'parameters': {
            'temperature': finalTemp,
            'relative humidity': avgRH,
            'precipitation': totalPrecip,
            'elevation': avgElevation,
            'slope': finalSlope,
          },
          'classified': predictions,
          'userId': user.uid,
        };

        await firestore.collection('data').add(data);

        print('Data saved to Firestore');
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Error saving data to Firestore: $e');
    }
  }
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // in kilometers

  // Convert degrees to radians
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);
  lat1 = _toRadians(lat1);
  lat2 = _toRadians(lat2);

  // Haversine formula
  double a =
      _haversin(dLat) + math.cos(lat1) * math.cos(lat2) * _haversin(dLon);
  double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  double distance = earthRadius * c;

  return distance; // in kilometers
}

double _toRadians(double degrees) {
  return degrees * math.pi / 180;
}

num _haversin(double val) {
  return math.pow(math.sin(val / 2), 2);
}
