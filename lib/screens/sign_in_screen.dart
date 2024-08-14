import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'subscribers_screen.dart';
import '../services/google_sign_in_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add a logo or icon
                Icon(
                  Icons.account_circle,
                  size: 100.0,
                  color: Colors.white,
                ),
                SizedBox(height: 30.0),
                Text(
                  'Welcome to ApiTaskApp',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    final user = await GoogleSignInService.signInWithGoogle();
                    if (user != null) {
                      // Navigate to Subscribers Screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SubscribersScreen(user: user, accessToken: '',)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    // primary: Colors.white,
                    // onPrimary: Colors.blue,
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Sign in with Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
