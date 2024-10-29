import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xEFD5AEFD), // Background color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 150), // Adjust this as needed
                child: Image.asset(
                  'assets/image/startlogo.png', // Replace with your actual path
                  width: 212.5,
                  height: 479,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
