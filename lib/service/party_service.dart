import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PartyService {
  static const String baseUrl =
      'https://port-0-unip-server-fork-lxfol2lf38345220.sel5.cloudtype.app';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> fetchParties() async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/party'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
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

  Future<int> createParty(Map<String, dynamic> partyData) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/party'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(partyData), // JSON으로 인코딩된 요청 본문
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          // 서버에서 'data' 필드에 숫자가 포함되어 있다고 가정
          return data['data'] as int;
        } else {
          throw Exception(
              "Unexpected API response format: 'data' field missing or not a number");
        }
      } else {
        throw Exception("Failed to create party: ${response.statusCode}");
      }
    } catch (e) {
      print("Error creating party: $e");
      return -1; // 오류 시 음수를 반환하여 실패를 나타냄
    }
  }

  Future<Map<String, dynamic>> fetchPartyDetail(int partyId) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/party/$partyId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          return data;
        } else {
          throw Exception("Unexpected API response format");
        }
      } else {
        throw Exception("Failed to load party detail: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching party detail: $e");
      return {}; // 빈 맵을 반환하여 오류 처리
    }
  }

  Future<Map<String, dynamic>?> GptRequest(String prompt) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/party/gpt'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"prompt": prompt}), // JSON으로 인코딩된 요청 본문
      );

      if (response.statusCode == 200) {
        print("GPT route creation successful!");

        // JSON 파싱
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 데이터 확인
        if (responseData["code"] == 200 && responseData["data"] != null) {
          final utf8Body = utf8.decode(response.bodyBytes);
          final responseData = jsonDecode(utf8Body);
          return responseData["data"];
        } else {
          print("Unexpected response format: ${response.body}");
          return null;
        }
      } else {
        print("Failed to create GPT route: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error creating GPT route: $e");
      return null;
    }
  }

  Future<bool> JoinParty(int partyId) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.post(
        Uri.parse('$baseUrl/pm/$partyId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        // JSON으로 인코딩된 요청 본문
      );

      if (response.statusCode == 200) {
        print("Party join successfully!");
        return true;
      } else {
        print("Failed to join party: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error join party: $e");
      return false;
    }
  }
}
