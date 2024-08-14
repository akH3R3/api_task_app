import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/google_sign_in_service.dart';

class SubscribersScreen extends StatelessWidget {
  final String accessToken;

  SubscribersScreen({required this.accessToken, required GoogleSignInAccount user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribed Channels'),
      ),
      body: FutureBuilder(
        future: GoogleSignInService.fetchSubscribedChannels(accessToken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No subscribed channels found.'));
          }

          // Display the subscribed channels
          final channels = snapshot.data as List;

          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return ListTile(
                title: Text(channel['snippet']['title']),
                subtitle: Text(channel['snippet']['description']),
                leading: Image.network(channel['snippet']['thumbnails']['default']['url']),
              );
            },
          );
        },
      ),
    );
  }
}
