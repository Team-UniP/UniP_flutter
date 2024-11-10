import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PartyService {
  static const String baseUrl =
      'https://port-0-unip-server-fork-lxfol2lf38345220.sel5.cloudtype.app';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> fetchParties() async {
    try {
      // 안전 저장소에서 accessToken 가져오기
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      // API 요청
      final response = await http.get(
        Uri.parse('$baseUrl/party'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print("Status Code: ${response.statusCode}");

      // 응답 본문을 UTF-8로 디코딩하여 한글 처리
      final decodedBody = utf8.decode(response.bodyBytes);
      print("Decoded Response Body: $decodedBody");

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);

        // 전체 응답 출력
        print("Fetched Data: $data");

        // data 필드가 리스트인지 확인 후 반환
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception(
              "Unexpected API response format: 'data' field missing or not a List");
        }
      } else {
        throw Exception("Failed to load parties: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching parties: $e");
      return [];
    }
  }
}
