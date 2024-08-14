import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSignInService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/youtube.readonly',
    ],
  );

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print('Google Sign-In error: $error');
      return null;
    }
  }

  static Future<List<dynamic>> fetchSubscribedChannels(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&mine=true'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'] as List<dynamic>;
    } else {
      throw Exception('Failed to fetch subscribed channels: ${response.statusCode}');
    }
  }
}
