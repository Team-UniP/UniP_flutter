import 'package:capstone_v1/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/screens/auth_screen.dart';
import 'package:capstone_v1/screens/chat_screen.dart';
import 'package:capstone_v1/screens/chatlist_screen.dart';
import 'package:capstone_v1/screens/friends_screen.dart';
import 'package:capstone_v1/screens/login_screen.dart';
import 'package:capstone_v1/screens/notification_screen.dart';
import 'package:capstone_v1/screens/party_detail_screen.dart';
import 'package:capstone_v1/screens/party_screen.dart';
import 'package:capstone_v1/screens/route_screen.dart';
import 'package:capstone_v1/screens/routerequest_screen.dart';
import 'package:capstone_v1/screens/mypage_screen.dart';
import 'package:capstone_v1/screens/home_screen.dart';
import 'package:capstone_v1/screens/create_party_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenSelector(), // Set the ScreenSelector as the initial screen
    );
  }
}

class ScreenSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Selector'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildScreenButton(context, 'Start Screen', StartScreen()),
          _buildScreenButton(context, 'Login Screen', LoginScreen()),
          _buildScreenButton(
              context, 'Auth Screen', AccountVerificationScreen()),
          _buildScreenButton(context, 'Home Screen', HomeScreen()),
          _buildScreenButton(context, 'Mypage Screen', MyPageScreen()),
          _buildScreenButton(context, 'Chat Screen', ChatScreen()),
          _buildScreenButton(context, 'Chat List Screen', ChatlistScreen()),
          _buildScreenButton(context, 'Friends Screen', FriendsScreen()),
          _buildScreenButton(
              context, 'Notification Screen', NotificationScreen()),
          _buildScreenButton(
              context, 'Create Party Screen', CreatePartyScreen()),
          _buildScreenButton(
              context, 'Party Detail Screen', PartyDetailScreen()),
          _buildScreenButton(context, 'Party Screen', PartyScreen()),
          _buildScreenButton(
              context, 'Route Screen', RouteRecommendationScreen()),
          _buildScreenButton(
              context, 'Route Request Screen', RouteRequestScreen()),
        ],
      ),
    );
  }

  Widget _buildScreenButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Text(title),
      ),
    );
  }
}
