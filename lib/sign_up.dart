import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        throw 'Please fill out all fields';
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        throw 'Passwords do not match';
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user == null) {
        throw 'Sign up failed';
      }

      // Navigate to Login page after successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (error) {
      _showErrorSnackBar('$error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      }
    } catch (error) {
      _showErrorSnackBar('Error signing in with Google: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 30,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10.0),
                    Image.asset(
                      'assets/logo.png',
                      height: 250,
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: _signUp,
                        child: const Text('Submit'),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton.icon(
                        onPressed: _signInWithGoogle,
                        icon: const Icon(Icons.mail_outline_outlined),
                        label: const Text('Sign Up with Google'),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
    );
  }
}
