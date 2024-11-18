import 'package:flutter/material.dart';
import 'package:capstone_v1/dto/chat_log.dart';
import 'package:capstone_v1/dto/chat_room.dart';
import 'package:capstone_v1/service/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoom chatRoom; // ChatRoom 필드

  ChatScreen({required this.chatRoom});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatLog> messages = [];  // 메시지 리스트
  ChatApi chatApi = ChatApi();
  int page = 0; // 페이지 번호
  bool isLoading = false; // 로딩 상태 체크

  // 메시지 가져오기
  Future<void> fetchMessages() async {
    if (isLoading) return; // 로딩 중에는 중복 호출 방지
    setState(() {
      isLoading = true;
    });

    try {
      String roomId = widget.chatRoom.id;
      // API에서 ChatLog 객체 리스트 가져오기
      List<ChatLog> fetchedMessages = await chatApi.getChatLogs(roomId, page);

      // 상태 업데이트
      setState(() {
        messages.addAll(fetchedMessages);  // 새로운 메시지를 앞쪽에 추가
        page++; // 페이지 번호 증가
      });
    } catch (error) {
      print("API 호출 중 오류 발생: $error");
    } finally {
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
  }

  // 스크롤이 최상단에 도달했을 때 호출되는 메서드
  void _onScroll() {
    // ListView의 스크롤 위치가 최상단에 도달하면 더 많은 메시지를 로드
    if (isLoading) return;  // 로딩 중이면 추가 API 호출 방지

    final scrollPosition = _scrollController.position;
    if (scrollPosition.atEdge && scrollPosition.pixels == 0) {
      // 최상단에 도달했을 때 API 호출
      fetchMessages();
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    _scrollController.addListener(_onScroll); // 스크롤 이벤트 리스너 추가
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // 리스너 제거
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEDEF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.purple, size: 30),
                onPressed: () {
                  // 메뉴 액션
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.chatRoom.title, // chatRoom의 제목 필드 사용
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left, // 좌측 정렬
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14.0),
              padding: const EdgeInsets.all(10.0),
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
              child: ListView.builder(
                controller: _scrollController, // 스크롤 컨트롤러 연결
                reverse: true, // 리스트 역순으로 표시
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageRow(
                      messages[index].sender,
                      messages[index].content,
                      messages[index].senderImage,
                      messages[index].isLeft
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '메시지 입력',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 메시지 전송 액션
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC29FF0),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    '입력',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  // 메시지 행을 생성하는 메서드
  Widget _buildMessageRow(String name, String message, String profileImage, bool isLeftAligned) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment:
        isLeftAligned ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeftAligned) _buildProfileIcon(name, profileImage),
          Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
              color: Color(0xFFE9D7FC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!isLeftAligned) _buildProfileIcon(name, profileImage),
        ],
      ),
    );
  }

  // 프로필 아이콘을 생성하는 메서드
  Widget _buildProfileIcon(String name, String profileImage) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(profileImage),
          radius: 20,
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
