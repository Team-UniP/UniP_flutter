import 'package:capstone_v1/screens/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black, size: 30),
              onPressed: () {
                // Add action
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First instance of the text without padding
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
                right: 14.0,
              ), // Optional padding if needed on sides
              child: Text(
                '친구',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Second instance within the scrollable view and padding
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFriendCard('윤병호', 'https://via.placeholder.com/40x40'),
                  const SizedBox(height: 10),
                  _buildFriendCard('윤병호', 'https://via.placeholder.com/40x40'),
                  const SizedBox(height: 10),
                  _buildFriendCard('윤병호', 'https://via.placeholder.com/40x40'),
                  SizedBox(height: 80),

                  // Add more widgets as needed
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}

Widget _buildFriendCard(String name, String imageUrl) {
  return Container(
    width: 400,
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/image/profileicon.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 13),
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.17,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: Color(0xFFFFFBEA),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(width: 1, color: Color(0xFFB56EFB)),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Color(0xFF12E51A),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '놀아줘',
                style: TextStyle(
                  color: Color(0xFFB56EFB),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.13,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
