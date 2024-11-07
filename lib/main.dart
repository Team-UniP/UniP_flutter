import 'package:capstone_v1/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/screens/main_screen.dart';

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
      home: StartScreen(), // mainPageKey 설정
    );
  }
}
