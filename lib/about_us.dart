import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AboutUsState();
  }
}

class AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            width: width,
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 80,
                    foregroundColor: Colors.green,
                    backgroundImage: AssetImage('assets/splash.png'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Contact Us',
                  style: GoogleFonts.varelaRound(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              'Contact Us',
              style: GoogleFonts.poppins(fontSize: 22, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Colors.green),
                      Text(
                        ' Email:  ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () async {
                          _launchemailURL('rchavez@usm.edu.ph');
                          setState(() {});
                        },
                        child: const Text(
                          'rchavez.usm.edu.ph',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.green),
                      Text(
                        ' Phone Number: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      const InkWell(
                        child: Text(
                          '+639989265541',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.location_pin, color: Colors.green),
                      Text(
                        ' Address: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      const InkWell(
                        child: Text(
                          'Matanao, Davao del Sur',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.green),
                      Text(
                        ' Leave a Review: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          const String googleFormUrl =
                              'https://docs.google.com/forms/d/e/1FAIpQLSdn00kuCzjsIXfODZDIpQaRgRemfOCa5a_ZXUCJrl3SmDlQyg/viewform?usp=sf_link';
                          launch(googleFormUrl);
                        },
                        child: const Text(
                          'Google Form Link',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.link, color: Colors.green),
                      Text(
                        ' Try Our Web App Here: ',
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          const String googleFormUrl =
                              'https://yodelling-tricia-agribuddy.koyeb.app/';
                          launch(googleFormUrl);
                        },
                        child: const Text(
                          'climagrow.com',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  void _launchemailURL(String url1) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: url1,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
