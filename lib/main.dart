import 'package:capstone_v1/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  print('Loaded Kakao API Key: ${dotenv.env['APP_KEY']}');

  AuthRepository.initialize(
      appKey: dotenv.env['APP_KEY'] ?? '',
      baseUrl: dotenv.env['BASE_URL'] ?? '');
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
