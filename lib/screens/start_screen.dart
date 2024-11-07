import 'package:capstone_v1/screens/home_screen.dart';
import 'package:capstone_v1/screens/login_screen.dart';
import 'package:capstone_v1/screens/main_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 HomeScreen으로 이동
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()), // HomeScreen으로 변경
      );
    });
  }

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

// HomeScreen 예제

