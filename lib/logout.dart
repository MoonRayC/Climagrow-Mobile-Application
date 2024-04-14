import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'helper.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.green[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/plant_sad.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to Logout?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text('Logout'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Helper()),
                      );
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
