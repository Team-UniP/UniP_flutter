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

  Future<bool> createParty(Map<String, dynamic> partyData) async {
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

      if (response.statusCode == 200) {
        print("Party created successfully!");
        return true;
      } else {
        print("Failed to create party: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error creating party: $e");
      return false;
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
}
