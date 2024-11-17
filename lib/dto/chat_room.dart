import 'package:uuid/uuid.dart';

class ChatRoom {
  final String id;
  final String title;
  final String partyType;
  final String startTime;
  final String endTime;
  final String partyChiefName;
  final String partyChiefImageUrl;
  final int nowCounted;
  final int totalCounted;

  ChatRoom({
      required this.id,
      required this.title,
      required this.partyType,
      required this.startTime,
      required this.endTime,
      required this.partyChiefName,
      required this.partyChiefImageUrl,
      required this.nowCounted,
      required this.totalCounted
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      title: json['title'],
      partyType: json['partyType'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      partyChiefName: json['partyChiefName'],
      partyChiefImageUrl: json['partyChiefImageUrl'],
      nowCounted: json['nowCounted'],
      totalCounted: json['totalCounted']
    );
  }
}
