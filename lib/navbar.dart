import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'about_us.dart';
import 'helper.dart';
import 'tips.dart';
import 'weather.dart';
import 'logout.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  int _currentIndex = 2;
  final List<Widget> _pages = [
    const LogoutDialog(),
    const Weather(),
    const Helper(),
    const Tips(),
    const AboutUs()
  ];

  void _setBottomBarIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green[200],
      body: Stack(
        children: [
          Center(
            child: _pages[_currentIndex],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: size.width,
              height: 80,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Column(
                    children: [
                      Center(
                        heightFactor: 0.6,
                        child: FloatingActionButton(
                          backgroundColor: Colors.redAccent,
                          child: const Icon(FontAwesomeIcons.gitlab),
                          elevation: 0.1,
                          onPressed: () {
                            _setBottomBarIndex(2);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (index) {
                          final isSelected = _currentIndex == index;
                          final icon = [
                            FontAwesomeIcons.signOutAlt,
                            FontAwesomeIcons.cloudSunRain,
                            null,
                            FontAwesomeIcons.list,
                            FontAwesomeIcons.mobile
                          ];
                          final title = [
                            'Logout',
                            'Weather',
                            'Recommend Crop',
                            'Tips',
                            'Contact'
                          ];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  icon[index],
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                                onPressed: () {
                                  _setBottomBarIndex(index);
                                },
                                splashColor: Colors.white,
                              ),
                              Text(
                                title[index],
                                style: GoogleFonts.didactGothic(
                                  fontSize: 14,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
