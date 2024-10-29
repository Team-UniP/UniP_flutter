import 'package:capstone_v1/screens/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class RouteRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI 루트 추천',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search hint
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFFFEE500),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'ex : 두정동 추천해줘, 두정동 술집만 추천해줘',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // White container for route recommendations or map
            Container(
              width: double.infinity,
              height: 518,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              // Content for route recommendation/map goes here
            ),
            const SizedBox(height: 10),

            // Input field container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '내용 입력',
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Request button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle request action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDFBFFF),
                  padding: EdgeInsets.symmetric(horizontal: 140, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  '요청',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
