import 'dart:convert';

import 'package:api_task_app/screens/subscribers_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;


class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  List<dynamic> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    // Initial call to sign in and fetch subscriptions
    // Can be removed if you want to start the process on button click only
    // signInAndFetchSubscriptions();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['https://www.googleapis.com/auth/youtube.readonly'],
  );

  Future<void> signInAndFetchSubscriptions() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await account?.authentication;
      final accessToken = googleAuth?.accessToken;

      if (accessToken != null) {
        String? nextPageToken = '';
        List<dynamic> allSubscriptions = [];

        // Loop to handle pagination
        do {
          final response = await http.get(
            Uri.parse(
              'https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&mine=true&pageToken=$nextPageToken&maxResults=50',
            ),
            headers: {'Authorization': 'Bearer $accessToken'},
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            allSubscriptions.addAll(data['items']);
            nextPageToken = data['nextPageToken'];
          } else {
            print('Failed to fetch subscriptions: ${response.statusCode}');
            print('Response body: ${response.body}');
            nextPageToken = null; // Stop the loop on error
          }
        } while (nextPageToken != null);

        setState(() {
          _subscriptions = allSubscriptions;
          _isLoading = false;

          // Navigate to SubscriptionListScreen with the fetched data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SubscriptionListScreen(subscriptions: _subscriptions),
            ),
          );
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Login'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  foregroundColor: Colors.white, // Text color
                  shadowColor: Colors.blueAccent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  minimumSize: Size(200, 50), // Set minimum size
                ),
                child: Text('Sign in with Google'),
                onPressed: () {
                  signInAndFetchSubscriptions();
                },
              ),
      ),
    );
  }
}