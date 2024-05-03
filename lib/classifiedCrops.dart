import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ClassifiedList extends StatefulWidget {
  const ClassifiedList({Key? key}) : super(key: key);

  @override
  _ClassifiedListState createState() => _ClassifiedListState();
}

class _ClassifiedListState extends State<ClassifiedList> {
  List<Map<String, dynamic>> classifiedData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        QuerySnapshot querySnapshot = await firestore
            .collection('data')
            .where('userId', isEqualTo: user.uid)
            .get();

        setState(() {
          classifiedData = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        print('No user signed in.');
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.green[200],
      ),
      backgroundColor: Colors.green[200],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : classifiedData.isEmpty
              ? const Center(child: Text('No classified data available'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: classifiedData.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = classifiedData[index];
                          List<dynamic> recommendedCrops = data['classified'];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            elevation: 2.0,
                            child: ExpansionTile(
                              title: Text(
                                '  ${data['title']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              tilePadding: EdgeInsets.zero,
                              backgroundColor: Colors.grey[100],
                              children: [
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (recommendedCrops[0]['crop'] ==
                                          'banana')
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
                                      else if (recommendedCrops[0]['crop'] ==
                                          'cacao')
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
                                      else if (recommendedCrops[0]['crop'] ==
                                          'coffee')
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
                                      else if (recommendedCrops[0]['crop'] ==
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
                                      else if (recommendedCrops[0]['crop'] ==
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
                                      else if (recommendedCrops[0]['crop'] ==
                                          'mango')
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
                                      else if (recommendedCrops[0]['crop'] ==
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
                                      else if (recommendedCrops[0]['crop'] ==
                                          'rice')
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
                                      else if (recommendedCrops[0]['crop'] ==
                                          'corn')
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
                                      else if (recommendedCrops[0]['crop'] ==
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
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${recommendedCrops[0]['crop']}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            '${double.parse(recommendedCrops[0]['probability'].toString()).toStringAsFixed(2)}%',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        '${(data['coordinate']['lat']).toStringAsFixed(6)}, ${(data['coordinate']['long']).toStringAsFixed(6)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      ExpansionTile(
                                        title: const Text(
                                          'Other Recommended Crops',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        tilePadding: EdgeInsets.zero,
                                        children: List.generate(
                                          recommendedCrops.length - 1,
                                          (index) {
                                            final crop =
                                                recommendedCrops[index + 1];
                                            return ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              title: Text(
                                                'Top ${index + 2}: ${crop['crop']}: ${double.parse(crop['probability'].toString()).toStringAsFixed(2)}%',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      ExpansionTile(
                                        title: const Text(
                                          'Parameters',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        children: [
                                          ListTile(
                                            title: Text(
                                              'Temperature: ${double.parse(data['parameters']['temperature'].toString()).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Relative Humidity: ${double.parse(data['parameters']['relative humidity'].toString()).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Precipitation: ${double.parse(data['parameters']['precipitation'].toString()).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Elevation: ${double.parse(data['parameters']['elevation'].toString()).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Slope: ${double.parse(data['parameters']['slope'].toString()).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
    );
  }
}
