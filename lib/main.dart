import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClimaGrow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const NavBar(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return const NavBar();
          } else {
            return const LoginPage();
          }
        }
      },
    );
  }
}
