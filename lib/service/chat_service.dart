import 'dart:convert';
import 'package:capstone_v1/dto/chat_log.dart';
import 'package:capstone_v1/dto/chat_room.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:capstone_v1/url/api_uri.dart';
import 'package:capstone_v1/url/image_url.dart';

class ChatApi {
  static const String getChatURL = '${ApiInfo.chatBaseUrl}${ApiInfo.chatRooms}';
  static const String getChatLogURL = '${ApiInfo.chatBaseUrl}${ApiInfo.chatLogs}';
  static const String sendChatMessage='${ApiInfo.chatBaseUrl}${ApiInfo.sendChat}';
  static const String participateInChatRoom="${ApiInfo.chatBaseUrl}${ApiInfo.participateChatRoom}";

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  //채팅방 전체 조회하는 메소드
  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.get(
        Uri.parse('$getChatURL'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          // Mapping API response data to List<ChatRoom>
          List<ChatRoom> chatRooms = (data['data'] as List)
              .map((chatRoomJson) => ChatRoom.fromJson(chatRoomJson))
              .toList();
          return chatRooms;
        } else {
          throw Exception(
              "Unexpected API response format: 'data' field missing or not a List");
        }
      } else {
        throw Exception("Failed to load chat rooms: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching chat rooms: $e");
      return [];
    }
  }

  //특정 채팅방의 채팅 로그를 조회하는 메소드
  Future<List<ChatLog>> getChatLogs(String roomId, int page) async {
    print("page=$page");
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.get(
        Uri.parse('$getChatLogURL/$roomId?page=$page&size=10'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      final decodedBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          // Mapping API response data to List<ChatRoom>
          List<ChatLog> chatLogs = (data['data'] as List)
              .map((chatLogJson) => ChatLog.fromJson(chatLogJson))
              .toList();
          print(chatLogs.toString());
          return chatLogs;
        } else {
          throw Exception(
              "Unexpected API response format: 'data' field missing or not a List");
        }
      } else {
        throw Exception("Failed to load chat rooms: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching chat rooms: $e");
      return [];
    }
  }

  Future<bool> sendMessage(String message, String roomId) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final response = await http.post(
        Uri.parse('$sendChatMessage/$roomId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message), // JSON으로 인코딩된 요청 본문
      );

      if (response.statusCode == 200) {
        print("SUCCESS ON SENDING CHAT");
        return true;
      } else {
        print("Failed to SEND CHAT: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error creating party: $e");
      return false;
    }
  }

  Future<bool> makeChatRoom(String title,int partyId) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }

      final Map<String, dynamic> message = {
        "partyDto": {
          "title": title,
          "partyId": partyId,
        },
      };

      final response = await http.post(
        Uri.parse('$getChatURL'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message), // JSON으로 인코딩된 요청 본문
      );

      if (response.statusCode == 200) {
        print("SUCCESS ON SENDING CHAT");
        return true;
      } else {
        print("Failed to SEND CHAT: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error creating party: $e");
      return false;
    }
  }

  Future<bool> participateChatRoom(int partyId) async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception("Access token not found.");
      }


      final response = await http.post(
        Uri.parse('$participateInChatRoom/$partyId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("SUCCESS ON Participating CHAT");
        return true;
      } else {
        print("Failed to Participate CHAT: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error participating chat: $e");
      return false;
    }
  }
}
