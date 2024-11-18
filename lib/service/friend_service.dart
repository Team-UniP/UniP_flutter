import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FriendService {
  static const String baseUrl =
      'https://port-0-unip-server-fork-lxfol2lf38345220.sel5.cloudtype.app';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<List<dynamic>> fetchFriends() async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.get(
        Uri.parse('$baseUrl/friend'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        return data['data'];
      } else {
        throw Exception("Failed to load parties: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching parties: $e");
      return [];
    }
  }
}
