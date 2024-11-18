import 'package:capstone_v1/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:capstone_v1/service/chat_service.dart'; // ChatApi와 ChatRoom 클래스 import
import 'package:capstone_v1/dto/chat_room.dart';
import 'package:capstone_v1/url/image_url.dart';

class ChatlistScreen extends StatefulWidget {
  @override
  _ChatlistScreenState createState() => _ChatlistScreenState();
}

class _ChatlistScreenState extends State<ChatlistScreen> {
  late Future<List<ChatRoom>> _chatRoomsFuture;
  ChatApi chatApi = ChatApi();

  String getFilterImage(String partyType) {
    switch (partyType) {
      case 'RESTAURANT':
        return 'assets/image/foodfilter.png';
      case 'BAR':
        return 'assets/image/drinkfilter.png';
      case 'COMPREHENSIVE':
        return 'assets/image/totalfilter.png';
      default:
        return 'assets/image/defaultfilter.png'; // 기본 이미지 경로
    }
  }

  @override
  void initState() {
    super.initState();
    _chatRoomsFuture = chatApi.getChatRooms(); // API 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black, size: 30),
              onPressed: () {
                // Add action
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
                right: 14.0,
              ),
              child: Text(
                '채팅',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // FutureBuilder를 사용해 비동기 데이터 처리
          Expanded(
            child: FutureBuilder<List<ChatRoom>>(
              future: _chatRoomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // 로딩 중
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}')); // 에러 발생
                } else if (snapshot.hasData) {
                  List<ChatRoom> chatRooms = snapshot.data!;

                  return ListView.builder(
                    itemCount: chatRooms.length,
                    itemBuilder: (context, index) {
                      return _buildPartyCard(chatRooms[index]);
                    },
                  );
                } else {
                  return Center(
                      child: Text('No chat rooms available')); // 데이터 없음
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyCard(ChatRoom chatRoom) {
    return GestureDetector(
      onTap: () {
        print("방 id:${chatRoom.id}");
        // 카드 클릭 시 채팅방 UI로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoom: chatRoom),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(chatRoom.partyChiefImageUrl),
                    radius: 28,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    chatRoom.partyChiefName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        chatRoom.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0.10,
                          letterSpacing: -0.17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        getFilterImage(chatRoom.partyType),
                        width: 61,
                        height: 33,
                        fit: BoxFit.contain,
                      ),
                      Column(
                        children: [
                          Text(
                            '시작시간',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '종료시간',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            chatRoom.startTime.toString(),
                            style: TextStyle(
                              color: Color(0xEFB46EFB),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            chatRoom.endTime.toString(),
                            style: TextStyle(
                              color: Color(0xEFB46EFB),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${chatRoom.nowCounted}/${chatRoom.totalCounted}',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



}
