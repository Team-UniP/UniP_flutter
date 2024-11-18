import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MyInfoService {
  static const String baseUrl =
      'https://port-0-unip-server-fork-lxfol2lf38345220.sel5.cloudtype.app';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// 사용자 정보를 가져오는 함수
  Future<Map<String, dynamic>> fetchInfo() async {
    try {
      // Access token 가져오기
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      // API 호출
      final response = await http.get(
        Uri.parse('$baseUrl/member/my'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      // 응답 처리
      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        return data['data']; // "data" 부분만 반환
      } else {
        throw Exception(
            "Failed to fetch user info: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error fetching user info: $e");
      rethrow; // 에러를 다시 던짐
    }
  }
}
