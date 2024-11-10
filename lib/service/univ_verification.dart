import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UnivVerificationService {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  static const String baseUrl =
      "https://port-0-unip-server-fork-lxfol2lf38345220.sel5.cloudtype.app/univer";

  // 대학 이메일을 이용해 인증 요청 메서드
  Future<void> verifyUniv(String email) async {
    final String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      print('Access token is not available');
      return;
    }

    final Map<String, String> requestBody = {
      "email": email,
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Verification successful');
      final data = jsonDecode(response.body);
      print(data);
    } else {
      print('Verification failed: ${response.statusCode}');
      print('Error: ${response.body}');
    }
  }

  // 인증 코드 검증 요청 메서드
  Future<void> verifyAuthCode(String email, String authCode) async {
    final String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      print('Access token is not available');
      return;
    }

    final Map<String, String> requestBody = {
      "email": email,
      "authCode": authCode,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/au'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Auth code verification successful');
      final data = jsonDecode(response.body);
      print(data);
    } else {
      print('Auth code verification failed: ${response.statusCode}');
      print('Error: ${response.body}');
    }
  }
}
